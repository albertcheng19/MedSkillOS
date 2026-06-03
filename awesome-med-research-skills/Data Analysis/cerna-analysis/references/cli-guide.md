# CLI Usage Guide

## Basic Syntax

```bash
Rscript scripts/main.R [OPTIONS]
```

## Required Arguments

| Argument | Description |
|----------|-------------|
| `-i FILE` | Key gene file path, or a comma-separated gene list |

## Optional Arguments

| Argument | Default | Description |
|----------|---------|-------------|
| `-o DIR` | `./output/` | Output directory |
| `-m DATASET` | `combined` | miRNA-mRNA dataset: `combined`, `starbase`, `mirdb`, `mirtarbase`, `starbase+mirdb`, `starbase+mirtarbase`, `mirdb+mirtarbase` |
| `-l LEVEL` | `High` | lncRNA interaction strictness: `Low`, `Median`, `High` |
| `-f INT` | `0` | Minimum retained lncRNA frequency |
| `-r DIR` | `references/database` | Reference dataset directory |
| `--plot_width NUM` | `12` | PDF width in inches |
| `--plot_height NUM` | `8` | PDF height in inches |
| `--layout_type NAME` | `kk` | Network layout: `kk`, `fr`, `nicely`, `circle`, `grid`, `randomly` |
| `--mrna_color COLOR` | `#D16BA5` | mRNA node color |
| `--lncrna_color COLOR` | `#008dcd` | lncRNA node color |
| `--mirna_color COLOR` | `#00c9a7` | miRNA node color |
| `--node_size_base NUM` | `15` | Base node size |
| `--label_size NUM` | `0.8` | Node label size |
| `--show_legend BOOL` | `TRUE` | Show legend in PDF output |
| `-t INT` | `3600` | Timeout in seconds |
| `-s INT` | `42` | Random seed |

## Complete Examples

### Example 1: Basic Combined Analysis

```bash
Rscript scripts/main.R \
  -i gene.txt \
  -o ./result \
  -m combined \
  -l High \
  -f 0 \
  -t 600 \
  -s 42
```

### Actual Input Parameters

| Parameter | Value |
|----------|-------|
| `key_genes` | `gene.txt` |
| `output_dir` | `./result` |
| `mirna_dataset` | `combined` |
| `lncrna_strictness` | `High` |
| `lncrna_freq_thresh` | `0` |
| `reference_dir` | `references/database` |
| `plot_width` | `12` |
| `plot_height` | `8` |
| `layout_type` | `kk` |
| `mrna_color` | `#D16BA5` |
| `lncrna_color` | `#008dcd` |
| `mirna_color` | `#00c9a7` |
| `node_size_base` | `15` |
| `label_size` | `0.8` |
| `show_legend` | `TRUE` |
| `timeout_seconds` | `600` |
| `seed` | `42` |

### Output Files

| File | Observed Size / Lines | Content |
|------|------------------------|---------|
| `ceRNA_network_edges.csv` | `654 bytes`, `28` lines | Edge table with `node1,node2` columns |
| `ceRNA_network_nodes.csv` | `583 bytes`, `26` lines | Node table with `node,type,degree` columns |
| `ceRNA_network.pdf` | `6049 bytes` | PDF network visualization |
| `session_info.txt` | `1184 bytes` | R session and package-version snapshot |

### Output Content Preview

`ceRNA_network_edges.csv`

```text
"node1","node2"
"miR-150-5p","TP53"
"miR-212-3p","BRCA1"
"miR-330-3p","TP53"
"miR-491-5p","TP53"
"miR-504-5p","TP53"
"miR-212-3p","HNRNPU-AS1"
"miR-212-3p","SNHG16"
```

`ceRNA_network_nodes.csv`

```text
"node","type","degree"
"miR-150-5p","miRNA",6
"miR-212-3p","miRNA",7
"miR-330-3p","miRNA",1
"miR-491-5p","miRNA",7
"miR-504-5p","miRNA",6
"TP53","mRNA",4
"BRCA1","mRNA",1
```

### Runtime And Resource Usage

| Metric | Value |
|--------|-------|
| Start time | `2026-04-17 14:55:22` |
| End time | `2026-04-17 14:55:23` |
| Elapsed time | `0.886 s` |
| User CPU time | `0.791 s` |
| System CPU time | `0.600 s` |
| Peak RSS | `81416 KB` |
| Timeout setting | `600` |
| Exit status | `0` |

### Example 2: starBase with Median lncRNA Strictness

```bash
Rscript scripts/main.R \
  -i gene.txt \
  -o ./result_starbase \
  -m starbase \
  -l Median \
  -f 1 \
  -t 600 \
  -s 42
```

### Actual Input Parameters

