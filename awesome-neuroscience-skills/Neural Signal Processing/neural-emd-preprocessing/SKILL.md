---
name: neural-emd-preprocessing
description: "Use this skill for neuroscience signal preprocessing with empirical mode decomposition families when working with EEG, MEG, LFP, ECoG, iEEG, EMG-contaminated neural time series, CSV feature matrices, or time-series arrays; it helps choose EMD, EEMD, CEEMDAN, mask sift, or fallback decomposition, remove mode-based artifacts, detrend, summarize IMFs, and produce reproducible reports without clinical interpretation."
license: MIT
author: OpenAI research skill scaffold
---

> **Source**: User-provided article URL: https://pmc.ncbi.nlm.nih.gov/articles/PMC6224487/ . In this environment, the page returned a browser verification screen rather than article text, so the reusable method content is grounded in accessible EMD/HHT references and Python package documentation listed in `references/method_notes.md`.

# Neural EMD Preprocessing

## When to Use
- Use this skill when the task is to preprocess neural time series with empirical mode decomposition (EMD) or its variants: EMD, ensemble EMD (EEMD), complete ensemble EMD with adaptive noise (CEEMDAN), mask sift, or related Hilbert-Huang preprocessing.
- Use for EEG, MEG, LFP, ECoG, iEEG, sleep EEG, resting-state recordings, event-related single trials, or simulation time series where oscillatory modes, transient artifacts, baseline drift, or nonstationary dynamics are central.
- Inputs can be CSV time series, NumPy-like arrays, channel x sample matrices, single-channel recordings, preprocessing configs, or paper text describing EMD-based denoising.
- Use when the user wants an IMF table, cleaned signal, reconstruction rule, mode rejection rationale, quality-control report, or a deterministic scaffold that can call Python EMD libraries when installed.
- Do not use for clinical diagnosis, seizure detection claims, medication or treatment guidance, or for replacing standard EEG/MEG preprocessing pipelines without validation.
- Do not use when the data are very short, heavily clipped, nonuniformly sampled without a timestamp correction step, or when the user needs source localization rather than signal cleaning.

## Purpose
Neural recordings are often nonlinear, nonstationary, and contaminated by slow drifts, high-frequency muscle activity, movement artifacts, line noise, and mode-like transient bursts. Empirical mode decomposition is useful because it adaptively separates a signal into intrinsic mode functions (IMFs) and a residual trend without imposing a fixed Fourier or wavelet basis.

This skill provides a reproducible, cautious preprocessing workflow for selecting an EMD-family method, decomposing each channel, screening IMFs using transparent criteria, reconstructing cleaned signals, and reporting what was removed. It is designed for research preprocessing and exploratory analysis, not for automatic clinical decisions.

The bundled script gives a safe baseline: it reads local CSV input, optionally uses installed Python EMD libraries, otherwise runs a deterministic simplified EMD fallback, then writes JSON and Markdown reports plus optional reconstructed CSV outputs.

## Inputs
Required:
- `--input`: CSV file containing one or more neural time series. Rows are samples; columns are channels. A header row is allowed.
- `--output`: Output directory for reports and reconstructed signals.
- `--fs`: Sampling rate in Hz.

Optional:
- `--method`: `auto`, `emd`, `eemd`, `ceemdan`, or `mask-sift`.
- `--library`: `auto`, `pyemd`, `emd`, or `fallback`.
- `--max-imf`: Maximum number of IMFs to extract per channel.
- `--reject-first`: Number of highest-frequency IMFs to remove during reconstruction.
- `--reject-last`: Whether to remove the slow residual or last low-frequency component.
- `--trials`: Ensemble count for EEMD or CEEMDAN when the selected library supports it.
- `--noise-width`: Relative noise width for EEMD-style methods.
- `--seed`: Random seed for reproducible noise-assisted decomposition when supported.
- `--channel-axis`: Whether the CSV is `samples_by_channels` or `channels_by_samples`.
- `--write-cleaned`: Write reconstructed cleaned CSV.

## Outputs
- `report.json`: Structured metadata, parameter values, channel summaries, IMF statistics, reconstruction choices, warnings, and integrity checks.
- `report.md`: Human-readable preprocessing report with assumptions and limitations.
- `cleaned.csv`: Optional reconstructed signal after IMF rejection.
- `imf_summary.csv`: IMF-level summary table with energy fraction, zero-crossing rate, estimated dominant frequency proxy, and rejection flag.
- Logs printed to stdout only; the script does not make network requests or hidden shell calls.

## Workflow
1. Inspect the request and identify the neural signal type, sampling rate, channel layout, and target use: denoising, detrending, artifact screening, Hilbert-Huang feature extraction, or QC only.
2. Confirm that the input is a time series rather than a precomputed feature table. For feature tables, use this skill only to write a method plan or parameter template; do not decompose features as if they were signals.
3. Choose the decomposition family:
   - Use EMD for deterministic, single-channel exploratory decomposition or short sanity checks.
   - Use EEMD when mode mixing is a concern and stochastic ensemble averaging is acceptable.
   - Use CEEMDAN when reconstruction completeness and adaptive noise handling matter.
   - Use mask sift when a known oscillatory band should be stabilized and the `emd` package is available.
   - Use fallback only as a deterministic scaffold when no EMD library is installed.
