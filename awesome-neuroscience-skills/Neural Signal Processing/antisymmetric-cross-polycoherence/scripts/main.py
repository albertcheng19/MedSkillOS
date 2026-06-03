#!/usr/bin/env python3
"""Estimate antisymmetric cross-polycoherence for a pair of neural time series.

This is a deterministic, local-only scaffold intended for neuroscience research.
It performs no network requests and no shell calls. It reads a CSV/JSON matrix,
segments two selected channels, computes FFT coefficients, estimates ACP/ACT, and
writes JSON and/or Markdown reports.
"""

from __future__ import annotations

import argparse
import csv
import json
import math
import os
from pathlib import Path
from typing import Any, Dict, List, Optional, Sequence, Tuple

import numpy as np

EPS = 1e-15


def build_parser() -> argparse.ArgumentParser:
    parser = argparse.ArgumentParser(
        description=(
            "Estimate antisymmetric cross-polycoherence / cross-tricoherence "
            "from a numeric CSV or JSON time-series matrix."
        )
    )
    parser.add_argument("--input", required=True, help="Path to numeric CSV or JSON time-series file.")
    parser.add_argument("--output", required=True, help="Directory for report.json and/or report.md.")
    parser.add_argument("--sampling-rate", type=float, default=256.0, help="Sampling rate in Hz. Default: 256.")
    parser.add_argument("--channel-x", default="0", help="Channel x name or zero-based index. Default: 0.")
    parser.add_argument("--channel-y", default="1", help="Channel y name or zero-based index. Default: 1.")
    parser.add_argument("--order", type=int, default=4, help="Statistical order m >= 2. Use 4 for ACT / 1:3 coupling. Default: 4.")
    parser.add_argument("--base-frequency", type=float, default=None, help="Single base frequency f in Hz. If omitted, scan a grid.")
    parser.add_argument("--freq-min", type=float, default=1.0, help="Minimum base frequency for scans. Default: 1 Hz.")
    parser.add_argument("--freq-max", type=float, default=20.0, help="Maximum base frequency for scans. Default: 20 Hz.")
    parser.add_argument("--max-frequencies", type=int, default=40, help="Maximum frequency bins to scan. Default: 40.")
    parser.add_argument("--segment-length", type=int, default=512, help="FFT segment length in samples. Default: 512.")
    parser.add_argument("--overlap", type=float, default=0.5, help="Fractional segment overlap in [0, 0.95). Default: 0.5.")
    parser.add_argument("--surrogates", type=int, default=0, help="Number of deterministic segment-permutation surrogates. Default: 0.")
    parser.add_argument("--seed", type=int, default=0, help="Random seed for surrogate permutations. Default: 0.")
    parser.add_argument("--format", choices=["json", "markdown", "both"], default="both", help="Output report format. Default: both.")
    return parser


def parse_float_cell(value: Any) -> float:
    if value is None:
        return float("nan")
    if isinstance(value, (int, float)):
        return float(value)
    text = str(value).strip()
    if text == "":
        return float("nan")
    return float(text)


def load_csv_matrix(path: Path) -> Tuple[np.ndarray, List[str], Dict[str, Any]]:
    with path.open("r", newline="", encoding="utf-8-sig") as handle:
        sample = handle.read(4096)
        handle.seek(0)
        try:
            dialect = csv.Sniffer().sniff(sample)
        except csv.Error:
            dialect = csv.excel
        rows = list(csv.reader(handle, dialect))

    if not rows:
        raise ValueError("CSV file is empty.")

    first = rows[0]
    has_header = False
    try:
        [parse_float_cell(cell) for cell in first]
    except ValueError:
        has_header = True

    if has_header:
        columns = [str(cell).strip() or f"col_{idx}" for idx, cell in enumerate(first)]
        data_rows = rows[1:]
    else:
        columns = [f"ch_{idx}" for idx in range(len(first))]
        data_rows = rows

    data: List[List[float]] = []
    for row in data_rows:
        if not row or all(str(cell).strip() == "" for cell in row):
            continue
        if len(row) != len(columns):
            raise ValueError(f"CSV row has {len(row)} cells but expected {len(columns)}.")
        data.append([parse_float_cell(cell) for cell in row])

    matrix = np.asarray(data, dtype=float)
    return matrix, columns, {"input_format": "csv", "has_header": has_header}


