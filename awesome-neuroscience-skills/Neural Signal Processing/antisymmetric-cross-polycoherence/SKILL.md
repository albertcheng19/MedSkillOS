---
name: antisymmetric-cross-polycoherence
description: "Use this neuroscience skill when analyzing EEG/MEG or neural time-series for antisymmetric cross-polyspectral, cross-tricoherence, or higher-order cross-frequency coupling; inputs include numeric time-series matrices, sampling rate, channel pairs, frequency/order settings, and outputs include JSON/Markdown reports with ACP/ACT estimates, surrogate statistics, and integrity checks."
license: MIT
author: Adele 的工作空间
---

> **Source**: `higher-order-neural-interaction.markdown`

# Antisymmetric Cross-Polycoherence

## When to Use
- Use this skill for neuroscience or neuroengineering analyses that need robust detection of higher-order cross-frequency interactions in EEG, MEG, LFP, source-reconstructed time series, or simulated neural signals.
- Use it when the task mentions antisymmetric cross-polyspectrum, antisymmetric cross-polycoherence, antisymmetric cross-tricoherence, ACT, ACP, cross-frequency coupling, 1:n harmonic coupling, cubic coupling, volume conduction, field spread, instantaneous mixing, or surrogate testing of polyspectral indices.
- Accepted inputs can include numeric time-series matrices, EEG/MEG channel tables, source-space parcels, synthetic simulations, sampling rate metadata, channel-pair definitions, frequency grids, statistical settings, or paper text describing the method.
- Do not use this skill as a clinical diagnostic tool, a treatment recommendation engine, or a replacement for full EEG/MEG preprocessing, source modeling, artifact rejection, or expert statistical review.

## Purpose
This skill operationalizes antisymmetric cross-polyspectral indices for detecting harmonic dependencies across neural time series while reducing spurious zero-lag effects caused by linear instantaneous mixing. The core use case is to estimate whether a component at frequency `(m-1)f` in one signal is systematically related to `(m-1)` copies of the component at frequency `f` in another signal.

The key idea is to compare a polyspectral term with its channel-swapped counterpart. Under a null model of independent stationary sources mixed linearly into sensors, symmetric mixing contributions cancel in the antisymmetric contrast. This makes the method useful for EEG/MEG settings where volume conduction and field spread can inflate conventional non-antisymmetrized cross-polyspectra.

The main outputs are structured estimates of antisymmetric cross-polycoherency magnitude, optional surrogate-based statistics, sanity checks, and a concise report that clearly distinguishes genuine statistical evidence from exploratory or incomplete analyses.

## Inputs
Required inputs:
- `--input`: Path to a numeric CSV or JSON time-series file. Rows are samples or segments over time; columns are channels/signals.
- `--output`: Output directory where reports will be written.

Recommended inputs:
- `--sampling-rate`: Sampling rate in Hz. Required for interpretable frequency labels.
- `--channel-x` and `--channel-y`: Channel names or zero-based integer indices for the ordered pair `(x, y)`.
- `--order`: Statistical order `m`. Use `4` for antisymmetric cross-tricoherence / 1:3 coupling; use `3` for the bicoherence analogue; use `2` for the imaginary-coherency special case.
- `--base-frequency`: Base frequency `f` in Hz. If omitted, the script scans a bounded frequency grid.

Optional inputs:
- `--segment-length`: FFT segment length in samples.
- `--overlap`: Fractional overlap between adjacent segments.
- `--freq-min`, `--freq-max`, `--max-frequencies`: Frequency scan controls.
- `--surrogates`: Number of deterministic segment-permutation surrogates for approximate p-values.
- `--seed`: Seed for deterministic surrogate permutations.
- `--format`: `json`, `markdown`, or `both`.

## Outputs
- `report.json`: Structured results with parameters, channel metadata, frequency-wise ACP/ACT estimates, normalized non-antisymmetric comparison terms, optional surrogate statistics, and warnings.
- `report.md`: Human-readable report summarizing the run, top frequencies, assumptions, and integrity notes.
- Console summary showing output paths and key warnings.

## Workflow
1. Inspect the task and confirm that the goal is exploratory estimation of higher-order neural interactions, not diagnosis or treatment.
2. Prepare a numeric time-series matrix. Apply preprocessing outside this skill when needed: artifact rejection, referencing, filtering, source reconstruction, epoching, and stationarity assessment.
3. Choose the ordered signal pair `(x, y)`. Interpret the result as an ordered antisymmetric contrast: swapping channels changes the numerator.
4. Choose the statistical order `m`. For cubic 1:3 coupling, use `m=4`; the target harmonic is `(m-1)f = 3f`.
5. Segment the time series using the configured segment length and overlap. The bundled script applies a Hann window and computes real FFT coefficients per segment.
6. For each candidate base frequency `f`, compute:
   - `P_x...xy = mean(X(f)^(m-1) * conj(Y((m-1)f)))`
   - `P_yx...x = mean(Y(f) * X(f)^(m-2) * conj(X((m-1)f)))`
   - antisymmetric numerator `P_x...xy - P_yx...x`
