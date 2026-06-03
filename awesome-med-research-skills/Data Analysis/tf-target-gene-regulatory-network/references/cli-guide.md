# CLI Usage Guide

## Basic Syntax

```bash
Rscript scripts/main.R [OPTIONS]
```

Canonical examples below use English visualization values such as `fr`, `curve`, and `diamond`. Legacy localized aliases such as `发散(fr)`, `曲线`, and `菱形` remain accepted for backward compatibility.

## Required Arguments

At least one gene input method is required:

| Argument | Description |
|----------|-------------|
| `-g GENES` | Comma-separated gene list (e.g., "TP53,MYC,EGFR") |
| `-f FILE` | File containing gene names (txt or csv) |

## Optional Arguments

### Core Parameters
| Argument | Default | Description |
|----------|---------|-------------|
| `-s SPECIES` | human | Species: `human` or `mouse` |
| `-o DIR` | TF_Result | Output directory |
| `--db_path FILE` | NULL | Local database file path (.rds format) |
| `--seed VALUE` | 42 | Random seed for reproducibility |

### Visualization Parameters
| Argument | Default | Description |
|----------|---------|-------------|
| `-w VALUE` | 12 | Figure width in inches |
| `-e VALUE` | 10 | Figure height in inches |
| `--family NAME` | Arial | Font family for text |
| `--label TYPE` | node | Label mapping type: 'node' for node labels, 'none' for no labels |
| `--label_size SIZE` | 20pt | Label font size |
| `--legend_position POS` | bottom | Legend position: 'bottom' or 'right' |
| `--line_color COLOR` | #7E8B8E | Line color (hex code) |
| `--line_type TYPE` | solid | Line type: 'solid' or 'dashed' |
| `--point_color COLOR` | #2E889D | Node border color (hex code) |
| `--point_fill COLOR` | #2E879A | Node fill color (hex code) |
| `--point_shape SHAPES` | circle,square,diamond,triangle,triangle_down | Node shapes: comma-separated list |
| `--style_layout LAYOUT` | sphere | Layout style: 'sphere', 'kk', 'fr', 'nicely', 'circle', 'star', 'grid', 'randomly' |
| `--style_line TYPE` | straight | Line shape style: 'straight' or 'curve' |
| `--theme_size SIZE` | 30pt | Base theme font size |
| `--title TEXT` | empty | Chart title |
| `--title_x TEXT` | empty | X-axis title |

### Advanced Parameters
| Argument | Description |
|----------|-------------|
| `-d DIR` | Working root directory (advanced) |
| `--mapping_link_alpha` | Edge alpha mapping: 'Value' or 'none' (no mapping) |
| `--mapping_link_color` | Edge color mapping: 'Value' or 'none' (no mapping) |
| `--mapping_link_size` | Edge width mapping: 'Value' or 'none' (no mapping) |
| `--mapping_link_type` | Edge type mapping: 'Value' or 'none' (no mapping) |
| `--mapping_node_color` | Node color mapping: 'type' or 'none' (no mapping) |
| `--mapping_node_type` | Node shape mapping: 'type' or 'none' (no mapping) |

## Complete Examples

### Example 1: Basic Human Gene Analysis

```bash
# Analyze three human genes
Rscript scripts/main.R \
  --gene "TP53,MYC,EGFR" \
  --species human \
  --output_dir ./TF_Result
```

### Example 2: File Input with Mouse Genes

```bash
# Analyze genes from a file (mouse species)
Rscript scripts/main.R \
  --gene_file mouse_genes.txt \
  --species mouse \
  --output_dir ./Mouse_Results
```

### Example 3: Custom Styling

```bash
# Customize network visualization
Rscript scripts/main.R \
  --gene "PTPRC,FOXP3,CD4" \
  --species human \
  --style_layout "fr" \
  --style_line "curve" \
  --point_shape "diamond,triangle" \
  --line_color "#E64B35" \
  --title "Immune TF Network" \
  --width 14 \
  --height 12 \
  --output_dir ./Custom_Plot
```

### Example 4: Using Local Database

```bash
# Use pre-saved local database for faster analysis
Rscript scripts/main.R \
  --gene "TP53,MYC,EGFR" \
  --species human \
  --db_path database/dorothea_hs.rds \
  --output_dir ./LocalDB_Result
```

### Example 5: Minimal Parameters

```bash
# Minimal command (uses defaults for visualization)
Rscript scripts/main.R \
  -g "BRCA1,BRCA2,TP53" \
  -s human
```

### Example 6: Advanced Customization

```bash
# Full customization example
Rscript scripts/main.R \
  -g "CNGA3,ACOT2,NCK2,APOC1" \
  -s human \
  -w 14 \
  -e 12 \
  --family "Arial" \
  --label "node" \
  --label_size "16pt" \
  --legend_position "right" \
  --line_color "#7F8C8D" \
  --line_type "dashed" \
  --point_color "#2E3440" \
  --point_fill "#5E81AC" \
  --point_shape "circle,square" \
  --style_layout "nicely" \
  --theme_size "24pt" \
  --title "Transcription Factor Network Analysis" \
  --seed 123 \
  -o ./Full_Example
```

## File Input Formats

### Gene File Format

**Text file (recommended):**
```
TP53
MYC
EGFR
BRCA1
```

**CSV file:**
```
TP53,MYC,EGFR,BRCA1
```

**Mixed delimiters (also accepted):**
```
TP53, MYC, EGFR
BRCA1
CDK4
```

### Local Database Files

Generate local database files:
```bash
Rscript database/database-get.R
```

This creates:
- `database/dorothea_hs.rds` (human)
- `database/dorothea_mm.rds` (mouse)

## Getting Help

```bash
# Display help message with all options
Rscript scripts/main.R --help
```

## Exit Codes

| Code | Meaning | Typical Cause |
|------|---------|---------------|
| 0 | Success | Analysis completed successfully |
| 1 | Error | Invalid parameters, missing files, dependency issues |
| 2 | Empty Results | No TF-target relationships found |

## Common Parameter Combinations

### For Quick Testing
```bash
Rscript scripts/main.R -g "TP53" -s human -o test_output
```

### For Publication Figures
```bash
Rscript scripts/main.R \
  -g "GENE1,GENE2,GENE3" \
  -s human \
  -w 10 \
  -e 8 \
  --family "Helvetica" \
  --title "TF Regulatory Network" \
  --style_layout "kk" \
  -o publication_figure
```

### For Batch Processing
```bash
# Process multiple gene lists
for gene_file in gene_lists/*.txt; do
  output_dir="results/$(basename $gene_file .txt)"
  Rscript scripts/main.R \
    -f "$gene_file" \
    -s human \
    -o "$output_dir" \
    --seed 42
done
```

## Tips and Best Practices

1. **Start simple**: Test with 1-3 genes before large lists
2. **Check gene symbols**: Use official symbols, check case sensitivity
3. **Use local databases**: For faster repeated analyses
4. **Set random seed**: For reproducible network layouts
5. **Review outputs**: Check `session_info.txt` for package versions
