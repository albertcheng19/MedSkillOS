#!/usr/bin/env python3
"""Neural EMD preprocessing scaffold.

This script is deterministic and safe by default:
- reads only a local CSV input;
- writes only to the requested output directory;
- performs no network requests;
- performs no shell calls;
- uses installed EMD libraries when available, otherwise uses a simplified fallback.

The fallback EMD is intended for interface testing and toy data, not as a full
scientific replacement for mature EMD libraries.
"""

from __future__ import annotations

import argparse
import csv
import importlib
import json
import math
import os
from dataclasses import dataclass, asdict
from pathlib import Path
from typing import Any, Dict, List, Optional, Sequence, Tuple

import numpy as np


@dataclass
class IMFStats:
    channel: str
    imf_index: int
    energy: float
    energy_fraction: float
    amplitude_range: float
    zero_crossings: int
    freq_proxy_hz: float
    rejected: bool
    reject_reason: str


@dataclass
class ChannelReport:
    channel: str
    n_samples: int
    n_imfs: int
    retained_imfs: List[int]
    rejected_imfs: List[int]
    residual_included: bool
    retained_energy_fraction: float
    reconstruction_error: float
    warnings: List[str]


def parse_args() -> argparse.Namespace:
    parser = argparse.ArgumentParser(
        description="EMD-family preprocessing scaffold for neural time series."
    )
    parser.add_argument("--input", required=True, help="CSV input file.")
    parser.add_argument("--output", required=True, help="Output directory.")
    parser.add_argument("--fs", required=True, type=float, help="Sampling rate in Hz.")
    parser.add_argument(
        "--method",
        default="auto",
        choices=["auto", "emd", "eemd", "ceemdan", "mask-sift"],
        help="EMD-family method to request.",
    )
    parser.add_argument(
        "--library",
        default="auto",
        choices=["auto", "pyemd", "emd", "fallback"],
        help="Python implementation to request.",
    )
    parser.add_argument(
        "--channel-axis",
        default="samples_by_channels",
        choices=["samples_by_channels", "channels_by_samples"],
        help="CSV orientation.",
    )
    parser.add_argument("--max-imf", type=int, default=6, help="Maximum IMFs per channel.")
    parser.add_argument(
        "--reject-first",
        type=int,
        default=0,
        help="Reject this many highest-frequency leading IMFs during reconstruction.",
    )
    parser.add_argument(
        "--reject-last",
        action="store_true",
        help="Reject the last IMF or slow residual-like component during reconstruction.",
    )
    parser.add_argument(
        "--trials",
        type=int,
        default=50,
        help="Trials for EEMD or CEEMDAN when supported by the selected library.",
    )
    parser.add_argument(
        "--noise-width",
        type=float,
        default=0.05,
        help="Relative noise width for EEMD-style methods where supported.",
    )
    parser.add_argument("--seed", type=int, default=12345, help="Random seed.")
    parser.add_argument(
        "--write-cleaned",
        action="store_true",
        help="Write reconstructed cleaned signal as cleaned.csv.",
    )
    return parser.parse_args()