def load_json_matrix(path: Path) -> Tuple[np.ndarray, List[str], Dict[str, Any]]:
    with path.open("r", encoding="utf-8") as handle:
        obj = json.load(handle)

    metadata: Dict[str, Any] = {"input_format": "json"}
    columns: Optional[List[str]] = None
    data_obj: Any = obj

    if isinstance(obj, dict):
        if "sampling_rate" in obj:
            metadata["sampling_rate_in_file"] = obj["sampling_rate"]
        if "columns" in obj and isinstance(obj["columns"], list):
            columns = [str(x) for x in obj["columns"]]
        if "data" in obj:
            data_obj = obj["data"]
        elif "matrix" in obj:
            data_obj = obj["matrix"]
        elif "time_series" in obj:
            data_obj = obj["time_series"]

    if isinstance(data_obj, list) and data_obj and isinstance(data_obj[0], dict):
        if columns is None:
            columns = list(data_obj[0].keys())
        data = [[parse_float_cell(row.get(col)) for col in columns] for row in data_obj]
    elif isinstance(data_obj, list):
        data = [[parse_float_cell(cell) for cell in row] for row in data_obj]
        if columns is None and data:
            columns = [f"ch_{idx}" for idx in range(len(data[0]))]
    else:
        raise ValueError("JSON input must contain a matrix/list, or a dict with data/matrix/time_series.")

    matrix = np.asarray(data, dtype=float)
    if columns is None:
        columns = [f"ch_{idx}" for idx in range(matrix.shape[1] if matrix.ndim == 2 else 0)]
    return matrix, columns, metadata


def load_time_series(path: Path) -> Tuple[np.ndarray, List[str], Dict[str, Any]]:
    suffix = path.suffix.lower()
    if suffix == ".csv" or suffix == ".tsv":
        return load_csv_matrix(path)
    if suffix == ".json":
        return load_json_matrix(path)
    raise ValueError("Unsupported input format. Use .csv, .tsv, or .json.")


def resolve_channel(selector: str, columns: Sequence[str], n_channels: int) -> int:
    try:
        idx = int(selector)
    except ValueError:
        if selector not in columns:
            raise ValueError(f"Unknown channel '{selector}'. Available names: {', '.join(columns)}")
        idx = list(columns).index(selector)
    if idx < 0 or idx >= n_channels:
        raise ValueError(f"Channel index {idx} out of range for {n_channels} channels.")
    return idx


def make_segments(signal: np.ndarray, segment_length: int, overlap: float) -> np.ndarray:
    if segment_length < 8:
        raise ValueError("segment-length must be at least 8 samples.")
    if not (0.0 <= overlap < 0.95):
        raise ValueError("overlap must be in [0, 0.95).")
    if signal.size < segment_length:
        raise ValueError("Input signal is shorter than segment-length.")

    step = max(1, int(round(segment_length * (1.0 - overlap))))
    starts = list(range(0, signal.size - segment_length + 1, step))
    if len(starts) < 2:
        raise ValueError("Need at least two segments for a stable cross-polyspectral estimate.")
    return np.vstack([signal[start : start + segment_length] for start in starts])


def fft_segments(x: np.ndarray, y: np.ndarray, segment_length: int, overlap: float, sampling_rate: float) -> Tuple[np.ndarray, np.ndarray, np.ndarray]:
    x_segments = make_segments(x, segment_length, overlap)
    y_segments = make_segments(y, segment_length, overlap)
    window = np.hanning(segment_length)
    x_windowed = (x_segments - x_segments.mean(axis=1, keepdims=True)) * window
    y_windowed = (y_segments - y_segments.mean(axis=1, keepdims=True)) * window
    x_fft = np.fft.rfft(x_windowed, axis=1)
    y_fft = np.fft.rfft(y_windowed, axis=1)
    freqs = np.fft.rfftfreq(segment_length, d=1.0 / sampling_rate)
    return x_fft, y_fft, freqs


def nearest_bin(freqs: np.ndarray, target: float) -> int:
    return int(np.argmin(np.abs(freqs - target)))