4. Load the signal and validate shape, finite values, sampling rate, length, and approximate dynamic range. Mark the result incomplete if any required metadata is missing.
5. For each channel, remove the mean before decomposition, run the selected method, and retain all IMFs and any residual returned by the library.
6. Summarize each IMF with energy fraction, zero-crossing rate, amplitude range, and a coarse dominant-frequency proxy derived from zero crossings.
7. Decide which IMFs to reject only with explicit criteria. Common research heuristics are: reject the first IMF for high-frequency noise, reject low-frequency residuals for slow drift, or manually reject IMFs whose frequency proxy and topography match known artifacts.
8. Reconstruct the cleaned signal from retained IMFs and, if appropriate, add back a selected residual or channel mean.
9. Run validation checks: reconstruction error, retained energy fraction, number of IMFs, nonfinite values, channel length consistency, and whether rejection rules were applied uniformly.
10. Write `report.json`, `report.md`, and optional CSV outputs. Include warnings when the method used a fallback or when stochastic algorithms were run without a fixed seed.
11. Interpret results conservatively. Report that an IMF is consistent with an artifact or oscillatory component; do not claim a neural generator without independent evidence.

## Method Summary
EMD decomposes a signal `x(t)` into a finite sum of IMFs and a residual:

```text
x(t) = sum_k IMF_k(t) + r(t)
```

An IMF is intended to be a narrowband oscillatory mode whose local extrema and zero crossings are balanced and whose local envelope mean is near zero. EMD estimates modes through iterative sifting: identify local maxima and minima, interpolate upper and lower envelopes, subtract their mean, test IMF conditions, and repeat on the residual.

EEMD repeats EMD on noise-perturbed copies of the signal and averages corresponding IMFs. This can reduce mode mixing, but the result is stochastic unless the seed and parallel behavior are controlled. CEEMDAN is a complete ensemble variant with adaptive noise; it is often preferred when reconstruction consistency is important. Mask sift uses a guiding oscillatory mask to stabilize extraction around target frequencies.

For neural preprocessing, IMF rejection should be treated as transparent signal editing. High-frequency IMFs may contain muscle noise or sensor noise; low-frequency residuals may contain drift; intermediate IMFs may contain physiologically meaningful rhythms. Therefore, always report the retained and rejected modes, and validate downstream analyses with and without the cleaning step.

## Implementation Notes
- `scripts/main.py` is the command-line entrypoint. It uses `argparse`, supports `--help`, reads local CSV input, writes outputs to a local directory, and never performs network calls.
- The script tries to use installed libraries in this order when `--library auto` is selected: `PyEMD` for EMD/EEMD/CEEMDAN, then `emd` for sift-family methods, then a deterministic fallback implementation.
- The fallback implementation is intentionally conservative. It is sufficient for interface testing and toy signals, but it is not a full scientific replacement for mature EMD libraries. Reports clearly mark fallback usage.
- `references/method_notes.md` contains the method rationale, package notes, selection rules, validation checks, and citation URLs.
- `risk.md` describes misuse risks for neural and biomedical signals.

## Validation
- Run `python scripts/main.py --help` and confirm the CLI displays options.
- Run a toy signal containing a slow drift, a 10 Hz oscillation, and high-frequency noise. Verify that the report is generated and reconstruction error is finite.
- Check `report.json` for `incomplete: false` only when sampling rate, input shape, finite data, and decomposition output are valid.
- Check that the sum of retained and rejected IMFs plus any residual approximately reconstructs the demeaned input before cleaning.
- For stochastic EEMD/CEEMDAN, repeat with the same seed and confirm stable summaries. Repeat with several seeds when making claims about a result.
- Compare downstream features before and after EMD cleaning; do not accept a preprocessing rule if it creates task leakage or selectively improves only one outcome label.

## Limitations
- EMD is data-adaptive and can be sensitive to boundary effects, sampling rate, noise, signal length, and stopping criteria.
- IMF indices do not correspond to fixed frequency bands across channels, subjects, or trials unless explicitly validated.
- Automatic IMF rejection can remove neural activity along with artifacts.
- EEMD and CEEMDAN are stochastic and computationally expensive, especially for many channels or long recordings.
- Simplified fallback decomposition is for scaffold testing only; use mature libraries for publishable analysis.
- EMD does not solve volume conduction, source mixing, referencing artifacts, or causal inference by itself.

## Safety and Integrity Rules
- Do not exaggerate conclusions.
- Do not interpret statistical association, IMF presence, or denoising improvement as causality.
- Do not automatically generate clinical diagnosis, seizure classification, treatment advice, or neuromodulation recommendations.
- Do not copy protected textbook, guideline, or paid abstract content.
- Mark missing sampling rate, unknown channel layout, unreadable article text, or failed library imports as `incomplete` or `warning` rather than pretending the analysis passed.
- Always preserve enough metadata for reproducibility: sampling rate, method, library, seed, trials, noise width, rejected IMFs, retained IMFs, and package fallback status.

## Example Usage
```bash
python scripts/main.py --input eeg.csv --output results/ --fs 256 --method ceemdan --library auto --max-imf 8 --reject-first 1 --write-cleaned
```

```bash
python scripts/main.py --input lfp.csv --output qc_only/ --fs 1000 --method emd --library fallback --max-imf 6
```
