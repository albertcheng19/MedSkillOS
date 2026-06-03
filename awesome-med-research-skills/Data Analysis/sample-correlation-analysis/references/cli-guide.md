# CLI Usage Guide

## Basic Syntax

```bash
Rscript scripts/main.R [OPTIONS]
```

## Core Arguments

| Argument | Description |
|----------|-------------|
| `-d FILE` or `--data_file FILE` | Input data file (CSV, TXT, TSV format). Required |
| `-x VAR` or `--x_var VAR` | First variable name for correlation |
| `-y VAR` or `--y_var VAR` | Second variable name for correlation |

## Optional Arguments

| Argument | Default | Description |
|----------|---------|-------------|
| `-o DIR` | ./Correlation_Results/ | Output directory |
| `-m METHOD` | pearson | Correlation method: pearson, spearman |
| `-a HYP` | two.sided | Alternative hypothesis: two.sided, less, greater |
| `-c LEVEL` | 0.95 | Confidence level (0-1) |
| `-f FORMAT` | csv | Output format: csv, txt |
| `-p PREFIX` | correlation | Output file prefix |

## Complete Examples

### Example 1: Basic Pearson Correlation

```bash
# Analyze linear relationship between height and weight
Rscript scripts/main.R \
  --data_file data/measurements.csv \
  --method pearson \
  --x_var height \
  --y_var weight \
  --output_dir ./pearson_results
```

### Example 2: Spearman Correlation with Custom Parameters

```bash
# Analyze monotonic relationship with one-sided test
Rscript scripts/main.R \
  --data_file data/study.csv \
  --method spearman \
  --x_var age \
  --y_var score \
  --alternative greater \
  --conf_level 0.99 \
  --output_dir ./spearman_results
```

### Example 3: Custom Output Format

```bash
# Save results in TXT format with custom prefix
Rscript scripts/main.R \
  --data_file data/experiment.csv \
  --method pearson \
  --x_var temperature \
  --y_var growth_rate \
  --output_format txt \
  --output_prefix my_correlation \
  --output_dir ./custom_results
```

### Example 4: Testing for Negative Correlation

```bash
# Test if study hours are negatively correlated with error rate
Rscript scripts/main.R \
  --data_file data/students.csv \
  --method pearson \
  --x_var study_hours \
  --y_var error_rate \
  --alternative less \
  --output_dir ./negative_test
```

### Example 5: Using Different Variable Names

```bash
# Analyze correlation with non-default variable names
Rscript scripts/main.R \
  --data_file data/sales.csv \
  --method spearman \
  --x_var advertising_budget \
  --y_var monthly_sales \
  --output_dir ./sales_analysis
```

### Example 6: Minimal Command

```bash
# Use default method and variable names, but still provide data_file
Rscript scripts/main.R \
  --data_file tests/data/sample_correlation_1.csv \
  --x_var variable1 \
  --y_var variable2
```

## Test Dataset Examples

### Example 7: Small Column-Based Sample Data

```bash
# Basic Pearson correlation using the smallest bundled test dataset
Rscript scripts/main.R \
  --data_file tests/data/sample_correlation_1.csv \
  --method pearson \
  --x_var variable1 \
  --y_var variable2 \
  --output_dir tests/output_sample1
```

### Example 8: Large Column-Based Sample Data

```bash
# Correlate two drug response columns from the larger bundled dataset
Rscript scripts/main.R \
  --data_file tests/data/sample_correlation_2.csv \
  --method pearson \
  --x_var Camptothecin_1003 \
  --y_var Vinblastine_1004 \
  --output_dir tests/output_sample2
```

### Example 9: Row-Labeled Sample Data

```bash
# The script automatically detects variables stored as first-column row labels
Rscript scripts/main.R \
  --data_file tests/data/sample_correlation_3.csv \
  --method pearson \
  --x_var "Activated CD8 T cell" \
  --y_var "Central memory CD8 T cell" \
  --output_dir tests/output_sample3
```

### Example 10: Row-Labeled Sample Data with Spearman Correlation

```bash
Rscript scripts/main.R \
  --data_file tests/data/sample_correlation_3.csv \
  --method spearman \
  --x_var "Activated CD8 T cell" \
  --y_var "Central memory CD8 T cell" \
  --output_dir tests/output_sample3_spearman
```

## Getting Help

```bash
# Display help message with all options
Rscript scripts/main.R --help
```

## Exit Codes

| Code | Meaning |
|------|---------|
| 0 | Success |
| 1 | Error (file not found, invalid parameter, analysis error, etc.) |

## Parameter Combinations

### Valid Method Options
- `--method pearson`: Pearson product-moment correlation
- `--method spearman`: Spearman rank correlation

### Valid Alternative Hypothesis Options
- `--alternative two.sided`: Test if correlation differs from zero (default)
- `--alternative less`: Test if correlation is less than zero
- `--alternative greater`: Test if correlation is greater than zero

### Valid Output Format Options
- `--output_format csv`: Comma-separated values format
- `--output_format txt`: Tab-separated text format

### Confidence Level Range
- Must be between 0 and 1 (exclusive)
- Typical values: 0.90, 0.95 (default), 0.99
- Example: `--conf_level 0.95` for 95% confidence interval

## File Format Support

### Supported Input Formats
- **CSV** (.csv): Comma-separated values
- **TXT** (.txt): Tab-separated or space-separated values
- **TSV** (.tsv): Tab-separated values

### Input File Requirements
- First row should contain column headers
- Variables specified with --x_var and --y_var must exist either as column names or as labels in the first column
- Data should be numeric for correlation analysis
- Missing values allowed (incomplete pairs are excluded)

### Output File Structure
```
Correlation_Results/
├── table/                   # Statistical results
│   ├── correlation_pearson.csv
│   └── correlation_spearman.csv
├── figure/                  # Reserved for visualizations
└── data/                    # Reserved for raw data backup
```

## Common Usage Patterns

### 1. Quick Analysis
```bash
Rscript scripts/main.R -d data.csv -x var1 -y var2
```

### 2. Detailed Analysis with Logging
```bash
Rscript scripts/main.R \
  -d data.csv \
  -m spearman \
  -x independent_var \
  -y dependent_var \
  -a two.sided \
  -c 0.95 \
  -f csv \
  -p analysis1 \
  -o ./results 2>&1 | tee analysis.log
```

### 3. Batch Processing (Shell Script)
```bash
#!/bin/bash
for method in pearson spearman; do
  Rscript scripts/main.R \
    --data_file data.csv \
    --method $method \
    --x_var var1 \
    --y_var var2 \
    --output_dir "./results_$method"
done
```

## Tips and Best Practices

1. **Check Data First**: Always examine your data before analysis
   ```bash
   head -n 5 data.csv
   ```

2. **Verify Column Names**: Ensure variable names match exactly
   ```bash
   head -n 1 data.csv
   ```

3. **Test with Sample**: Run with test data first
   ```bash
   Rscript scripts/main.R --data_file tests/data/sample_correlation_1.csv --x_var variable1 --y_var variable2
   ```

4. **Save Session Info**: Output directory includes session_info.txt with R version and package information

5. **Check Output**: Verify results file was created
   ```bash
   ls -la Correlation_Results/table/
   cat Correlation_Results/table/correlation_pearson.csv
   ```