def q_norm(values: np.ndarray, order: int) -> float:
    return float(np.mean(np.abs(values) ** order) ** (1.0 / order))


def finite_or_none(value: complex) -> Optional[Dict[str, float]]:
    real = float(np.real(value))
    imag = float(np.imag(value))
    if not (math.isfinite(real) and math.isfinite(imag)):
        return None
    return {"real": real, "imag": imag}


def estimate_at_frequency(
    x_fft: np.ndarray,
    y_fft: np.ndarray,
    freqs: np.ndarray,
    base_frequency: float,
    order: int,
    surrogate_count: int,
    rng: np.random.Generator,
) -> Dict[str, Any]:
    target_frequency = (order - 1) * base_frequency
    nyquist = float(freqs[-1])
    result: Dict[str, Any] = {
        "requested_base_frequency_hz": float(base_frequency),
        "requested_target_frequency_hz": float(target_frequency),
        "status": "ok",
        "warnings": [],
    }

    if target_frequency > nyquist + EPS:
        result["status"] = "skipped"
        result["warnings"].append("target frequency exceeds Nyquist")
        return result

    bin_f = nearest_bin(freqs, base_frequency)
    bin_t = nearest_bin(freqs, target_frequency)
    actual_f = float(freqs[bin_f])
    actual_t = float(freqs[bin_t])

    if bin_f == 0:
        result["warnings"].append("base frequency rounded to DC bin; interpretation is unreliable")
    if bin_t == 0:
        result["warnings"].append("target frequency rounded to DC bin; interpretation is unreliable")

    x_f = x_fft[:, bin_f]
    y_f = y_fft[:, bin_f]
    x_t = x_fft[:, bin_t]
    y_t = y_fft[:, bin_t]

    term1_values = (x_f ** (order - 1)) * np.conj(y_t)
    term2_values = y_f * (x_f ** max(order - 2, 0)) * np.conj(x_t)
    term1 = complex(np.mean(term1_values))
    term2 = complex(np.mean(term2_values))
    numerator = term1 - term2

    q_x_f = q_norm(x_f, order)
    q_y_f = q_norm(y_f, order)
    q_x_t = q_norm(x_t, order)
    q_y_t = q_norm(y_t, order)
    denom1 = (q_x_f ** (order - 1)) * q_y_t
    denom2 = q_y_f * (q_x_f ** max(order - 2, 0)) * q_x_t
    denominator = denom1 + denom2

    result.update(
        {
            "actual_base_frequency_hz": actual_f,
            "actual_target_frequency_hz": actual_t,
            "base_frequency_bin": int(bin_f),
            "target_frequency_bin": int(bin_t),
            "segment_count": int(x_fft.shape[0]),
            "term1_p_x_to_y": finite_or_none(term1),
            "term2_p_y_to_x": finite_or_none(term2),
            "antisymmetric_numerator": finite_or_none(numerator),
            "denominator": float(denominator),
            "ct1_magnitude": float(abs(term1) / denom1) if denom1 > EPS else None,
            "ct2_magnitude": float(abs(term2) / denom2) if denom2 > EPS else None,
        }
    )

    if denominator <= EPS or not math.isfinite(float(denominator)):
        result["status"] = "incomplete"
        result["warnings"].append("normalization denominator is zero or non-finite")
        result["acp"] = None
        result["acp_magnitude"] = None
        return result

    gamma = numerator / denominator
    result["acp"] = finite_or_none(gamma)
    result["acp_magnitude"] = float(abs(gamma))

    if surrogate_count > 0:
        surrogate_values: List[complex] = []
        n_segments = x_fft.shape[0]
        for _ in range(surrogate_count):
            perm = rng.permutation(n_segments)
            s_term1 = complex(np.mean((x_f ** (order - 1)) * np.conj(y_t[perm])))
            s_term2 = complex(np.mean(y_f * (x_f ** max(order - 2, 0)) * np.conj(x_t[perm])))
            surrogate_values.append(s_term1 - s_term2)
        surrogate_power = float(np.mean(np.abs(np.asarray(surrogate_values)) ** 2))
        if surrogate_power <= EPS or not math.isfinite(surrogate_power):
            result["surrogate"] = {
                "count": int(surrogate_count),
                "status": "incomplete",
                "warning": "surrogate power is zero or non-finite",
            }
        else:
            r_value = float((abs(numerator) ** 2) / surrogate_power)
            p_value = float(math.exp(-r_value)) if r_value < 745 else 0.0
            result["surrogate"] = {
                "count": int(surrogate_count),
                "status": "ok",
                "r_value": r_value,
                "p_value_approx": p_value,
                "mean_surrogate_power": surrogate_power,
            }

    return result