def read_csv_numeric(path: Path, channel_axis: str) -> Tuple[np.ndarray, List[str], List[str]]:
    warnings: List[str] = []
    with path.open("r", newline="") as f:
        sample = f.read(4096)
        f.seek(0)
        has_header = csv.Sniffer().has_header(sample) if sample.strip() else False
        reader = csv.reader(f)
        rows = list(reader)

    if not rows:
        raise ValueError("input CSV is empty")

    header: Optional[List[str]] = None
    data_rows = rows
    if has_header:
        header = [h.strip() or f"channel_{i+1}" for i, h in enumerate(rows[0])]
        data_rows = rows[1:]

    values: List[List[float]] = []
    for r_i, row in enumerate(data_rows, start=1 if not has_header else 2):
        if not row or all(not cell.strip() for cell in row):
            continue
        try:
            values.append([float(cell) for cell in row])
        except ValueError as exc:
            raise ValueError(f"non-numeric value in CSV row {r_i}") from exc

    arr = np.asarray(values, dtype=float)
    if arr.ndim != 2 or arr.size == 0:
        raise ValueError("input CSV must contain a numeric 2D table")
    if not np.all(np.isfinite(arr)):
        raise ValueError("input CSV contains nonfinite values")

    if channel_axis == "channels_by_samples":
        arr = arr.T
        if header and len(header) == arr.shape[0]:
            warnings.append("header looked like channel labels before transpose; generated generic labels")
            header = None

    n_channels = arr.shape[1]
    if header and len(header) == n_channels:
        names = header
    else:
        if header is not None and len(header) != n_channels:
            warnings.append("header length does not match channel count; generated generic labels")
        names = [f"channel_{i+1}" for i in range(n_channels)]
    return arr, names, warnings


def local_extrema(x: np.ndarray) -> Tuple[np.ndarray, np.ndarray]:
    if x.size < 3:
        return np.array([], dtype=int), np.array([], dtype=int)
    dx_prev = x[1:-1] - x[:-2]
    dx_next = x[1:-1] - x[2:]
    maxima = np.where((dx_prev >= 0) & (dx_next > 0) | ((dx_prev > 0) & (dx_next >= 0)))[0] + 1
    minima = np.where((dx_prev <= 0) & (dx_next < 0) | ((dx_prev < 0) & (dx_next <= 0)))[0] + 1
    return maxima.astype(int), minima.astype(int)


def interp_envelope(x: np.ndarray, extrema: np.ndarray) -> np.ndarray:
    n = x.size
    grid = np.arange(n)
    if extrema.size == 0:
        return np.full(n, float(np.mean(x)))
    xp = np.r_[0, extrema, n - 1]
    fp = np.r_[x[0], x[extrema], x[-1]]
    # Remove duplicated x positions while preserving first occurrence.
    uniq, idx = np.unique(xp, return_index=True)
    return np.interp(grid, uniq, fp[idx])


def zero_crossing_count(x: np.ndarray) -> int:
    centered = np.asarray(x, dtype=float)
    signs = np.sign(centered)
    signs[signs == 0] = 1
    return int(np.sum(signs[1:] != signs[:-1]))


def fallback_emd_1d(x: np.ndarray, max_imf: int = 6, max_sift: int = 20) -> Tuple[np.ndarray, np.ndarray]:
    """Small deterministic EMD-like fallback using linear envelopes.

    This is a scaffold. It is intentionally simple and should not be used as the
    main algorithm for publication-quality decomposition.
    """
    residual = np.asarray(x, dtype=float).copy()
    imfs: List[np.ndarray] = []
    eps = 1e-12

    for _ in range(max(0, max_imf)):
        max_idx, min_idx = local_extrema(residual)
        if max_idx.size + min_idx.size < 3:
            break
        proto = residual.copy()
        prev = proto.copy()
        for _sift in range(max_sift):
            max_idx, min_idx = local_extrema(proto)
            if max_idx.size < 2 or min_idx.size < 2:
                break
            upper = interp_envelope(proto, max_idx)
            lower = interp_envelope(proto, min_idx)
            mean_env = 0.5 * (upper + lower)
            proto = proto - mean_env
            zc = zero_crossing_count(proto)
            extrema_count = max_idx.size + min_idx.size
            sd = float(np.sum((prev - proto) ** 2) / (np.sum(prev ** 2) + eps))
            prev = proto.copy()
            if abs(extrema_count - zc) <= 1 and sd < 0.05:
                break
        if np.sqrt(np.mean(proto ** 2)) < eps:
            break
        imfs.append(proto)
        residual = residual - proto
        if local_extrema(residual)[0].size + local_extrema(residual)[1].size < 3:
            break

    if imfs:
        return np.vstack(imfs), residual
    return np.empty((0, x.size), dtype=float), residual


