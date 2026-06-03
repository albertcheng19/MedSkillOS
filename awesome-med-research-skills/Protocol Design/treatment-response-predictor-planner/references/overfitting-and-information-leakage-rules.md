# Overfitting and Information Leakage Rules

## Core Rule
Response-prediction studies are highly vulnerable to leakage from post-treatment data, feature selection on the full dataset, and unstable thresholding.

## Common Risk Sources
- post-treatment or on-treatment contamination
- feature selection before split or resampling
- outcome-informed cutoff selection
- class imbalance with unstable decision thresholds
- optimism from reuse of the same cohort
- pooled-regimen modeling without treatment specificity
- modality leakage from incomplete-case filtering linked to outcome

## Important Rule
Always identify the strongest likely leakage source and how the design should mitigate it.
