# Troubleshooting Guide

## Common Errors

### SKILL_FILE_NOT_FOUND

**Error:**
```text
SKILL_FILE_NOT_FOUND: path/to/file.csv
```

**Solution:**
- Verify the file path is correct
- Check file permissions
- Ensure the file exists before running
- Use absolute paths if relative paths are ambiguous

### SKILL_MISSING_COLUMNS

**Error:**
```text
SKILL_MISSING_COLUMNS: group_col not found in group_file
```

**Solution:**
- Verify the selected column name exists in the file header
- Check whether the first two columns are sample ID and group when custom column names are omitted
- Confirm the matrix file has feature IDs in the first column

### SKILL_SAMPLE_MISMATCH

**Error:**
```text
SKILL_SAMPLE_MISMATCH: S1, S2, S3
```

**Solution:**
- Ensure sample IDs in the group file exactly match matrix column names
- Check for hidden whitespace or encoding issues
- Verify case sensitivity
- Make sure sample names were not altered during spreadsheet export

### SKILL_EMPTY_DATA

**Error:**
```text
SKILL_EMPTY_DATA: matrix is empty after preprocessing
```

**Solution:**
- Check whether all abundance values are zero
- Confirm the input matrix is numeric
- Verify that sample alignment did not remove all data
- Inspect whether filtering left no usable rows

### SKILL_INVALID_PARAMETER

**Error:**
```text
SKILL_INVALID_PARAMETER: --method must be one of tsne, umap, both
```

**Solution:**
- Use only supported method values: `tsne`, `umap`, `both`
- Check parameter spelling
- Ensure numeric parameters are within valid ranges
- For t-SNE, use a smaller perplexity when sample count is low
- For UMAP, set `n_neighbors` smaller than the number of samples

### SKILL_PACKAGE_NOT_FOUND

**Error:**
```text
SKILL_PACKAGE_NOT_FOUND: optparse, Rtsne | Run: Rscript scripts/install_dependencies.R
```

**Solution:**
- Run `Rscript scripts/install_dependencies.R`
- Install the missing package(s) from CRAN
- Confirm the package is installed in the R environment used by `Rscript`
- Re-run `Rscript scripts/main.R --help` after installation

### SKILL_TIMEOUT

**Error:**
```text
SKILL_TIMEOUT: analysis exceeded 30 seconds | Increase --timeout or use --timeout 0 to disable timeout
```

**Solution:**
- Increase `--timeout`
- Set `--timeout 0` to disable timeout
- Reduce data size or run only one method at a time
- Install `R.utils` if timeout control is enabled

## Visualization Issues

### Empty or Collapsed Plot

**Cause:** Coordinates are degenerate, or data contain too few informative features

**Solution:**
- Check whether all samples have very similar abundance profiles
- Increase data quality control before running
- Try UMAP and t-SNE separately to compare behavior

### Ellipse Warning

**Cause:** Too few points in one or more groups for stable ellipse fitting

**Solution:**
- Ensure each group has at least 2 samples
- Prefer more samples per group for stable group boundaries
- Disable ellipse drawing if you customize plotting functions later

## Method-Specific Issues

### t-SNE Error: Perplexity Too Large

**Cause:** `perplexity` is too large relative to sample count

**Solution:**
- Reduce `--perplexity`
- A common rule is to keep perplexity well below `(n_samples - 1) / 3`

### UMAP Error: n_neighbors Too Large

**Cause:** `n_neighbors` must be smaller than the number of samples

**Solution:**
- Reduce `--n_neighbors`
- For very small datasets, use a small value such as `2` to `5`

### Timeout Error

**Cause:** Analysis exceeded the configured timeout

**Solution:**
- Increase `--timeout`
- Set `--timeout 0` to disable timeout
- Reduce data size or run only one method at a time
- Install `R.utils` in the same R environment if timeout control is enabled

### Dependency Installation Error

**Cause:** The R environment cannot reach CRAN, or package compilation prerequisites are missing.

**Solution:**
- Confirm the machine can access `https://cloud.r-project.org`
- Retry with `Rscript scripts/install_dependencies.R`
- If package compilation fails, install the required system libraries for your platform and rerun the installer
- Validate the environment with `Rscript scripts/main.R --help` before running the full analysis

## Testing Issues

### Smoke Tests Cannot Find Sample Data

**Cause:** Tests or examples were run against legacy paths outside `tests/data/`

**Solution:**
- Use `tests/data/otu_table.csv` and `tests/data/group_info.csv`

## Data Format Problems

### Matrix Contains Text Values

**Cause:** Abundance matrix has non-numeric values in sample columns

**Solution:**
- Remove annotation columns from the matrix body
- Keep only feature IDs in the first column
- Ensure remaining columns are numeric

### Group File Has Extra Metadata Columns

**Cause:** The script cannot infer the intended columns if metadata layout is unusual

**Solution:**
- Explicitly specify `--sample_id_col` and `--group_col`
- Reorder the file so the first two columns are sample ID and group if preferred