def try_decompose_pyemd(
    x: np.ndarray,
    method: str,
    max_imf: int,
    trials: int,
    noise_width: float,
    seed: int,
) -> Tuple[np.ndarray, np.ndarray, str, List[str]]:
    warnings: List[str] = []
    mod = importlib.import_module("PyEMD")
    chosen = method if method != "auto" else "ceemdan"

    if chosen == "eemd":
        cls = getattr(mod, "EEMD")
        obj = cls(trials=trials, noise_width=noise_width, parallel=False)
        if hasattr(obj, "noise_seed"):
            obj.noise_seed(seed)
        imfs = obj.eemd(x, max_imf=max_imf)
        residue = getattr(obj, "get_imfs_and_residue", lambda: (imfs, x - np.sum(imfs, axis=0)))()[1]
    elif chosen == "ceemdan":
        cls = getattr(mod, "CEEMDAN")
        obj = cls(trials=trials, epsilon=noise_width, parallel=False)
        if hasattr(obj, "noise_seed"):
            obj.noise_seed(seed)
        imfs = obj.ceemdan(x, max_imf=max_imf)
        if hasattr(obj, "get_imfs_and_residue"):
            imfs2, residue = obj.get_imfs_and_residue()
            imfs = imfs2
        else:
            residue = x - np.sum(imfs, axis=0)
    elif chosen in ("emd", "mask-sift"):
        if chosen == "mask-sift":
            warnings.append("PyEMD does not provide mask-sift here; used vanilla EMD")
        cls = getattr(mod, "EMD")
        obj = cls()
        imfs = obj.emd(x, max_imf=max_imf)
        residue = x - np.sum(imfs, axis=0) if imfs.size else x.copy()
        chosen = "emd"
    else:
        raise ValueError(f"unsupported PyEMD method: {method}")

    imfs = np.asarray(imfs, dtype=float)
    if imfs.ndim == 1:
        imfs = imfs.reshape(1, -1)
    residue = np.asarray(residue, dtype=float)
    if residue.ndim > 1:
        residue = residue.reshape(-1)[-x.size:]
    return imfs, residue, f"pyemd:{chosen}", warnings


def try_decompose_emd_package(
    x: np.ndarray,
    method: str,
    max_imf: int,
    trials: int,
    noise_width: float,
    seed: int,
) -> Tuple[np.ndarray, np.ndarray, str, List[str]]:
    warnings: List[str] = []
    sift_mod = importlib.import_module("emd.sift")
    chosen = method if method != "auto" else "complete_ensemble_sift"
    rng = np.random.default_rng(seed)
    # The emd package API varies by version. Use conservative kwargs and fall back.
    if chosen == "eemd":
        func = getattr(sift_mod, "ensemble_sift")
        imfs = func(x, nensembles=trials, ensemble_noise=noise_width, max_imfs=max_imf, noise_seed=seed)
    elif chosen == "ceemdan":
        func = getattr(sift_mod, "complete_ensemble_sift")
        try:
            imfs = func(x, nensembles=trials, ensemble_noise=noise_width, max_imfs=max_imf, noise_seed=seed)
        except TypeError:
            warnings.append("emd complete_ensemble_sift signature rejected noise_seed; retried without it")
            # Keep deterministic global behavior where possible.
            np.random.seed(int(rng.integers(0, 2**31 - 1)))
            imfs = func(x, nensembles=trials, ensemble_noise=noise_width, max_imfs=max_imf)
    elif chosen == "mask-sift":
        func = getattr(sift_mod, "mask_sift")
        imfs = func(x, max_imfs=max_imf)
    elif chosen == "emd":
        func = getattr(sift_mod, "sift")
        imfs = func(x, max_imfs=max_imf)
    else:
        func = getattr(sift_mod, "sift")
        imfs = func(x, max_imfs=max_imf)
        chosen = "emd"

    imfs = np.asarray(imfs, dtype=float)
    # emd package commonly returns shape samples x imfs.
    if imfs.ndim == 2 and imfs.shape[0] == x.size:
        imfs = imfs.T
    if imfs.ndim == 1:
        imfs = imfs.reshape(1, -1)
    residue = x - np.sum(imfs, axis=0) if imfs.size else x.copy()
    return imfs, residue, f"emd:{chosen}", warnings


