# CLI Usage Guide

## Basic Syntax

```bash
Rscript scripts/main.R [OPTIONS]
```

## Environment Setup

Run this once in a fresh R environment:

```bash
Rscript scripts/install_dependencies.R
```

The exact tested dependency baseline is recorded in `dependencies.lock.tsv`.

Manual CRAN installation alternative:

```bash
Rscript -e "install.packages(c('optparse','data.table','Rtsne','umap','ggplot2','vegan','R.utils'), repos='https://cloud.r-project.org')"
```

`R.utils` is optional unless timeout control is enabled with `--timeout > 0`. `testthat` is installed as the development dependency for unit tests.

## Dependency Baseline

| Package | Tested Version |
|---------|----------------|
| `optparse` | `1.7.5` |
| `data.table` | `1.15.4` |
| `Rtsne` | `0.17` |
| `umap` | `0.2.10.0` |
| `ggplot2` | `3.4.0` |
| `vegan` | `2.7.3` |
| `R.utils` | `2.13.0` |
| `testthat` | `3.1.2` |

## Required Arguments

| Argument | Description |
|----------|-------------|
| `-i FILE` | Abundance / OTU matrix file |
| `-g FILE` | Group information file |

## Optional Arguments

| Argument | Default | Description |
|----------|---------|-------------|
| `-o DIR` | `./output/` | Output directory |
| `-m METHOD` | `both` | Run `tsne`, `umap`, or `both` |
| `--sample_id_col NAME` | first column | Sample ID column in group file |
| `--group_col NAME` | second column | Group column in group file |
| `--perplexity VALUE` | `25` | t-SNE perplexity |
| `--theta VALUE` | `0.0` | t-SNE theta |
| `--pca TRUE/FALSE` | `FALSE` | Apply PCA before t-SNE |
| `--check_duplicates TRUE/FALSE` | `FALSE` | Enable duplicate checking in t-SNE |
| `--normalize TRUE/FALSE` | `TRUE` | Normalize matrix before UMAP |
| `--norm_method NAME` | `hellinger` | Normalization method for `vegan::decostand()` |
| `--n_neighbors VALUE` | `10` | UMAP neighborhood size |
| `-s VALUE` | `42` | Random seed |
| `-t VALUE` | `0` | Timeout in seconds; `0` disables timeout |

## Complete Examples

### Example 1: Basic UMAP + t-SNE Analysis

```bash
Rscript scripts/install_dependencies.R

Rscript scripts/main.R \
  --input_file tests/data/otu_table.csv \
  --group_file tests/data/group_info.csv \
  --output_dir ./results
```

### Output Files

| File | Size (bytes) |
|------|--------------|
| `data/session_info.txt` | `1620` |
| `data/analysis_data.rda` | varies |
| `table/tsne_coordinates.csv` | `4199` |
| `plot/tsne_plot.pdf` | `11758` |
| `table/umap_coordinates.csv` | `4249` |
| `plot/umap_plot.pdf` | `11604` |

### Runtime and Resource Usage

| Metric | Value |
|--------|-------|
| Start time | `2026-04-14 15:03:19` |
| End time | `2026-04-14 15:03:22` |
| Exit code | `0` |
| Wall-clock time | `0m2.853s` |
| User CPU time | `0m2.467s` |
| System CPU time | `0m1.414s` |
| Max resident set size | `Not recorded` |

### Example 2: t-SNE Only

```bash
Rscript scripts/main.R \
  --input_file tests/data/otu_table.csv \
  --group_file tests/data/group_info.csv \
  --output_dir ./results \
  --method tsne
```

### Output Files

| File | Size (bytes) |
|------|--------------|
| `data/session_info.txt` | `1620` |
| `data/analysis_data.rda` | varies |
| `table/tsne_coordinates.csv` | `4199` |
| `plot/tsne_plot.pdf` | `11758` |

### Runtime and Resource Usage

