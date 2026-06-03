# Method Notes: Antisymmetric Cross-Polycoherence for Neural Time Series

## Scope
These notes summarize a generalized antisymmetric polyspectral framework for identifying higher-order cross-frequency interactions in neural signals such as EEG, MEG, LFP, and source-reconstructed time series. The main practical target is robust detection of harmonic dependencies like 1:3 cubic coupling while reducing spurious effects from volume conduction, field spread, and other linear instantaneous mixing artifacts.

## Core problem
Standard same-frequency connectivity measures can miss interactions where multiple low-frequency components combine into a higher-frequency component. Conventional non-antisymmetrized polyspectra can detect some nonlinear harmonic structure, but they can also be inflated by zero-lag correlations caused by sensor mixing or shared artifacts. The antisymmetric construction aims to retain sensitivity to genuine ordered interactions while canceling symmetric linear-mixing terms under idealized assumptions.

## Signal model and assumptions
The robustness argument is based on an idealized model in which observed channels are linear mixtures of independent source processes:

```text
x(t) = sum_i a_i s_i(t)
y(t) = sum_i b_i s_i(t)
```

The sources are assumed to be zero-mean, mutually independent, real-valued, and strictly stationary. In this setting, cross-source Fourier moments vanish unless their frequency factors satisfy the appropriate balance conditions. For positive non-degenerate frequencies, only same-source terms survive in the linear-mixing null model, and those terms are canceled by an antisymmetric channel-swap contrast.

These assumptions are useful for designing the index, but real neural data may violate them. Preprocessing, artifact rejection, stationarity checks, sufficient segment counts, and control analyses remain necessary.

## Fourth-order ACT / 1:3 cubic coupling
For two signals `x` and `y`, the fourth-order trispectral term for 1:3 coupling is:

```text
T_xxxy(f) = < X(f)^3 Y(3f)* >
```

A channel-swapped counterpart is:

```text
T_yxxx(f) = < Y(f) X(f)^2 X(3f)* >
```

The antisymmetric cross-trispectrum is:

```text
T_[x|xx|y](f) = T_xxxy(f) - T_yxxx(f)
```

Under the independent linear-mixing null, the two terms contain matching symmetric contributions, so their difference vanishes in the population limit. In the presence of genuine ordered cubic coupling, the difference can remain nonzero.

## Normalization
Define a fourth-order amplitude norm:

```text
Q_x(f) = < |X(f)|^4 >^(1/4)
```

The normalized antisymmetric cross-tricoherence is:

```text
Gamma_[x|xx|y]^(4)(f) =
  T_[x|xx|y](f) /
  ( Q_x(f)^3 Q_y(3f) + Q_y(f) Q_x(f)^2 Q_x(3f) )
```

The denominator follows from Hölder-style bounds and the triangle inequality. The intended magnitude range is `[0, 1]` when the denominator is positive and estimates are well behaved.

## General m-th order ACP
For statistical order `m >= 2`, define:

```text
P_x...xy^(m)(f) = < X(f)^(m-1) Y((m-1)f)* >
P_yx...x^(m)(f) = < Y(f) X(f)^(m-2) X((m-1)f)* >
P_[x|x...x|y]^(m)(f) = P_x...xy^(m)(f) - P_yx...x^(m)(f)
```

Using:

```text
Q_x(f) = < |X(f)|^m >^(1/m)
```

normalize as:

```text
Gamma_[x|x...x|y]^(m)(f) =
  P_[x|x...x|y]^(m)(f) /
  ( Q_x(f)^(m-1) Q_y((m-1)f) + Q_y(f) Q_x(f)^(m-2) Q_x((m-1)f) )
```

Special cases:
- `m = 2`: the antisymmetric construction corresponds to the imaginary part of coherency, up to the imaginary factor and normalization.
- `m = 3`: it matches the antisymmetric cross-bicoherence idea.
- `m = 4`: it yields the antisymmetric cross-tricoherence for cubic 1:3 interactions.

## Practical estimation pseudocode
```text
input: time_series matrix, sampling_rate, ordered channels x/y, order m, frequency grid
segment signals with Hann window
compute FFT per segment
for each base frequency f:
    locate nearest FFT bin for f and target = (m-1)f
    skip if target exceeds Nyquist
    Xf = FFT_x[:, bin_f]
    Yf = FFT_y[:, bin_f]
    Xt = FFT_x[:, bin_target]
    Yt = FFT_y[:, bin_target]
    term1 = mean(Xf^(m-1) * conj(Yt))
    term2 = mean(Yf * Xf^(m-2) * conj(Xt))
    numerator = term1 - term2
    denom = Qx(f)^(m-1) Qy(target) + Qy(f) Qx(f)^(m-2) Qx(target)
    gamma = numerator / denom if denom > 0 else incomplete
output: gamma, |gamma|, term comparisons, warnings, optional surrogate p-value
```

## Surrogate statistics
A simple segment-permutation surrogate can break cross-frequency temporal alignment while preserving marginal Fourier amplitudes. For a polyspectral statistic `z`, generate surrogate values by permuting the target-frequency segment order:

```text
z_hat(n) = mean( base_terms[k] * conj(target_terms[perm_n(k)]) )
```

An approximate Rayleigh/Gaussian screening statistic is:

```text
r = |z|^2 / mean_n |z_hat(n)|^2
p = exp(-r)
```

This approximation relies on enough segments and approximately circular-symmetric null behavior. Validate it with white-noise simulations or task-specific null controls before using it for strong claims.

## Input requirements
- Numeric channel-wise time series with finite values.
- Sampling rate high enough that `(m-1)f` is below Nyquist.
- Enough samples to produce multiple overlapping or non-overlapping segments.
- Meaningful preprocessing appropriate for EEG/MEG or the target neural modality.

## Statistical interpretation boundaries
- ACP/ACT is evidence of structured higher-order dependency, not proof of causality.
- A high non-antisymmetric CT term without a high antisymmetric contrast may reflect instantaneous mixing rather than genuine interaction.
- Approximate p-values require validation and multiple-comparison correction when scanning many channels or frequencies.
- Clinical or neuromodulation conclusions require independent experimental design, safety review, and domain expertise.

## Known edge cases
- Degenerate frequency combinations can create factorable terms that survive antisymmetrization. In practical neural spectral analyses, restrict to positive non-degenerate frequencies.
- Very small denominators make normalized values unstable; mark those frequencies as incomplete or unreliable.
- Short recordings, heavy artifacts, narrowband leakage, and nonstationary bursts can distort high-order estimates.
