# Method Gap Taxonomy

Use this module to classify methodological gaps into operational categories before prioritization.

## Core Gap Classes
- **Design gap**: cohort construction, comparator choice, endpoint framing, temporality, sampling frame, case definition, inclusion/exclusion logic.
- **Bias-control gap**: weak confounder adjustment, selection bias, information bias, missing-data handling, uncontrolled heterogeneity.
- **Analysis-rigor gap**: weak preprocessing, poor normalization, unhandled batch effects, inadequate model comparison, overfitting risk, multiple-testing weakness, calibration neglect.
- **Validation-depth gap**: internal-only validation, no external validation, no orthogonal confirmation, no replication across cohorts/platforms.
- **Reproducibility/reporting gap**: weak software/parameter transparency, incomplete assay detail, no code/data availability, under-specified workflow.
- **Transportability / implementation gap**: model or assay cannot travel across settings, populations, platforms, or clinical workflows.

## Important Rule
Do not collapse all weaknesses into one category. Assign the primary gap class first, then note secondary linked weaknesses only if needed.