# Risk Notes

## Intended use
This skill is intended for exploratory neuroscience research on higher-order cross-frequency interactions in neural time series. It supports reproducible reporting and safe scaffold computation of antisymmetric cross-polycoherence metrics.

## Main risks
- False positives from insufficient segment counts, uncorrected multiple comparisons, artifacts, or preprocessing leakage.
- False negatives when high-order interactions are weak, nonstationary, poorly aligned with the selected frequencies, or obscured by noise.
- Overinterpretation of statistical dependence as causality, directionality, mechanism, diagnosis, or treatment guidance.
- Misuse in clinical or neuromodulation settings without expert review and independent validation.
- Instability when denominator terms are near zero or when target harmonics exceed Nyquist.

## Required mitigations
- Mark incomplete analyses explicitly.
- Report sampling rate, segment count, frequency grid, channel ordering, order `m`, and surrogate settings.
- Use white-noise, phase-shuffled, or segment-permuted controls where appropriate.
- Apply multiple-comparison correction for channel-frequency scans.
- Compare antisymmetric estimates against non-antisymmetric CT terms and artifact controls.
- Do not generate clinical diagnoses, treatment recommendations, or stimulation prescriptions.

## Data handling
The bundled script performs local file reads and writes only. It makes no network requests and does not call external shell commands. Users remain responsible for de-identification, consent, governance, and secure storage of neural or clinical data.
