# Troubleshooting

## `SKILL_MISSING_INPUT`

Cause:

- `--data_file` or `--target_var` was not provided.

Fix:

- Pass both required arguments.

## `SKILL_FILE_NOT_FOUND`

Cause:

- Input path is incorrect.

Fix:

- Check the file path and rerun the command.

## `SKILL_MISSING_COLUMNS`

Cause:

- The target column does not exist.
- One or more columns listed in `--exclude_vars` do not exist.

Fix:

- Verify exact column names, including case and spaces.

## `SKILL_INVALID_DATA`

Cause:

- No predictor columns remain after exclusions.
- Regression target could not be parsed as numeric.
- The data becomes unusable after cleaning.

Fix:

- Recheck the target column type.
- Remove incompatible columns from `exclude_vars`.
- Inspect the input file for malformed values.

## `SKILL_INSUFFICIENT_DATA`

Cause:

- Too few complete rows remain after missing-value filtering.
- Classification leaves only one target class.
- The chosen `train_ratio` leaves no test rows.

Fix:

- Provide more rows.
- Reduce missing values.
- Lower `--train_ratio` if needed.

## Degenerate No-Split Tree Warning

Cause:

- The model fit completed, but the training set was too small or too constrained for the tree to make any split.
- `--minsplit` or `--minbucket` may be too large for the available training rows.

Symptoms:

- A warning says that the decision tree did not split.
- Feature importances are all zero.
- Predictions may collapse to a single constant value.

Fix:

- Lower `--minsplit` and `--minbucket`.
- Increase the number of usable training rows.
- Re-run the analysis and confirm the feature-importance table is no longer all zeros.

## `SKILL_DEPENDENCY_MISSING`

Cause:

- Required R packages are not installed.

Fix:

```bash
Rscript -e 'install.packages(c("optparse", "data.table", "rpart"), repos="https://cloud.r-project.org")'
```