| Metric | Value |
|--------|-------|
| Start time | `2026-04-14 15:10:29` |
| End time | `2026-04-14 15:10:31` |
| Exit code | `0` |
| Wall-clock time | `0m1.926s` |
| User CPU time | `0m1.760s` |
| System CPU time | `0m1.397s` |
| Max resident set size | `Not recorded` |

### Example 3: UMAP Only with Custom Columns

```bash
Rscript scripts/main.R \
  --input_file tests/data/otu_table.csv \
  --group_file tests/data/group_info.csv \
  --output_dir ./results \
  --method umap \
  --sample_id_col SampleID \
  --group_col Group
```

### Output Files

| File | Size (bytes) |
|------|--------------|
| `data/session_info.txt` | `1620` |
| `data/analysis_data.rda` | varies |
| `table/umap_coordinates.csv` | `4249` |
| `plot/umap_plot.pdf` | `11604` |

### Runtime and Resource Usage

| Metric | Value |
|--------|-------|
| Start time | `2026-04-14 15:12:09` |
| End time | `2026-04-14 15:12:11` |
| Exit code | `0` |
| Wall-clock time | `0m2.209s` |
| User CPU time | `0m2.175s` |
| System CPU time | `0m1.397s` |
| Max resident set size | `Not recorded` |

### Example 4: Custom t-SNE and UMAP Parameters

```bash
Rscript scripts/main.R \
  --input_file tests/data/otu_table.csv \
  --group_file tests/data/group_info.csv \
  --output_dir ./results \
  --method both \
  --perplexity 10 \
  --theta 0.5 \
  --n_neighbors 15 \
  --seed 42
```

### Output Files

| File | Size (bytes) |
|------|--------------|
| `data/session_info.txt` | `1620` |
| `data/analysis_data.rda` | varies |
| `table/tsne_coordinates.csv` | `4215` |
| `plot/tsne_plot.pdf` | `11651` |
| `table/umap_coordinates.csv` | `4229` |
| `plot/umap_plot.pdf` | `11576` |

### Runtime and Resource Usage

| Metric | Value |
|--------|-------|
| Start time | `2026-04-14 15:12:42` |
| End time | `2026-04-14 15:12:44` |
| Exit code | `0` |
| Wall-clock time | `0m2.583s` |
| User CPU time | `0m2.620s` |
| System CPU time | `0m1.275s` |
| Max resident set size | `Not recorded` |

### Example 5: Disable UMAP Normalization

```bash
Rscript scripts/main.R \
  --input_file tests/data/otu_table.csv \
  --group_file tests/data/group_info.csv \
  --output_dir ./results \
  --method umap \
  --normalize FALSE
```

### Output Files

| File | Size (bytes) |
|------|--------------|
| `data/session_info.txt` | `1620` |
| `data/analysis_data.rda` | varies |
| `table/umap_coordinates.csv` | `4288` |
| `plot/umap_plot.pdf` | `11629` |

### Runtime and Resource Usage

| Metric | Value |
|--------|-------|
| Start time | `2026-04-14 15:13:40` |
| End time | `2026-04-14 15:13:43` |
| Exit code | `0` |
| Wall-clock time | `0m2.634s` |
| User CPU time | `0m2.281s` |
| System CPU time | `0m1.421s` |
| Max resident set size | `Not recorded` |

## Getting Help

```bash
Rscript scripts/install_dependencies.R

Rscript scripts/main.R --help

Rscript tests/test_skill.R

Rscript tests/run_smoke_test.R
```

## Output Layout

All successful runs create three subdirectories under `--output_dir`:

| Directory | Contents |
|-----------|----------|
| `data/` | `session_info.txt`, `analysis_data.rda` |
| `table/` | `tsne_coordinates.csv`, `umap_coordinates.csv` when generated |
| `plot/` | `tsne_plot.pdf`, `umap_plot.pdf` when generated |

## Exit Codes

| Code | Meaning |
|------|---------|
| `0` | Success |
| `1` | Error (invalid parameter, file not found, sample mismatch, etc.) |
