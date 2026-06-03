# Risk Notes: Neural EMD Preprocessing

## Main risks
- Automatic IMF rejection can remove real neural activity, especially high-gamma, sharp transients, epileptiform events, sleep graphoelements, or stimulation-evoked responses.
- EMD-family methods are adaptive; IMF order and frequency content can change across channels, participants, trials, and parameter settings.
- EEMD and CEEMDAN are stochastic unless seeds and parallel settings are controlled.
- Boundary effects can distort the beginning and end of a recording or epoch.
- Decomposition quality can degrade when the signal is too short, clipped, saturated, flat, or strongly nonuniformly sampled.
- A cleaned-looking trace can still contain volume conduction, reference artifacts, line noise, or source mixing.

## Biomedical integrity rules
- Do not present the output as a clinical diagnosis.
- Do not state that a removed IMF is definitely muscle, ocular, seizure, or disease activity without independent evidence.
- Do not tune IMF rejection rules on test labels or clinical outcomes.
- Do not claim causal neural mechanisms from preprocessing results alone.
- Keep raw data and full preprocessing metadata available for audit.

## Recommended safeguards
- Save both raw and cleaned outputs.
- Report all rejected IMF indices per channel.
- Run sensitivity analyses with alternative rejection rules.
- Compare EMD cleaning against conventional filters and artifact correction methods.
- Inspect representative channels visually.
- For publishable work, use a mature EMD library rather than the fallback scaffold.