def decompose_channel(
    x: np.ndarray,
    library: str,
    method: str,
    max_imf: int,
    trials: int,
    noise_width: float,
    seed: int,
) -> Tuple[np.ndarray, np.ndarray, str, List[str]]:
    warnings: List[str] = []
    if library in ("auto", "pyemd"):
        try:
            return try_decompose_pyemd(x, method, max_imf, trials, noise_width, seed)
        except Exception as exc:
            if library == "pyemd":
                raise
            warnings.append(f"PyEMD unavailable or failed: {type(exc).__name__}: {exc}")
    if library in ("auto", "emd"):
        try:
            return try_decompose_emd_package(x, method, max_imf, trials, noise_width, seed)
        except Exception as exc:
            if library == "emd":
                raise
            warnings.append(f"emd package unavailable or failed: {type(exc).__name__}: {exc}")
    imfs, residue = fallback_emd_1d(x, max_imf=max_imf)
    warnings.append("used simplified deterministic fallback EMD; not publication-grade")
    return imfs, residue, "fallback:simplified-emd", warnings


def summarize_imfs(
    channel: str,
    x_demeaned: np.ndarray,
    imfs: np.ndarray,
    fs: float,
    reject_first: int,
    reject_last: bool,
) -> List[IMFStats]:
    total_energy = float(np.sum(x_demeaned ** 2))
    if total_energy <= 0:
        total_energy = 1e-12
    out: List[IMFStats] = []
    n_imfs = int(imfs.shape[0])
    for idx in range(n_imfs):
        imf = imfs[idx]
        energy = float(np.sum(imf ** 2))
        zc = zero_crossing_count(imf)
        freq_proxy = float(zc * fs / (2.0 * max(1, imf.size)))
        rejected = False
        reasons: List[str] = []
        if idx < reject_first:
            rejected = True
            reasons.append("reject_first")
        if reject_last and idx == n_imfs - 1:
            rejected = True
            reasons.append("reject_last")
        out.append(
            IMFStats(
                channel=channel,
                imf_index=idx + 1,
                energy=energy,
                energy_fraction=float(energy / total_energy),
                amplitude_range=float(np.max(imf) - np.min(imf)) if imf.size else 0.0,
                zero_crossings=zc,
                freq_proxy_hz=freq_proxy,
                rejected=rejected,
                reject_reason=";".join(reasons),
            )
        )
    return out


def reconstruct_signal(
    x_raw: np.ndarray,
    imfs: np.ndarray,
    residue: np.ndarray,
    reject_first: int,
    reject_last: bool,
) -> Tuple[np.ndarray, List[int], List[int], bool, float, float]:
    mean = float(np.mean(x_raw))
    x_demeaned = x_raw - mean
    n_imfs = int(imfs.shape[0])
    rejected: List[int] = []
    retained: List[int] = []
    kept_components: List[np.ndarray] = []
    for i in range(n_imfs):
        reject = i < reject_first or (reject_last and i == n_imfs - 1)
        if reject:
            rejected.append(i + 1)
        else:
            retained.append(i + 1)
            kept_components.append(imfs[i])
    residual_included = not reject_last
    if residual_included:
        kept_components.append(residue)
    if kept_components:
        cleaned = np.sum(np.vstack(kept_components), axis=0) + mean
    else:
        cleaned = np.full_like(x_raw, mean)
    full_recon = (np.sum(imfs, axis=0) if n_imfs else np.zeros_like(x_raw)) + residue
    denom = float(np.sqrt(np.mean(x_demeaned ** 2))) or 1e-12
    reconstruction_error = float(np.sqrt(np.mean((x_demeaned - full_recon) ** 2)) / denom)
    retained_energy = float(np.sum((cleaned - mean) ** 2) / (np.sum(x_demeaned ** 2) + 1e-12))
    return cleaned, retained, rejected, residual_included, retained_energy, reconstruction_error