def candidate_frequencies(args: argparse.Namespace, freqs: np.ndarray) -> List[float]:
    if args.base_frequency is not None:
        return [float(args.base_frequency)]
    upper = min(float(args.freq_max), float(freqs[-1]) / (args.order - 1))
    lower = max(float(args.freq_min), 0.0)
    if upper < lower:
        return []
    candidate_bins = [idx for idx, f in enumerate(freqs) if lower <= float(f) <= upper and idx > 0]
    if not candidate_bins:
        return []
    if len(candidate_bins) > args.max_frequencies:
        selected_positions = np.linspace(0, len(candidate_bins) - 1, args.max_frequencies)
        candidate_bins = [candidate_bins[int(round(pos))] for pos in selected_positions]
        candidate_bins = sorted(set(candidate_bins))
    return [float(freqs[idx]) for idx in candidate_bins]


def safe_markdown_float(value: Any) -> str:
    return f"{value:.4g}" if isinstance(value, (int, float)) and math.isfinite(float(value)) else "NA"


def write_reports(report: Dict[str, Any], output_dir: Path, fmt: str) -> List[str]:
    output_dir.mkdir(parents=True, exist_ok=True)
    written: List[str] = []
    if fmt in ("json", "both"):
        json_path = output_dir / "report.json"
        with json_path.open("w", encoding="utf-8") as handle:
            json.dump(report, handle, indent=2, ensure_ascii=False)
        written.append(str(json_path))
    if fmt in ("markdown", "both"):
        # Patch markdown table formatting safely to avoid conditional format specifiers.
        md = make_markdown_safe(report)
        md_path = output_dir / "report.md"
        with md_path.open("w", encoding="utf-8") as handle:
            handle.write(md)
        written.append(str(md_path))
    return written


def make_markdown_safe(report: Dict[str, Any]) -> str:
    params = report["parameters"]
    lines = [
        "# Antisymmetric Cross-Polycoherence Report",
        "",
        f"Status: **{report['status']}**",
        "",
        "## Parameters",
        f"- Input: `{report['input']['path']}`",
        f"- Sampling rate: {params['sampling_rate_hz']} Hz",
        f"- Channels: `{report['channels']['x_name']}` -> `{report['channels']['y_name']}`",
        f"- Order m: {params['order']}",
        f"- Segment length: {params['segment_length']} samples",
        f"- Overlap: {params['overlap']}",
        f"- Surrogates: {params['surrogates']}",
        "",
        "## Integrity Notes",
    ]
    warnings = report.get("warnings", [])
    lines.extend([f"- {warning}" for warning in warnings] if warnings else ["- No high-level warnings were generated."])

    results = report.get("results", [])
    ok_results = [item for item in results if item.get("status") == "ok" and item.get("acp_magnitude") is not None]
    ok_results = sorted(ok_results, key=lambda item: item.get("acp_magnitude", -1.0), reverse=True)
    lines.extend(["", "## Top Frequencies"])
    if ok_results:
        lines.append("| rank | base Hz | target Hz | ACP magnitude | CT1 magnitude | CT2 magnitude | surrogate p approx |")
        lines.append("|---:|---:|---:|---:|---:|---:|---:|")
        for rank, item in enumerate(ok_results[:10], start=1):
            p_value = item.get("surrogate", {}).get("p_value_approx")
            lines.append(
                "| {rank} | {base} | {target} | {acp} | {ct1} | {ct2} | {p} |".format(
                    rank=rank,
                    base=safe_markdown_float(item.get("actual_base_frequency_hz")),
                    target=safe_markdown_float(item.get("actual_target_frequency_hz")),
                    acp=safe_markdown_float(item.get("acp_magnitude")),
                    ct1=safe_markdown_float(item.get("ct1_magnitude")),
                    ct2=safe_markdown_float(item.get("ct2_magnitude")),
                    p=safe_markdown_float(p_value),
                )
            )
    else:
        lines.append("No complete ACP estimates were produced.")

    lines.extend(
        [
            "",
            "## Interpretation Guardrails",
            "- ACP/ACT reflects higher-order statistical dependence, not causality.",
            "- Non-antisymmetric CT inflation alone can reflect zero-lag mixing or shared artifacts.",
            "- Approximate surrogate p-values require validation and multiple-comparison correction for confirmatory claims.",
            "- This report is not clinical guidance and should not be used for diagnosis or treatment decisions.",
            "",
        ]
    )
    return "\n".join(lines)


