# Algorithm Details

## Overview

This skill implements a two-stage workflow for bulk expression matrices with `DMwR2::knnImputation`.

1. Remove genes whose missing-value fraction across all samples is at least 50%.
2. Samples are the neighbor units.
3. Features remain in rows.
4. Missing values are imputed within user-defined strata.
5. Only strata with at least 11 samples run the `DMwR2` backend.

## Strata Construction

Strata are defined from the single column named in `--group_column`.

- `group` creates one stratum per biological group.

Only one grouping column is supported. Samples inside the same stratum can donate values to one another.

## Imputation Rule

Before KNN:

1. Compute each gene's missing-value fraction across all samples.
2. Remove any gene with a missing-value fraction greater than or equal to 0.5.
3. For each remaining stratum, mark any gene whose within-stratum missing-value fraction is greater than or equal to 0.5 as non-imputable inside that stratum.

For each missing value in the remaining matrix:

1. Skip the stratum entirely if it contains fewer than 11 samples.
2. Within each stratum, leave missing entries unchanged for genes marked as non-imputable in that stratum.
3. Transpose the remaining imputable part of the stratum matrix so samples become rows.
4. For each target sample, build leave-one-out donor reference data from the other samples only.
5. Fill donor-side missing entries with within-feature means, falling back to global feature means when needed.
6. If the target sample still has at least one observed imputable feature, call `DMwR2::knnImputation(target, distData = donor_data, k = k, meth = "weighAvg", scale = FALSE)`.
7. If the target sample is entirely missing across all remaining imputable features, fill it directly from the leave-one-out donor means for that stratum.
8. Write the imputed target back into the stratum matrix.

`DMwR2` performs weighted neighbor averaging when `meth = "weighAvg"`.

## Small-Stratum Rule

If a stratum contains fewer than 11 samples, the implementation does not run KNN for that stratum.

Instead, it fills missing values row-wise within that stratum using the configured `--small_strata_fill_method` (`mean` or `median`).

If a small-stratum feature row has no within-stratum observed values but is still below the global `>=50%` filter threshold, the implementation falls back to the corresponding global feature summary.

If every stratum is below the KNN threshold, the command still completes and writes outputs using this direct-fill fallback logic.

## Fallback Rule

If a feature reaches 50% or more missingness inside a stratum, the implementation skips imputation for that feature in that stratum and keeps those missing values as `NA`.

For other features that are still imputable inside a stratum:

1. Use the feature-wise global mean across all samples as a temporary fill value before running `DMwR2`.
2. If the entire feature row is missing after the global >=50% filter, keep `NA`.

If a target sample is completely missing across all imputable features in its stratum, the implementation skips `DMwR2` for that target and uses the leave-one-out donor means directly.

## Assumptions

- Input data are continuous numeric values.
- Missingness is sparse enough that nearest-neighbor information is informative after removing genes with >50% missing values.
- Group annotations are correct and aligned to the matrix columns.
- The matrix fits in available memory because the `DMwR2` backend operates on in-memory stratum matrices.