def write_imf_summary(path: Path, rows: Sequence[IMFStats]) -> None:
    fields = list(asdict(rows[0]).keys()) if rows else [
        "channel",
        "imf_index",
        "energy",
        "energy_fraction",
        "amplitude_range",
        "zero_crossings",
        "freq_proxy_hz",
        "rejected",
        "reject_reason",
    ]
    with path.open("w", newline="") as f:
        writer = csv.DictWriter(f, fieldnames=fields)
        writer.writeheader()
        for row in rows:
            writer.writerow(asdict(row))


def write_cleaned_csv(path: Path, data: np.ndarray, names: Sequence[str]) -> None:
    with path.open("w", newline="") as f:
        writer = csv.writer(f)
        writer.writerow(list(names))
        writer.writerows(data.tolist())


def write_markdown_report(path: Path, report: Dict[str, Any]) -> None:
    lines: List[str] = []
    lines.append("# Neural EMD Preprocessing Report")
    lines.append("")
    lines.append(f"- Incomplete: `{report['incomplete']}`")
    lines.append(f"- Method requested: `{report['parameters']['method']}`")
    lines.append(f"- Library requested: `{report['parameters']['library']}`")
    lines.append(f"- Sampling rate: `{report['parameters']['fs']}` Hz")
    lines.append(f"- Channels: `{report['input']['n_channels']}`")
    lines.append(f"- Samples: `{report['input']['n_samples']}`")
    lines.append("")
    if report["warnings"]:
        lines.append("## Warnings")
        for warning in report["warnings"]:
            lines.append(f"- {warning}")
        lines.append("")
    lines.append("## Channel summaries")
    for ch in report["channels"]:
        lines.append(f"### {ch['channel']}")
        lines.append(f"- Decomposition: `{ch.get('decomposition', 'unknown')}`")
        lines.append(f"- IMFs: `{ch['n_imfs']}`")
        lines.append(f"- Retained IMFs: `{ch['retained_imfs']}`")
        lines.append(f"- Rejected IMFs: `{ch['rejected_imfs']}`")
        lines.append(f"- Residual included: `{ch['residual_included']}`")
        lines.append(f"- Retained energy fraction: `{ch['retained_energy_fraction']:.6g}`")
        lines.append(f"- Reconstruction error: `{ch['reconstruction_error']:.6g}`")
        if ch.get("warnings"):
            for warning in ch["warnings"]:
                lines.append(f"- Warning: {warning}")
        lines.append("")
    lines.append("## Integrity note")
    lines.append(
        "This report describes a preprocessing operation only. It does not provide clinical diagnosis, treatment guidance, or causal neural interpretation."
    )
    path.write_text("\n".join(lines), encoding="utf-8")


