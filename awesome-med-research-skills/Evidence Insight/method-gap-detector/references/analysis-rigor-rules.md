# Analysis Rigor Rules

Use this module when judging modeling and statistical weaknesses.

## Core Audit Points
- preprocessing quality
- normalization / harmonization adequacy
- batch-effect handling when relevant
- overfitting risk relative to sample burden
- multiple-testing control when relevant
- calibration and decision-utility assessment for predictive models
- sensitivity analyses or robustness checks
- comparator-model adequacy

## Important Rule
High performance metrics do not rescue weak analysis design. Strong AUC, C-index, or accuracy should not override overfitting, leakage, or poor calibration concerns.