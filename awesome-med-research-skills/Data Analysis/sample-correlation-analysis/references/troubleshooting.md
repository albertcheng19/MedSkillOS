# Troubleshooting Guide

## Common Errors

### SKILL_FILE_NOT_FOUND

**Error:**
```
SKILL_FILE_NOT_FOUND: Data file not found: path/to/file.csv
```

**Solution:**
- Verify the file path is correct
- Check file permissions
- Ensure the file exists before running
- Use absolute paths for clarity

### SKILL_MISSING_COLUMNS

**Error:**
```
SKILL_MISSING_COLUMNS: X variable 'height' not found in data
SKILL_MISSING_COLUMNS: Y variable 'weight' not found in data
```

**Solution:**
- Check variable names in your data file
- Ensure names match exactly (case-sensitive)
- Use `colnames(data)` for column-oriented data or inspect the first column for row-labeled data
- Verify data file format and header row

### SKILL_INVALID_DATA

**Error:**
```
SKILL_INVALID_DATA: X variable 'age' must be numeric
SKILL_INVALID_DATA: Y variable 'score' must be numeric
SKILL_INSUFFICIENT_DATA: Insufficient complete observations for correlation analysis. Need at least 3 pairs, found: 2
```

**Solution:**
- Ensure variables contain numeric values only
- Check for missing values or non-numeric entries
- Ensure at least 3 complete observation pairs after removing missing values
- Verify data types in your dataset

### SKILL_INVALID_PARAMETER

**Error:**
```
SKILL_INVALID_PARAMETER: method must be one of: 'pearson', 'spearman'
SKILL_INVALID_PARAMETER: alternative must be one of: 'two.sided', 'less', 'greater'
SKILL_INVALID_PARAMETER: conf_level must be between 0 and 1 (exclusive)
SKILL_INVALID_PARAMETER: output_format must be one of: 'csv', 'txt'
```

**Solution:**
- Use valid parameter values as specified in help message
- Check spelling and case sensitivity
- For conf_level, use values between 0 and 1 (e.g., 0.95 for 95% CI)
- Run with `--help` to see all valid options

### SKILL_DEPENDENCY_MISSING

**Error:**
```
SKILL_DEPENDENCY_MISSING: data.table
```

**Solution:**
- Install required R packages:
  ```r
  install.packages(c("data.table", "tools"))
  ```
- Ensure R is properly installed and accessible
- Check R package library paths

### SKILL_ANALYSIS_ERROR

**Error:**
```
SKILL_ANALYSIS_ERROR: Analysis error: [specific R error message]
```

**Solution:**
- Check the specific R error message for details
- Verify data quality and assumptions
- Ensure sufficient sample size
- Check for extreme outliers or data issues

## Method-Specific Issues

### Pearson Correlation Issues

**Problem:** Correlation is NaN or undefined

**Solution:**
- Check if variables have zero variance (all values identical)
- Ensure variables have variation
- Remove constant variables from analysis

**Problem:** Extreme outliers affecting correlation

**Solution:**
- Check data distribution and identify outliers
- Consider using Spearman correlation which is more robust to outliers
- Remove or winsorize extreme outliers if appropriate

**Problem:** Non-linear relationship showing weak correlation

**Solution:**
- Check scatter plot for non-linear pattern
- Consider using Spearman correlation for monotonic relationships
- Transform variables if relationship has specific functional form

### Spearman Correlation Issues

**Problem:** Many tied ranks reducing correlation sensitivity

**Solution:**
- Spearman handles ties appropriately but may have reduced power
- Consider if data are truly ordinal or if measurement precision can be increased
- Large number of ties may indicate need for different analysis approach

**Problem:** Exact p-value calculation for small samples

**Solution:**
- This script uses the asymptotic Spearman test (`exact = FALSE`) for all sample sizes
- For very small samples, interpret p-values cautiously and consider an exact procedure outside this CLI if required
- Ensure sample size is adequate for your research question

## Data Format Issues

### CSV/TXT/TSV Format Problems

**Problem:** File not recognized as valid format

