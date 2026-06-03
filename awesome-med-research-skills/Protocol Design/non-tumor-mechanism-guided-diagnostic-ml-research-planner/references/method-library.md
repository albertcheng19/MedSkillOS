# Method Library
# non-tumor-mechanism-guided-diagnostic-ml-research-planner-aligned

---

## Core Bioinformatics Tooling

### Primary Analysis Environments
| Tool | Language | Use Case |
|---|---|---|
| limma | R | DEG analysis for bulk expression data |
| sva | R | ComBat-based batch correction |
| glmnet / caret / equivalent | R | feature selection and model construction |
| pROC | R | ROC and AUC support |
| rms / rmda / equivalent | R | calibration and decision-curve analysis |
| clusterProfiler | R | GO / KEGG enrichment and GSEA |
| ggplot2 / pheatmap | R | core figures and QC plots |

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
| GeneCards / PubMed / MSigDB | mechanism-gene-family sources |
| external validation GEO cohorts | expression or model validation |
| ChIPBase / JASPAR / NetworkAnalyst | TF regulation context |
| StarBase | miRNA regulation context |

### Dataset Planning Requirement

| Item | What to Declare |
|---|---|
| Discovery bulk datasets | source, group sizes, platform |
| Merge / batch-correction plan | whether ComBat or equivalent is used |
| Mechanism gene-family resources | source and exact retrieval rule, if used |
| Validation resources | external cohort or orthogonal expression check |
| Immune / regulatory resources | ssGSEA / TF / miRNA tools used |

> **Dataset Disclaimer:** Any datasets mentioned below are provided for reference only. Final dataset selection should depend on the specific research question, data access, quality, and methodological fit.

---

## Parameter Defaults and Decision Rules

| Parameter | Default | Notes |
|---|---|---|
| DEG threshold | p < 0.05 with declared fold-change rule | harmonize across datasets where possible |
| Batch correction | ComBat when multiple datasets are merged | validate with PCA / boxplots |
| Feature selection | at least one explicit shrinkage rule | avoid silent overfitting |
| Model type | logistic model unless user asks otherwise | explain why versus alternatives |
| Calibration / DCA | Standard+ unless justified omission | avoid utility claims without them |
| ROC interpretation | biomarker support only | avoid clinical deployment claims |
| Immune analysis | group comparison + gene-immune correlation | interpretation only |
| Regulatory analysis | context support, not mechanistic proof | keep conservative |
