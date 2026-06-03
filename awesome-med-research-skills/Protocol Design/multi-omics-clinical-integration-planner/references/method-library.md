# Method Library

Use methods only when they fit the question and data reality.

## Common modules
- Clinical baseline profiling and covariate review
- Differential analysis / abundance analysis
- Pathway or module scoring
- Cross-layer correlation or concordance assessment
- Clinical association and regression modeling
- Survival / response modeling
- Stratification / clustering with clinical anchoring
- Feature selection and score construction
- Incremental-value testing versus clinical-only models
- Calibration and validation assessment

## Transcriptomics rule
If transcriptomic differential analysis is used:
- **count data → DESeq2 (recommended default)**
- **non-count normalized data → limma**

## Rule
Do not recommend methods that require endpoints, matched samples, or metadata that have not been introduced earlier in the plan.