7. Normalize the contrast using amplitude norms so the magnitude is bounded when numerical conditions are well behaved.
8. Optionally estimate surrogate statistics by permuting the target-harmonic segment order. Treat the resulting p-values as approximate screening statistics, not confirmatory evidence unless the full analysis design supports it.
9. Write JSON and/or Markdown outputs. Mark runs as incomplete when inputs are too short, contain non-finite values, lack enough segments, or request impossible frequencies.
10. Interpret results together with preprocessing logs, multiple-comparison control, neurophysiological plausibility, and robustness checks across parameters.

## Method Summary
For two time series `x(t)` and `y(t)`, the `m`-th order cross-polyspectrum for a 1:`m-1` harmonic interaction is estimated as:

```text
P_x...xy^(m)(f) = < X(f)^(m-1) Y((m-1)f)* >
```

where `X(f)` and `Y(f)` are Fourier coefficients and `<.>` denotes an average over segments or trials. The antisymmetric counterpart swaps the first and last channel roles:

```text
P_yx...x^(m)(f) = < Y(f) X(f)^(m-2) X((m-1)f)* >
P_[x|x...x|y]^(m)(f) = P_x...xy^(m)(f) - P_yx...x^(m)(f)
```

With amplitude norm `Q_x(f) = <|X(f)|^m>^(1/m)`, the normalized antisymmetric cross-polycoherency is:

```text
Gamma_[x|x...x|y]^(m)(f) =
  P_[x|x...x|y]^(m)(f) /
  ( Q_x(f)^(m-1) Q_y((m-1)f) + Q_y(f) Q_x(f)^(m-2) Q_x((m-1)f) )
```

For `m=4`, this is the antisymmetric cross-tricoherence / ACT used for 1:3 cubic coupling. For `m=2`, the construction reduces to the imaginary part of coherency up to the expected imaginary factor and normalization.

## Implementation Notes
- `scripts/main.py` is a deterministic reference scaffold for estimating pairwise ACP/ACT from CSV or JSON time-series files.
- The script performs no network access and no shell calls. It reads the specified input and writes only into the requested output directory.
- The implementation uses NumPy for FFTs, segmentation, amplitude norms, and optional deterministic surrogate permutations.
- The current implementation estimates ordered bivariate channel pairs. Multivariate parcel-level optimization, full tensor polyspectra, source-orientation pooling, and high-dimensional multiple-comparison correction are TODOs for project-specific extensions.
- Surrogate p-values in the scaffold follow the method-note approximation `p = exp(-r)` with `r = |z|^2 / mean(|z_surrogate|^2)`. Treat them as screening diagnostics unless validated for the final dataset and preprocessing pipeline.

## Validation
- Run `python scripts/main.py --help` to verify the CLI.
- Run a toy cubic simulation outside the skill or with a small CSV containing delayed base and cubic harmonic signals; ACT should be elevated near the expected base frequency.
- Run white-noise or independently mixed controls; ACP/ACT should remain near baseline and surrogate p-values should not be systematically enriched for very small values.
- Check that requested frequencies satisfy `(m-1)f <= Nyquist`; otherwise the script should skip them and report warnings.
- Compare `acp_magnitude` against non-antisymmetric `ct1_magnitude` and `ct2_magnitude`; inflation of CT terms alone is not evidence of genuine coupling.
- Repeat analyses across segment lengths, overlap values, frequency grids, and channel ordering to assess robustness.

## Limitations
- The method assumes enough approximately stationary segments or trials for stable polyspectral averaging.
- Antisymmetrization suppresses linear instantaneous mixing under idealized assumptions; it does not remove every artifact, preprocessing error, or model violation.
- Degenerate frequency configurations, especially those involving negative or canceling frequencies, can break robustness. Use positive frequencies and avoid configurations where frequency sums collapse.
- High-order estimates can be data-hungry and sensitive to noise, windowing, preprocessing, and multiple comparisons.
- The bundled script is a safe scaffold, not a full EEG/MEG pipeline. It does not perform artifact rejection, source reconstruction, line-noise correction, or clinical interpretation.

## Safety and Integrity Rules
- Do not overstate conclusions.
- Do not interpret statistical association as causality.
- Do not automatically generate clinical diagnosis or treatment advice.
- Do not copy protected textbook, guideline, or paid-summary content.
- Mark incomplete or underpowered inputs as `incomplete` instead of pretending the analysis passed.
- Report preprocessing assumptions, segment counts, frequency exclusions, and surrogate settings.
- Avoid claiming robustness to volume conduction unless the antisymmetric contrast, controls, and preprocessing support that claim.

## Example Usage
```bash
python scripts/main.py --input data.csv --output results/ --sampling-rate 256 --channel-x 0 --channel-y 1 --order 4 --base-frequency 10 --surrogates 100
```

Frequency scan example:

```bash
python scripts/main.py --input eeg_channels.csv --output results_scan/ --sampling-rate 512 --channel-x Fz --channel-y Pz --order 4 --freq-min 4 --freq-max 20 --max-frequencies 30 --format both
```
