# Method Library
# process-related-diagnostic-biomarker-nomogram-research-planner

---

## Core Bioinformatics Tooling

### Primary Analysis Environments
| Tool | Language | Use Case |
|---|---|---|
| limma | R | DEG analysis for bulk expression data |
| WGCNA | R | co-expression module screening |
| clusterProfiler | R | GO / KEGG enrichment and GSEA |
| glmnet | R | LASSO feature selection |
| randomForest / caret / equivalent | R | feature importance and RFE-style screening |
| rms | R | nomogram construction and calibration |
| rmda | R | decision-curve analysis |
| pROC | R | ROC and AUC validation |
| ggplot2 / pheatmap | R | core figures |

### Immune and Regulatory Tools
| Tool / Resource | Use Case |
|---|---|
| GSVA / ssGSEA | immune infiltration estimation |
| NetworkAnalyst / Enrichr | TF and regulatory interaction prediction |
| MiRTarBase | experimentally supported miRNA-target retrieval |
| Cytoscape | network visualization |
| STRING | interaction context and PPI |

### Experimental Follow-Up
| Tool / Method | Use Case |
|---|---|
| animal model | orthogonal biological support |
| qRT-PCR | orthogonal expression validation |
| western blot | protein-level support |
| independent cohort validation | bulk-level replication |

---

## Data Resources

### Common Public Resources
| Resource | Coverage |
|---|---|
| GEO | bulk expression datasets |
| GeneCards / Harmonizome / MSigDB | process-gene-family resources |
| STRING | PPI network |
| MiRTarBase | miRNA-target evidence |
| Enrichr / NetworkAnalyst | TF and regulatory context |

### Dataset Planning Requirement

| Item | What to Declare |
|---|---|
| Discovery bulk datasets | source, group sizes, platform |
| Validation bulk datasets | source, group sizes, platform |
| Process gene-family resources | source and exact retrieval rule |
| Module resources | WGCNA or equivalent integration plan |
| Experimental resources | animal model / qRT-PCR / western blot if used |

> **Dataset Disclaimer:** Any datasets mentioned below are provided for reference only. Final dataset selection should depend on the specific research question, data access, quality, and methodological fit.

---

## Parameter Defaults and Decision Rules

| Parameter | Default | Notes |
|---|---|---|
| DEG threshold | p < 0.05 with declared fold-change rule | harmonize across datasets where possible |
| WGCNA soft threshold | scale-free target declared explicitly | do not hide parameter selection |
| Feature-selection rule | at least two selection approaches if ML is central | reduce method-specific noise |
| ROC interpretation | biomarker support only | avoid clinical deployment claims |
| Nomogram use | only after upstream biomarker selection is fixed | prevent decorative modeling |
| Immune analysis | group comparison + gene-immune correlation | interpretation only |
| Regulatory analysis | context support, not mechanistic proof | keep conservative |
| Experimental validation | limited orthogonal support only unless richer assays exist | keep conservative |
