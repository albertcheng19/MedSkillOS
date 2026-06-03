# Method Library
# generic-phenotype-scoring-research-planner

---

## Core Bioinformatics Tooling

### Primary Analysis Environments
| Tool | Language | Use Case |
|---|---|---|
| limma | R | DEG analysis for bulk expression data |
| GSVA | R | z-score or pathway / phenotype score calculation |
| e1071 / caret / equivalent | R | feature selection and classifier workflows |
| clusterProfiler | R | GO / KEGG enrichment |
| STRING | web/database | PPI network construction |
| Cytoscape | mixed | network visualization |
| ggplot2 / pheatmap | R | core figures |

### Immune and Cellular-Resolution Tools
| Tool / Resource | Use Case |
|---|---|
| GSVA / ssGSEA | immune infiltration estimation |
| Seurat | scRNA-seq preprocessing and clustering |
| NetworkAnalyst | TF-gene and miRNA regulatory networks |
| Random Forest or equivalent | diagnostic / stratification classification assessment |

### Experimental Follow-Up
| Tool / Method | Use Case |
|---|---|
| qRT-PCR | orthogonal expression validation |
| independent cohort validation | bulk-level replication |
| limited cell-type confirmation | optional cell-level support if available |

---

## Data Resources

### Common Public Resources
| Resource | Coverage |
|---|---|
| GEO | bulk expression datasets |
| MSigDB | pathway / process / signature gene sets |
| public scRNA repositories | single-cell validation |
| STRING | protein interaction |
| NetworkAnalyst | TF / miRNA regulation context |

### Dataset Planning Requirement

| Item | What to Declare |
|---|---|
| Discovery bulk datasets | source, group sizes, platform |
| Validation bulk datasets | source, group sizes, platform |
| scRNA resource | source, tissue/cell context |
| Signature gene sets | source and exact set names |
| Validation tools | ML / PPI / network / immune resources used |

> **Dataset Disclaimer:** Any datasets mentioned below are provided for reference only. Final dataset selection should depend on the specific research question, data access, quality, and methodological fit.

---

## Parameter Defaults and Decision Rules

| Parameter | Default | Notes |
|---|---|---|
| DEG threshold | p < 0.05 with declared fold-change rule | harmonize across datasets where possible |
| Feature-selection rule | SVM-RFE or equivalent with declared feature count | avoid arbitrary cutoff |
| Phenotype score | z-score / GSVA-based declared formula | keep method explicit |
| Classifier validation | cross-validation required when ML is used | avoid inflated diagnostic claims |
| Immune analysis | ssGSEA or related method | interpretation only |
| scRNA analysis | cell filtering + clustering + per-cell score | declare QC and annotation logic |
| Experimental validation | limited orthogonal support only unless richer assays exist | keep conservative |