def main() -> int:
    parser = build_parser()
    args = parser.parse_args()
    warnings: List[str] = []

    input_path = Path(args.input).expanduser().resolve()
    output_dir = Path(args.output).expanduser().resolve()

    if args.order < 2:
        parser.error("--order must be >= 2")
    if args.sampling_rate <= 0:
        parser.error("--sampling-rate must be positive")
    if args.max_frequencies < 1:
        parser.error("--max-frequencies must be >= 1")
    if args.surrogates < 0:
        parser.error("--surrogates must be >= 0")

    matrix, columns, input_metadata = load_time_series(input_path)
    if matrix.ndim != 2 or matrix.shape[0] < 2 or matrix.shape[1] < 2:
        raise ValueError("Input must be a 2D matrix with at least two rows and two columns.")
    if not np.all(np.isfinite(matrix)):
        raise ValueError("Input contains NaN or infinite values; clean or impute before analysis.")

    x_idx = resolve_channel(args.channel_x, columns, matrix.shape[1])
    y_idx = resolve_channel(args.channel_y, columns, matrix.shape[1])
    if x_idx == y_idx:
        warnings.append("channel-x and channel-y are identical; antisymmetric interpretation may be degenerate")

    x = np.asarray(matrix[:, x_idx], dtype=float)
    y = np.asarray(matrix[:, y_idx], dtype=float)
    x = x - np.mean(x)
    y = y - np.mean(y)

    x_fft, y_fft, freqs = fft_segments(x, y, args.segment_length, args.overlap, args.sampling_rate)
    frequencies = candidate_frequencies(args, freqs)
    if not frequencies:
        warnings.append("no valid candidate frequencies; check freq range, order, and sampling rate")

    rng = np.random.default_rng(args.seed)
    results = [
        estimate_at_frequency(x_fft, y_fft, freqs, f, args.order, args.surrogates, rng)
        for f in frequencies
    ]

    complete_count = sum(1 for item in results if item.get("status") == "ok")
    status = "complete" if complete_count > 0 else "incomplete"
    if complete_count == 0:
        warnings.append("analysis produced no complete frequency estimates")

    report: Dict[str, Any] = {
        "status": status,
        "input": {
            "path": str(input_path),
            "rows": int(matrix.shape[0]),
            "columns": int(matrix.shape[1]),
            "metadata": input_metadata,
        },
        "channels": {
            "x_index": int(x_idx),
            "y_index": int(y_idx),
            "x_name": columns[x_idx],
            "y_name": columns[y_idx],
        },
        "parameters": {
            "sampling_rate_hz": float(args.sampling_rate),
            "order": int(args.order),
            "segment_length": int(args.segment_length),
            "overlap": float(args.overlap),
            "base_frequency_hz": args.base_frequency,
            "freq_min_hz": float(args.freq_min),
            "freq_max_hz": float(args.freq_max),
            "max_frequencies": int(args.max_frequencies),
            "surrogates": int(args.surrogates),
            "seed": int(args.seed),
            "fft_segment_count": int(x_fft.shape[0]),
            "nyquist_hz": float(freqs[-1]),
        },
        "warnings": warnings,
        "results": results,
    }

    written = write_reports(report, output_dir, args.format)
    print("Antisymmetric cross-polycoherence analysis finished.")
    print(f"Status: {status}")
    for path in written:
        print(f"Wrote: {path}")
    if warnings:
        print("Warnings:")
        for warning in warnings:
            print(f"- {warning}")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
