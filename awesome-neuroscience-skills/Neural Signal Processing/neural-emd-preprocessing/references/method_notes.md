# Method Notes: EMD-Family Preprocessing for Neural Signals

## Source status
The user supplied this source URL: https://pmc.ncbi.nlm.nih.gov/articles/PMC6224487/ . During skill construction, the available browser tool returned a browser verification page rather than readable article text. Treat that URL as a user-provided pointer, not as a fully parsed source in this scaffold.

Accessible method and library references used for this implementation plan:

- PyEMD documentation: https://pyemd.readthedocs.io/en/latest/
- PyEMD EEMD documentation: https://pyemd.readthedocs.io/en/latest/eemd.html
- PyEMD CEEMDAN documentation: https://pyemd.readthedocs.io/en/latest/ceemdan.html
- EMD package documentation: https://emd.readthedocs.io/en/stable/
- EMD package API: https://emd.readthedocs.io/en/stable/api.html
- pyeemd documentation: https://pyeemd.readthedocs.io/en/master/
- libeemd paper: Luukko, Helske, and Raesanen, "Introducing libeemd: A program package for performing the ensemble empirical mode decomposition", Computational Statistics, 2017.

## Core idea
Empirical mode decomposition (EMD) is an adaptive decomposition for nonlinear and nonstationary time series. A signal is represented as:

```text
x(t) = IMF_1(t) + IMF_2(t) + ... + IMF_K(t) + r(t)
```

where each IMF is intended to represent one local oscillatory scale and `r(t)` is a residual trend. Unlike Fourier or wavelet preprocessing, EMD does not require a fixed basis. This is attractive for EEG, MEG, LFP, ECoG, and iEEG because neural rhythms can be transient, waveform-shaped, and nonstationary.

## Basic EMD pseudocode

```text
input: signal x(t)
residual = x(t)
imfs = []
while residual has enough extrema and max_imf is not reached:
    proto = residual
    repeat sifting:
        maxima = local maxima of proto
        minima = local minima of proto
        upper = interpolated envelope through maxima
        lower = interpolated envelope through minima
        mean_env = (upper + lower) / 2
        proto = proto - mean_env
        stop when IMF conditions are approximately satisfied
    imfs.append(proto)
    residual = residual - proto
return imfs, residual
```

Important IMF checks:
- Numbers of extrema and zero crossings should differ by at most one.
- Mean of the upper and lower envelopes should be near zero.
- Sifting should not continue indefinitely; fixed iteration, standard deviation change, energy change, or Rilling-type criteria are common stopping rules.

## EMD-family methods for neural preprocessing

### EMD
Use for deterministic decomposition, exploratory analysis, and small-scale sanity checks. It is fast compared with ensemble methods but can suffer from mode mixing, boundary effects, and sensitivity to noise.

### EEMD
Ensemble EMD adds white noise to copies of the signal, decomposes each copy, and averages corresponding IMFs. It helps reduce mode mixing by using noise as a reference scale, but the result is stochastic. Always set a seed and document ensemble count, noise width, and parallel settings when reproducibility matters.

### CEEMDAN
Complete ensemble EMD with adaptive noise aims to preserve a more complete reconstruction while using an ensemble strategy. It is often appropriate when cleaned signal reconstruction matters, but it is slower and still needs seed control.

### Mask sift
Mask sift uses a mask oscillation to guide extraction around expected oscillatory content. It can be useful when the user has a target frequency scale, but it can bias decomposition toward the assumed mask.

### pyeemd/libeemd
pyeemd wraps libeemd, a C implementation of EMD, EEMD, and CEEMDAN. It is useful when speed and stable compiled routines are priorities, but environments may have installation constraints.

## Python package selection guide

1. Prefer `PyEMD` from the `EMD-signal` distribution for simple EMD/EEMD/CEEMDAN scripts and broad examples.
2. Prefer the `emd` package when the user needs mask sift, second-layer sift, instantaneous phase/frequency/amplitude, Hilbert-Huang spectrum, holospectrum, cycle analysis, or IMF diagnostics.
3. Prefer `pyeemd` or libeemd-backed workflows when a compiled EEMD/CEEMDAN backend is already available and reproducibility can be controlled.
4. Use the bundled fallback only to test interfaces, generate deterministic reports, or run toy examples. It is not a replacement for validated packages.

## Recommended neural preprocessing workflow

1. Collect metadata: modality, sampling rate, reference scheme, channel labels, preprocessing already applied, artifact types, and downstream analysis.
2. Validate the signal: finite values, no duplicate timestamps if time is provided, enough samples for the lowest frequency of interest, and adequate dynamic range.
3. Optionally apply conventional safety preprocessing first: remove bad channels, handle flat segments, notch line noise if justified, and mark large movement periods.
4. Decompose each channel with the chosen EMD-family method.
5. Summarize IMFs using energy fraction, zero-crossing frequency proxy, amplitude range, envelope statistics, and optionally instantaneous frequency if a Hilbert transform is available.
6. Define rejection criteria before looking at outcome labels:
   - high-frequency artifact: reject first one or two IMFs only if their frequency proxy and spectra match noise or muscle activity;
   - baseline drift: remove residual or final low-frequency mode only if the downstream task should be insensitive to slow trend;
   - ocular/motion artifact: reject IMFs only with independent evidence such as EOG, accelerometer, topography, or time-locked artifact annotations.
7. Reconstruct the retained signal and write a report that lists rejected IMFs by channel.
8. Validate reconstruction and downstream effects with sensitivity analyses.

## Heuristic metrics

### IMF energy fraction
```text
energy_fraction_k = sum(IMF_k^2) / sum(signal_demeaned^2)
```

### Zero-crossing frequency proxy
```text
freq_proxy_k = zero_crossings(IMF_k) * fs / (2 * n_samples)
```

This is only a rough proxy. For publishable instantaneous frequency estimates, use Hilbert-based methods after confirming that the IMF is sufficiently narrowband.

### Reconstruction error
```text
reconstruction_error = rms(signal_demeaned - (sum(IMFs) + residual)) / rms(signal_demeaned)
```

A large reconstruction error indicates a failed decomposition, a dropped residual, or a fallback limitation.

## Statistical interpretation boundaries
- IMFs are adaptive components, not fixed canonical bands.
- Similar IMF frequencies across channels do not prove coupling.
- Removing an IMF does not prove that the component was artifact.
- Better classification after IMF removal can reflect leakage or overfitting unless validated on held-out data.
- Clinical interpretation requires a clinician and validated diagnostic workflow.

## Reporting checklist
- Signal modality and sampling rate.
- EMD method and library.
- Version if available.
- Random seed, trials, noise width, and parallel mode for ensemble methods.
- Number of IMFs per channel.
- IMF rejection rule.
- Reconstruction error and retained energy.
- Warnings and incomplete metadata.
- Whether fallback mode was used.
