# Method Library
# comorbidity-common-immune-biomarker-research-planner

---

## Core Bioinformatics Tooling

### Primary Analysis Environments
| Tool | Language | Use Case |
|---|---|---|
| limma | R | DEG analysis for preprocessed expression matrices |
| clusterProfiler | R | GO / KEGG enrichment |
| STRING | web/database | PPI network construction |
| Cytoscape / cytoHubba | mixed | network visualization and hub-gene prioritization |
| glmnet | R | LASSO feature selection |
| randomForest / equivalent | R | feature importance and candidate selection |
| pROC | R | ROC and AUC validation |
| ggplot2 / pheatmap | R | volcano plots, heatmaps, enrichment and validation figures |

### Regulatory and Immune Tools
| Tool / Resource | Use Case |
|---|---|
| GeneMANIA | gene-gene functional interaction context |
| NetworkAnalyst / JASPAR | TF-gene regulatory analysis |
| CIBERSORT or equivalent | immune infiltration estimation |
| cor.test / Spearman framework | gene-immune correlation |

---

## Data Resources

### Common Public Resources
| Resource | Coverage |
|---|---|
| GEO | disease-expression datasets |
| STRING | protein interaction |
| GeneMANIA | gene-gene interaction |
| NetworkAnalyst / JASPAR | TF regulation context |
| CIBERSORT | immune-cell proportion estimation |

### Dataset Planning Requirement

| Item | What to Declare |
|---|---|
| Disease A datasets | source, group sizes, platform |
| Disease B datasets | source, group sizes, platform |
| Validation datasets | source, group sizes, platform |
| Immune resources | CIBERSORT or equivalent |
| Integration rule | overlap / validation / selection logic |

> **Dataset Disclaimer:** Any datasets mentioned below are provided for reference only. Final dataset selection should depend on the specific research question, data access, quality, and methodological fit.

---

## Parameter Defaults and Decision Rules

| Parameter | Default | Notes |
|---|---|---|
| DEG threshold | p < 0.05 with declared fold-change rule | harmonize across datasets where possible |
| PPI confidence | medium confidence or stricter | declare exact cutoff |
| Hub-gene selection | topological ranking with declared method | avoid arbitrary selection |
| ML feature rule | at least two selection approaches if ML is central | reduce method-specific noise |
| ROC interpretation | biomarker support only | avoid clinical deployment claims |
| Immune analysis | group comparison + gene-immune correlation | interpretation only |
| Regulatory analysis | context support, not mechanistic proof | keep conservative |