**Solution:**
- Ensure file has proper extension (.csv, .txt, .tsv)
- Check delimiter consistency
- Verify header row exists and is properly formatted
- Remove special characters or quotes if causing issues

**Problem:** Encoding issues with non-ASCII characters

**Solution:**
- Save file with UTF-8 encoding
- Remove special characters from variable names if your shell or editor mishandles them
- Use simple ASCII characters for variable names

### Data Quality Issues

**Problem:** Missing data reducing sample size

**Solution:**
- Correlation analysis uses pairwise deletion (removes rows with missing values in either variable)
- Consider imputation if missing data pattern is random
- Report actual sample size used in analysis

**Problem:** Non-normal distribution for Pearson correlation

**Solution:**
- Pearson correlation assumes approximate normality
- Check normality with Shapiro-Wilk test or visual inspection
- Consider using Spearman correlation if data are not normal
- Data transformation (log, sqrt) may help

## Output Issues

### No Output Files Generated

**Cause:** Analysis terminated due to error

**Solution:**
- Check error messages in console output
- Verify all required parameters are provided
- Ensure output directory is writable

### Empty or Incomplete Results

**Cause:** Filtering or subsetting issues

**Solution:**
- Check if data meets analysis requirements
- Verify variable names and data types
- Ensure variables have valid numeric values
- Check sample size after removing missing values

### File Permission Errors

**Cause:** Cannot write to output directory

**Solution:**
- Check write permissions for output directory
- Use different output directory location
- Run with appropriate user permissions

## Interpretation Issues

### Weak Correlation Despite Visual Relationship

**Cause:** Non-linear relationship, outliers, or restricted range

**Solution:**
- Examine scatter plot for pattern
- Check for outliers that may be masking relationship
- Consider if relationship is monotonic but non-linear (use Spearman)
- Check if variable range is restricted

### Significant but Small Correlation

**Cause:** Large sample size can make small correlations statistically significant

**Solution:**
- Consider effect size (correlation coefficient) in addition to p-value
- Small correlations (e.g., |r| < 0.3) may be statistically significant but not practically important
- Report both statistical significance and effect size

### Correlation Direction Opposite of Expected

**Cause:** Data entry errors, variable coding, or confounding factors

**Solution:**
- Verify data accuracy
- Check variable coding (e.g., higher scores meaning better or worse outcome)
- Consider potential confounding variables
- Examine scatter plot for unusual patterns

## Performance Issues

### Large Data File Processing

**Problem:** Script runs slowly with large datasets

**Solution:**
- Ensure `data.table` package is installed for efficient data handling
- Consider subsetting data if only specific variables are needed
- Check available memory and system resources

### Memory Issues

**Problem:** Out of memory errors with very large datasets

**Solution:**
- Process data in chunks if possible
- Increase system memory or use more efficient data structures
- Consider sampling or subsetting if full dataset not required

## General Troubleshooting Steps

1. **Check Basic Requirements**
   - R installed and accessible
   - Required packages installed
   - File paths correct and accessible

2. **Validate Input Data**
    - Open data file in text editor or spreadsheet software
    - Verify variable names and data types
    - Check for missing values or formatting issues

3. **Test with Simple Example**
   - Create minimal test dataset
   - Run with basic parameters
   - Gradually add complexity

4. **Check Console Output**
   - Read all error messages carefully
   - Look for warnings or informational messages
   - Note line numbers where errors occur

5. **Verify Parameter Combinations**
   - Ensure required parameters are provided
   - Check parameter values are within valid ranges
   - Confirm parameter spelling and case

6. **Examine Intermediate Results**
   - Check sample size reported in output
   - Verify variables have variation
   - Look for warning messages about data quality

## Testing the Installation

To verify the skill is working correctly:

```bash
# Test with provided sample data
Rscript scripts/main.R \
  --data_file tests/data/sample_correlation_1.csv \
  --x_var variable1 \
  --y_var variable2 \
  --output_dir ./test_output

# Check if output was created
ls -la test_output/table/

# View results
cat test_output/table/correlation_pearson.csv
```

If problems persist, try running with `--help` to review all available options and requirements.
