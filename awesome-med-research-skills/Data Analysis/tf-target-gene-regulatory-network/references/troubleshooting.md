# Troubleshooting Guide

## Common Errors

### SKILL_FILE_NOT_FOUND

**Error:**
```
SKILL_FILE_NOT_FOUND: Gene file does not exist and no command-line genes provided
```

**Solution:**
- Verify the gene file path is correct
- Check file permissions and ensure file exists
- Use absolute paths instead of relative paths
- Alternatively, provide genes via `--gene` command line parameter

### SKILL_NO_INPUT_GENES

**Error:**
```
SKILL_NO_INPUT_GENES: No valid input genes provided
```

**Solution:**
- Check gene file format (should be one gene per line or comma-separated)
- Ensure gene list is not empty
- Remove any special characters or spaces from gene names
- Verify file encoding is UTF-8

### SKILL_INVALID_SPECIES

**Error:**
```
SKILL_INVALID_SPECIES: Species must be 'human' or 'mouse'
```

**Solution:**
- Use only `human` or `mouse` for species parameter
- Check for typos or extra spaces
- Case-insensitive but must be exact match

### SKILL_EMPTY_RESULTS

**Error:**
```
SKILL_EMPTY_RESULTS: No TF-target relationships found
```

**Solution:**
1. **Check gene symbols**:
   - Use official gene symbols (TP53 not p53)
   - Human genes: uppercase (TP53, MYC, EGFR)
   - Mouse genes: first letter uppercase (Tp53, Myc, Egfr)
   - Verify gene symbols exist in current databases

2. **Check species selection**:
   - Human genes with `--species human`
   - Mouse genes with `--species mouse`
   - Mixed species not supported

3. **Test with known genes**:
   ```bash
   # Human test
   Rscript scripts/main.R -g "TP53,MYC" -s human -o test_output
   
   # Mouse test  
   Rscript scripts/main.R -g "Tp53,Myc" -s mouse -o test_output
   ```

4. **Database coverage**:
   - Dorothea database has limited coverage
   - Try related genes or pathway members
   - Consider alternative analysis if no results

### SKILL_DEPENDENCY_MISSING

**Error:**
```
SKILL_DEPENDENCY_MISSING: dorothea, tidygraph
```

**Solution:**
- Install missing R packages:
  ```r
  # CRAN packages
  install.packages(c("tidyverse", "tidygraph", "ggraph", "openxlsx", "optparse", "showtext"))
  
  # Bioconductor packages
  if (!require("BiocManager", quietly = TRUE))
      install.packages("BiocManager")
  BiocManager::install("dorothea")
  ```
- Restart R session after installation

### SKILL_INVALID_PARAMETER

**Error:**
```
SKILL_INVALID_PARAMETER: Either --gene or --gene_file must be provided
```

**Solution:**
- Provide at least one gene input method:
  ```bash
  # Command line genes
  Rscript scripts/main.R --gene "TP53,MYC,EGFR" --species human
  
  # File input
  Rscript scripts/main.R --gene_file my_genes.txt --species human
  ```

## Network Visualization Issues

### Empty Network Plot

**Cause:** No TF-target relationships found or empty data

**Solution:**
- Check if `table/tf_network.xlsx` exists and has data
- Verify analysis step completed successfully
- Run with test genes to verify visualization works

### Missing Node Labels

**Cause:** Labels turned off or font issues

**Solution:**
- Ensure `--label` is set to `node` (legacy alias `节点` is also accepted)
- Check font installation if using custom `--family`
- Try default Arial font

### Poor Layout Quality

**Cause:** Layout algorithm not suitable for graph structure

**Solution:**
- Try different layout algorithms:
  ```bash
  --style_layout "fr"     # Fruchterman-Reingold
  --style_layout "kk"     # Kamada-Kawai
  --style_layout "sphere" # Spherical
  ```
- Increase figure dimensions for complex networks:
  ```bash
  --width 16 --height 14
  ```

### PDF Generation Failure

**Cause:** Font issues or permission problems

**Solution:**
- Install required fonts or use default Arial
- Check write permissions in output directory
- Ensure enough disk space

## Database Issues

### Local Database Not Found

**Warning:**
```
Local database not found, loading from Dorothea package...
```

**Solution:**
1. Generate local database files:
   ```bash
   Rscript database/database-get.R
   ```
2. Or specify database path explicitly:
   ```bash
   --db_path /path/to/dorothea_hs.rds
   ```
3. Or allow automatic package loading (requires internet)

### Database Version Mismatch

**Cause:** Different Dorothea versions may have different gene coverage

**Solution:**
- Use consistent database versions across analyses
- Regenerate local database files after package updates
- Note Dorothea version in session_info.txt

## Performance Issues

### Slow Analysis with Many Genes

**Cause:** Large gene lists increase database query time

**Solution:**
- Filter to key genes of interest
- Process in batches if analyzing >100 genes
- Use local database files for faster loading

### Memory Issues with Large Networks

**Cause:** Complex networks with many nodes/edges

**Solution:**
- Filter by confidence level (A/B only)
- Reduce node label display
- Use simpler layout algorithms

## Gene Input Format Issues

### File Encoding Problems

**Cause:** Non-UTF-8 encoding in gene files

**Solution:**
- Save files as UTF-8 encoding
- Use plain text (.txt) format
- Avoid special characters

### Incorrect Delimiters

**Cause:** Mixed delimiters in gene files

**Solution:**
- Use consistent delimiters (commas or newlines)
- No spaces around commas: "TP53,MYC,EGFR" not "TP53, MYC, EGFR"
- One gene per line for text files

## Verification Steps

If issues persist, run these verification steps:

1. **Check installation**:
   ```bash
   Rscript scripts/main.R --help
   ```

2. **Test with sample data**:
   ```bash
   # Human test
   Rscript scripts/main.R -g "TP53,MYC,EGFR" -s human -o test_human
   
   # Mouse test
   Rscript scripts/main.R -g "Tp53,Myc,Egfr" -s mouse -o test_mouse
   ```

3. **Verify outputs**:
   ```bash
   ls -la test_human/
   file test_human/plot/TF_Network_Plot.pdf
   ```

4. **Check logs**: Review R console output for specific error messages
