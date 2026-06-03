# Troubleshooting Guide

## SKILL_FILE_NOT_FOUND

**Error:**

```text
SKILL_FILE_NOT_FOUND: Reference file does not exist: ...
```

**Solution:**
- Confirm the path passed to `--key_genes` or `--reference_dir` is correct.
- Verify the bundled `references/database/` directory still contains all CSV files.

## SKILL_INVALID_PARAMETER

**Error:**

```text
SKILL_INVALID_PARAMETER: --mirna_dataset must be one of ...
```

**Solution:**
- Use only documented values for `--mirna_dataset`, `--lncrna_strictness`, and `--layout_type`.
- Check spelling and case.

## SKILL_INVALID_DATA

**Error:**

```text
SKILL_INVALID_DATA: No valid key genes were provided
```

**Solution:**
- Ensure the gene file is not empty.
- Put one gene symbol per line, or pass a comma-separated string.
- Remove unsupported comment formatting except lines beginning with `#`.

## SKILL_INVALID_DATA

**Error:**

```text
SKILL_INVALID_DATA: No miRNA-mRNA interactions matched the provided key genes
```

**Solution:**
- Check whether the gene symbols are present in the bundled databases.
- Try `--mirna_dataset starbase` or another source mode.
- Try a less restrictive lncRNA setting if the network becomes too small after filtering.

## SKILL_INVALID_DATA

**Error:**

```text
SKILL_INVALID_DATA: No miRNA-lncRNA interactions remained after filtering; the ceRNA layer collapsed.
```

**Solution:**
- Lower `--lncrna_freq_thresh` so at least one lncRNA remains in the network.
- Try a different `--lncrna_strictness` level or `--mirna_dataset` mode.
- Confirm the provided key genes actually connect to lncRNA-supported miRNAs in the bundled reference data.

## SKILL_EMPTY_DATA

**Error:**

```text
SKILL_EMPTY_DATA: Reference file has no rows: ...
```

**Solution:**
- Check whether the reference CSV is empty after export.
- Check whether the bundled reference file was damaged or exported incorrectly.
- If using custom data, ensure the file contains at least one valid interaction row.

## SKILL_EMPTY_FILE

**Error:**

```text
SKILL_EMPTY_FILE: Key gene file is empty: ...
```

**Solution:**
- Add at least one valid gene symbol to the input file.
- If the empty file was generated upstream, re-export it and confirm it contains data before rerunning.
- Check whether the referenced file path points to the intended file rather than a placeholder.

## SKILL_MISSING_COLUMNS

**Error:**

```text
SKILL_MISSING_COLUMNS: Missing columns in miRNA_mRNA.csv: miRNA, mRNA
```

**Solution:**
- Verify the provided input table uses the expected column names.
- Confirm that custom CSV inputs, if any, still use the documented `miRNA,mRNA` or `miRNA,lncRNA` column pairs.

## SKILL_DEPENDENCY_MISSING

**Error:**

```text
SKILL_DEPENDENCY_MISSING: igraph
```

**Solution:**
- Install the missing CRAN package, for example `install.packages("igraph")`.
- Re-run the command after package installation.

## SKILL_TIMEOUT

**Error:**

```text
SKILL_TIMEOUT: ceRNA analysis exceeded the timeout limit
```

**Solution:**
- Increase `--timeout_seconds` and rerun the job.
- Try a smaller or less expensive dataset mode first to confirm the workflow is otherwise healthy.
- Run on a machine with more available CPU and memory if large reference intersections are expected.

## SKILL_RUNTIME_ERROR

**Error:**

```text
SKILL_RUNTIME_ERROR: ceRNA analysis failed: ...
```

or

```text
SKILL_RUNTIME_ERROR: Failed to source run_analysis.R: ...
```

**Solution:**
- Read the trailing message after `SKILL_RUNTIME_ERROR` to identify the failing stage.
- Confirm all bundled scripts and reference files are present and unmodified.
- Re-run after fixing the upstream cause; if the error occurs while sourcing a script, verify the local package environment and script integrity.
