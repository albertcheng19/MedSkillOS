# Method Library
# conventional-non-oncology-hub-gene-research-planner

---

## Core Bioinformatics Tooling

### Primary Analysis Environments
| Tool | Language | Use Case |
|---|---|---|
| limma | R | DEG analysis for bulk expression data |
| sva | R | ComBat-based batch correction |
| clusterProfiler | R | GO / KEGG enrichment and GSEA |
| STRING | web/database | PPI network construction |
| Cytoscape / CytoHubba | mixed | network visualization and hub-gene prioritization |
| ggplot2 / pheatmap | R | core figures and QC plots |
| pROC | R | ROC and AUC support |

### Regulatory and Immune Tools
| Tool / Resource | Use Case |
|---|---|
| ChIPBase / JASPAR / NetworkAnalyst | TF-gene regulatory analysis |
| StarBase / equivalent | miRNA-target support |
| GSVA / ssGSEA | immune infiltration estimation |
| cor.test / Spearman framework | immune-cell and gene correlation |

---

## Data Resources

### Common Public Resources
| Resource | Coverage |
|---|---|
| GEO | bulk expression datasets |
| GeneCards / PubMed / MSigDB | process-gene-family sources |
| STRING | PPI network |
| ChIPBase / JASPAR / NetworkAnalyst | TF regulation context |
| StarBase | miRNA regulation context |

### Dataset Planning Requirement

| Item | What to Declare |
|---|---|
| Discovery bulk datasets | source, group sizes, platform |
| Merge / batch-correction plan | whether ComBat or equivalent is used |
| Process gene-family resources | source and exact retrieval rule |
| Validation resources | ROC support or orthogonal expression check |
| Immune / regulatory resources | ssGSEA / TF / miRNA tools used |

> **Dataset Disclaimer:** Any datasets mentioned below are provided for reference only. Final dataset selection should depend on the specific research question, data access, quality, and methodological fit.

---

## Parameter Defaults and Decision Rules

| Parameter | Default | Notes |
|---|---|---|
| DEG threshold | p < 0.05 with declared fold-change rule | harmonize across datasets where possible |
| Batch correction | ComBat when multiple datasets are merged | validate with PCA / boxplots |
| GSEA threshold | adjusted p-value and FDR declared explicitly | avoid vague ranked-list interpretation |
| PPI confidence | medium confidence or stricter | declare exact cutoff |
| Hub-gene selection | multi-algorithm topological ranking | avoid arbitrary selection |
| ROC interpretation | biomarker support only | avoid clinical deployment claims |
| Immune analysis | group comparison + gene-immune correlation | interpretation only |
| Regulatory analysis | context support, not mechanistic proof | keep conservative |