def main() -> int:
    args = parse_args()
    out_dir = Path(args.output)
    out_dir.mkdir(parents=True, exist_ok=True)

    warnings: List[str] = []
    incomplete = False
    if args.fs <= 0:
        raise ValueError("--fs must be positive")
    if args.max_imf < 0:
        raise ValueError("--max-imf must be nonnegative")
    if args.reject_first < 0:
        raise ValueError("--reject-first must be nonnegative")

    data, names, read_warnings = read_csv_numeric(Path(args.input), args.channel_axis)
    warnings.extend(read_warnings)
    if data.shape[0] < 16:
        warnings.append("very short signal; decomposition may be unstable")
        incomplete = True
    if data.shape[1] == 0:
        raise ValueError("no channels found")

    cleaned_cols: List[np.ndarray] = []
    imf_rows: List[IMFStats] = []
    channel_reports: List[Dict[str, Any]] = []
    used_decompositions: List[str] = []

    for c_idx, name in enumerate(names):
        x_raw = data[:, c_idx].astype(float)
        if np.max(x_raw) == np.min(x_raw):
            incomplete = True
            ch_report = ChannelReport(
                channel=name,
                n_samples=int(x_raw.size),
                n_imfs=0,
                retained_imfs=[],
                rejected_imfs=[],
                residual_included=False,
                retained_energy_fraction=0.0,
                reconstruction_error=float("nan"),
                warnings=["flat channel; skipped decomposition"],
            )
            channel_reports.append({**asdict(ch_report), "decomposition": "skipped"})
            cleaned_cols.append(x_raw.copy())
            continue

        x_demeaned = x_raw - float(np.mean(x_raw))
        imfs, residue, decomp_name, ch_warnings = decompose_channel(
            x_demeaned,
            args.library,
            args.method,
            args.max_imf,
            args.trials,
            args.noise_width,
            args.seed + c_idx,
        )
        used_decompositions.append(decomp_name)
        if imfs.size == 0:
            incomplete = True
            ch_warnings.append("no IMFs extracted")
        if "fallback" in decomp_name:
            warnings.append(f"{name}: fallback decomposition used")

        stats = summarize_imfs(name, x_demeaned, imfs, args.fs, args.reject_first, args.reject_last)
        imf_rows.extend(stats)
        cleaned, retained, rejected, residual_included, retained_energy, recon_error = reconstruct_signal(
            x_raw, imfs, residue, args.reject_first, args.reject_last
        )
        cleaned_cols.append(cleaned)
        ch_report = ChannelReport(
            channel=name,
            n_samples=int(x_raw.size),
            n_imfs=int(imfs.shape[0]),
            retained_imfs=retained,
            rejected_imfs=rejected,
            residual_included=residual_included,
            retained_energy_fraction=retained_energy,
            reconstruction_error=recon_error,
            warnings=ch_warnings,
        )
        channel_reports.append({**asdict(ch_report), "decomposition": decomp_name})

    cleaned_data = np.column_stack(cleaned_cols) if cleaned_cols else np.empty_like(data)
    write_imf_summary(out_dir / "imf_summary.csv", imf_rows)
    if args.write_cleaned:
        write_cleaned_csv(out_dir / "cleaned.csv", cleaned_data, names)

    report: Dict[str, Any] = {
        "incomplete": bool(incomplete),
        "input": {
            "path": str(Path(args.input)),
            "n_samples": int(data.shape[0]),
            "n_channels": int(data.shape[1]),
            "channel_names": list(names),
        },
        "parameters": {
            "fs": float(args.fs),
            "method": args.method,
            "library": args.library,
            "max_imf": int(args.max_imf),
            "reject_first": int(args.reject_first),
            "reject_last": bool(args.reject_last),
            "trials": int(args.trials),
            "noise_width": float(args.noise_width),
            "seed": int(args.seed),
            "channel_axis": args.channel_axis,
            "write_cleaned": bool(args.write_cleaned),
        },
        "decompositions_used": sorted(set(used_decompositions)),
        "warnings": warnings,
        "channels": channel_reports,
        "outputs": {
            "report_json": str(out_dir / "report.json"),
            "report_md": str(out_dir / "report.md"),
            "imf_summary_csv": str(out_dir / "imf_summary.csv"),
            "cleaned_csv": str(out_dir / "cleaned.csv") if args.write_cleaned else None,
        },
    }

    with (out_dir / "report.json").open("w", encoding="utf-8") as f:
        json.dump(report, f, indent=2, allow_nan=True)
    write_markdown_report(out_dir / "report.md", report)
    print(json.dumps({"ok": True, "output": str(out_dir), "incomplete": incomplete}, indent=2))
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