| Parameter | Value |
|----------|-------|
| `key_genes` | `gene.txt` |
| `output_dir` | `./result_starbase` |
| `mirna_dataset` | `starbase` |
| `lncrna_strictness` | `Median` |
| `lncrna_freq_thresh` | `1` |
| `reference_dir` | `references/database` |
| `plot_width` | `12` |
| `plot_height` | `8` |
| `layout_type` | `kk` |
| `mrna_color` | `#D16BA5` |
| `lncrna_color` | `#008dcd` |
| `mirna_color` | `#00c9a7` |
| `node_size_base` | `15` |
| `label_size` | `0.8` |
| `show_legend` | `TRUE` |
| `timeout_seconds` | `600` |
| `seed` | `42` |

### Output Files

| File | Observed Size / Lines | Content |
|------|------------------------|---------|
| `ceRNA_network_edges.csv` | `40769 bytes`, `1647` lines | Expanded edge table from the `starbase` miRNA-mRNA dataset |
| `ceRNA_network_nodes.csv` | `11137 bytes`, `458` lines | Larger node table with inferred degree values |
| `ceRNA_network.pdf` | `30217 bytes` | PDF network visualization |
| `session_info.txt` | `1184 bytes` | R session and package-version snapshot |

### Output Content Preview

`ceRNA_network_edges.csv`

```text
"node1","node2"
"miR-200a-3p","BRCA1"
"miR-34a-5p","MYC"
"miR-186-5p","MYC"
"miR-186-5p","TP53"
"miR-186-5p","BRCA1"
"miR-320b","BRCA1"
"miR-135b-5p","MYC"
```

`ceRNA_network_nodes.csv`

```text
"node","type","degree"
"miR-200a-3p","miRNA",15
"miR-34a-5p","miRNA",23
"miR-186-5p","miRNA",28
"miR-320b","miRNA",26
"miR-135b-5p","miRNA",17
"miR-205-5p","miRNA",17
"miR-146b-5p","miRNA",12
```

### Runtime And Resource Usage

| Metric | Value |
|--------|-------|
| Start time | `2026-04-17 14:55:22` |
| End time | `2026-04-17 14:55:25` |
| Elapsed time | `2.987 s` |
| User CPU time | `2.460 s` |
| System CPU time | `0.655 s` |
| Peak RSS | `224936 KB` |
| Timeout setting | `600` |
| Exit status | `0` |

### Example 3: Inline Key Genes

```bash
Rscript scripts/main.R \
  -i TP53,BRCA1,MYC \
  -o ./result_inline \
  -m combined \
  -l High \
  -f 0 \
  -t 600 \
  -s 42
```

### Actual Input Parameters

| Parameter | Value |
|----------|-------|
| `key_genes` | `TP53,BRCA1,MYC` |
| `output_dir` | `./result_inline` |
| `mirna_dataset` | `combined` |
| `lncrna_strictness` | `High` |
| `lncrna_freq_thresh` | `0` |
| `reference_dir` | `references/database` |
| `plot_width` | `12` |
| `plot_height` | `8` |
| `layout_type` | `kk` |
| `mrna_color` | `#D16BA5` |
| `lncrna_color` | `#008dcd` |
| `mirna_color` | `#00c9a7` |
| `node_size_base` | `15` |
| `label_size` | `0.8` |
| `show_legend` | `TRUE` |
| `timeout_seconds` | `600` |
| `seed` | `42` |

### Output Files

| File | Observed Size / Lines | Content |
|------|------------------------|---------|
| `ceRNA_network_edges.csv` | `654 bytes`, `28` lines | Edge table identical to the file-based combined run |
| `ceRNA_network_nodes.csv` | `583 bytes`, `26` lines | Node table identical to the file-based combined run |
| `ceRNA_network.pdf` | `6049 bytes` | PDF network visualization |
| `session_info.txt` | `1184 bytes` | R session and package-version snapshot |

### Output Content Preview

`ceRNA_network_edges.csv`

```text
"node1","node2"
"miR-150-5p","TP53"
"miR-212-3p","BRCA1"
"miR-330-3p","TP53"
"miR-491-5p","TP53"
"miR-504-5p","TP53"
"miR-212-3p","HNRNPU-AS1"
"miR-212-3p","SNHG16"
```

`ceRNA_network_nodes.csv`

```text
"node","type","degree"
"miR-150-5p","miRNA",6
"miR-212-3p","miRNA",7
"miR-330-3p","miRNA",1
"miR-491-5p","miRNA",7
"miR-504-5p","miRNA",6
"TP53","mRNA",4
"BRCA1","mRNA",1
```

### Runtime And Resource Usage

| Metric | Value |
|--------|-------|
| Start time | `2026-04-17 14:55:22` |
| End time | `2026-04-17 14:55:23` |
| Elapsed time | `0.822 s` |
| User CPU time | `0.736 s` |
| System CPU time | `0.486 s` |
| Peak RSS | `82232 KB` |
| Timeout setting | `600` |
| Exit status | `0` |

## Getting Help

```bash
Rscript scripts/main.R --help
```

## Exit Codes

| Code | Meaning |
|------|---------|
| `0` | Success |
| `1` | Error (`SKILL_FILE_NOT_FOUND`, `SKILL_INVALID_PARAMETER`, `SKILL_INVALID_DATA`, `SKILL_TIMEOUT`, or other runtime failure) |
