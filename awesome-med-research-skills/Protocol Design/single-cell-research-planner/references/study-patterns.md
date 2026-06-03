# Study Patterns

Use one dominant pattern. A secondary pattern may be added only as a supporting layer.

## Pattern A — Cell Atlas / Composition Mapping
Use when the user mainly wants to characterize major cell populations, composition shifts, or disease-vs-control cellular architecture.

Best for:
- first-pass disease landscape
- tissue microenvironment description
- cell-type proportion change questions

Do not overextend this pattern into mechanism unless additional modules justify it.

## Pattern B — Key Cell / Key State Prioritization
Use when the user wants to identify which cell type or state most strongly aligns with disease biology, phenotype severity, or a mechanism theme.

Best for:
- prioritizing driver-like cell populations
- linking cell programs to disease intensity
- focusing downstream validation

## Pattern C — State Transition / Trajectory
Use when the question is inherently about progression, differentiation, exhaustion, activation, fibrosis transition, or lineage-like change.

Requirements:
- sufficient state diversity
- biologically credible ordering hypothesis
- adequate cell numbers in relevant populations

Do not force trajectory analysis in static or weakly ordered systems.

## Pattern D — Cell-Cell Communication / Microenvironment Crosstalk
Use when the user cares about intercellular signaling, niche remodeling, stromal-immune interaction, or tumor microenvironment crosstalk.

Requirements:
- biologically distinct interacting populations
- sufficient abundance of sender and receiver groups
- communication interpreted as inferred signaling, not proven contact biology

## Pattern E — Translational Biomarker / Target Discovery
Use when the user wants clinically relevant markers, stratification signals, therapeutic targets, or actionable cell-state programs.

This pattern requires explicit separation of:
- descriptive discovery
- prioritization logic
- validation logic
- translational extension

## Pattern F — Treatment Response / Resistance Mechanism
Use when the user wants to compare responder/non-responder states, pre/post treatment differences, or resistance-associated cell programs.

Must define whether signals are:
- predictive baseline features
- treatment-emergent features
- resistance-associated descriptive signals

Do not blur these categories.
