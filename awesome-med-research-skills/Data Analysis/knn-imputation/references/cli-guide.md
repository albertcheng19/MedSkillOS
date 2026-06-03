# CLI Usage Guide

## Basic Syntax

```bash
Rscript scripts/main.R [OPTIONS]
```

## Required Arguments

| Argument | Description |
|----------|-------------|
| `-i FILE` | Expression matrix CSV file |
| `-g FILE` | Group annotation CSV file |

## Optional Arguments

| Argument | Default | Description |
|----------|---------|-------------|
| `-o DIR` | `./output/` | Output directory |
| `-c VALUE` | `sample` | Sample ID column in the group file |
| `-l VALUE` | `group` | Single grouping column used to build strata |
| `-k VALUE` | `10` | Number of nearest neighbors |
| `--overwrite` | `FALSE` | Overwrite existing output files |
| `-t VALUE` | `0` | Optional timeout in seconds |
| `-s VALUE` | `42` | Random seed |

## Verified Local Runs

This section is updated from real local executions on the sample fixture files in `tests/data/`.

`tests/data/` is included as a repository fixture set for examples and local validation. It is not required input naming for the skill itself; users can supply any CSV files that match the documented schema.

The current workflow first removes genes with more than 50% missing values, then applies KNN only to strata with at least 11 samples.

### Example 1: Default Group-Stratified Run

**Actual command**

```bash
Rscript scripts/main.R \
  --input_file tests/data/sample_expression_matrix.csv \
  --group_file tests/data/sample_groups.csv \
  --output_dir tests/output/basic_run \
  --sample_column sample \
  --group_column group \
  --k 10 \
  --overwrite \
  --timeout_seconds 0 \
  --seed 42
```

**Runtime and resources**

- Exit code: `0`
- Wall time: `209.528 s`
- User CPU time: `215.053 s`
- System CPU time: `22.599 s`
- Peak memory: `237772 KB`

**Output files**

- `tests/output/basic_run/imputed_expression_matrix.csv`
- `tests/output/basic_run/session_info.txt`

**Output content summary**

- `session_info.txt`: `R 4.1.2`, `DMwR2 0.0.2`, `data.table 1.15.4`, `optparse 1.7.1`

- Verified behavior: the run completed successfully, wrote both output files, and removed all remaining `NA` values from the output matrix.


### Example 2: Smaller Neighborhood

**Actual command**

```bash
Rscript scripts/main.R \
  --input_file tests/data/sample_expression_matrix.csv \
  --group_file tests/data/sample_groups.csv \
  --output_dir tests/output/k5_run \
  --sample_column sample \
  --group_column group \
  --k 5 \
  --overwrite \
  --timeout_seconds 0 \
  --seed 42
```

**Runtime and resources**

- Exit code: `0`
- Wall time: `204.528 s`
- User CPU time: `210.470 s`
- System CPU time: `21.699 s`
- Peak memory: `247744 KB`

**Output files**

- `tests/output/k5_run/imputed_expression_matrix.csv`
- `tests/output/k5_run/session_info.txt`

**Output content summary**

- `session_info.txt`: `R 4.1.2`, `DMwR2 0.0.2`, `data.table 1.15.4`, `optparse 1.7.1`

- Verified behavior: the run completed successfully, wrote both output files, and removed all remaining `NA` values from the output matrix.


### Example 3: Custom Grouping Column

**Actual command**

```bash
Rscript scripts/main.R \
  --input_file tests/data/sample_expression_matrix.csv \
  --group_file tests/data/sample_groups_custom.csv \
  --output_dir tests/output/custom_group_run \
  --sample_column sample \
  --group_column cohort \
  --k 3 \
  --overwrite \
  --timeout_seconds 0 \
  --seed 42
```

**Expected behavior**

- Exit code: `0`
- The run completes successfully using `cohort` as the stratification column.

### Unsupported Input: Multi-Column Stratification

**Actual command**

```bash
Rscript scripts/main.R \
  --input_file tests/data/sample_expression_matrix.csv \
  --group_file tests/data/sample_groups.csv \
  --output_dir tests/output/invalid_group_column \
  --sample_column sample \
  --group_column group,cohort \
  --k 3 \
  --overwrite \
  --timeout_seconds 0 \
  --seed 42
```

**Expected behavior**

- Exit code: `1`
- Error: `SKILL_INVALID_PARAMETER: --group_column must contain exactly one column name`
- No output files are written for this invalid invocation.

## Exit Codes

| Code | Meaning |
|------|---------|
| `0` | Success |
| `1` | Error |
