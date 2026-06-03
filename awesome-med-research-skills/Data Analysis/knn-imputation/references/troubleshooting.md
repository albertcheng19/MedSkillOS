# Troubleshooting Guide

## SKILL_FILE_NOT_FOUND

**Error**

```text
SKILL_FILE_NOT_FOUND: File does not exist: /path/to/file.csv
```

**Solution**

- Check that the file path is correct.
- Confirm that the file is readable.
- Use absolute paths if needed.

## SKILL_EMPTY_FILE

**Error**

```text
SKILL_EMPTY_FILE: File is empty: /path/to/file.csv
```

**Solution**

- Confirm that the file was exported correctly.
- Recreate the CSV with a header row and data rows.
- Check that upstream preprocessing did not generate an empty file.

## SKILL_OUTPUT_EXISTS

**Error**

```text
SKILL_OUTPUT_EXISTS: Output files already exist in /path/to/output: imputed_expression_matrix.csv, session_info.txt. Use --overwrite to replace them
```

**Solution**

- Re-run the command with `--overwrite`.
- Or use a new `--output_dir`.

## SKILL_SAMPLE_MISMATCH

**Error**

```text
SKILL_SAMPLE_MISMATCH: Samples missing from expression matrix: Sample03, Sample04
```

**Solution**

- Ensure the sample IDs in `group_file` match matrix column names exactly.
- Remove leading or trailing whitespace from sample IDs.
- Verify the correct `--sample_column` was provided.
- Check that the selected grouping column does not contain missing values.

## SKILL_MISSING_COLUMNS

**Error**

```text
SKILL_MISSING_COLUMNS: Missing group column(s): cohort
```

**Solution**

- Check the header row of the group file.
- Make sure the group file contains the column passed to `--group_column`.
- Verify column names are case-sensitive.

## SKILL_INVALID_DATA

**Error**

```text
SKILL_INVALID_DATA: Duplicate sample IDs detected in group file
```

**Solution**

- Remove duplicate sample IDs.
- Confirm the expression matrix contains at least two sample columns.
- Make sure numeric columns do not contain text values.

## SKILL_DEPENDENCY_MISSING

**Error**

```text
SKILL_DEPENDENCY_MISSING: Package not installed: data.table
```

**Solution**

- Install the missing package in the local R environment.
- Re-run the command after installation.
- `DMwR2` must be installed before the script is executed.

## Timeout Issues

If the script stops because of elapsed time:

- Increase `--timeout_seconds`.
- Reduce input size if memory is constrained.
- Split the dataset into smaller batches upstream if the file is extremely large.

## Unresolved Missing Values

If the console log reports unresolved missing values after imputation:

- Check whether genes with more than 50% missing values were removed before imputation.
- Check whether an entire feature row is missing.
- Check whether a stratum has fewer than 11 samples; those strata are skipped.
- Consider whether the current grouping labels create groups that are too small for KNN.

## DMwR2 Backend Notes

If `DMwR2` fails on custom data:

- Check whether the stratum has at least 11 samples; smaller strata are skipped instead of being imputed.
- Reduce `--k` if a stratum is small.
- Check whether one stratum is dominated by missing values, which weakens neighbor selection.
- Remember that donor selection is leave-one-out: a target sample never uses its own completed copy as a neighbor.
