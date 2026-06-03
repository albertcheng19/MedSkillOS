# Method Library
# conventional-oncology-hub-gene-research-planner

---

## Bulk Transcriptome Analysis Tools

### Primary Differential Expression Pipelines
| Tool | Language | Use Case |
|---|---|---|
| limma | R | Preferred for normalized microarray-like matrices and voom-transformed counts |
| DESeq2 | R | Preferred for count-based RNA-seq differential expression |
| edgeR | R | Alternative count-based DEG pipeline; useful for smaller sample contexts |

### Survival and Prognostic Modeling
| Tool | Approach |
|---|---|
| survival | Cox regression, Kaplan–Meier |
| survminer | KM visualization and survival-group presentation |
| glmnet | LASSO / elastic-net shrinkage for risk-model construction |
| timeROC / survivalROC | Time-dependent ROC |
| rms | Nomogram and calibration support |

### PPI and Network Prioritization
| Tool | Approach |
|---|---|
| STRING | Protein–protein interaction network construction |
| Cytoscape | Network visualization and downstream prioritization |
| cytoHubba | Centrality-based hub ranking |
| GeneMANIA | Functional interaction context as optional complement |

### Immune and Regulation Context
| Tool | Strength |
|---|---|
| GSVA | Gene-set variation analysis for pathway / immune activity |
| ssGSEA | Single-sample gene-set scoring |
| TIMER | Common immune-cell estimation resource |
| CIBERSORT / CIBERSORTx | Immune deconvolution |
| xCell / MCPcounter | Alternative immune or stromal context scoring |

### Methylation and Portal Resources
| Tool | Strength |
|---|---|
| UALCAN | Tumor expression, clinicopathologic, and methylation context |
| MethSurv | CpG-level methylation survival exploration |
| cBioPortal | Mutation / copy-number / expression context |
| HPA | Protein expression plausibility support |

### Validation and Experimental Follow-Up
| Tool / Method | Use Case |
|---|---|
| GEO validation cohort | External bulk transcriptomic replication |
| qPCR | Tissue-level expression validation |
| Western blot | Protein-level expression direction |
| CCK8 | Proliferation phenotype |
| Colony formation | Growth and clonogenic phenotype |
| Transwell | Migration / invasion phenotype |

---

## Data Resources

### Bulk Expression and Clinical Cohorts
| Resource | Coverage |
|---|---|
| TCGA / GDC | Cancer transcriptome + clinical outcome baseline |
| GEO | Independent validation cohorts |
| CPTAC | Protein-level extension where available |

### Protein / Portal / Regulation Resources
| Resource | Coverage |
|---|---|
| Human Protein Atlas | Tissue and protein expression plausibility |
| UALCAN | Expression / methylation / clinicopathologic context |
| MethSurv | CpG survival associations |
| cBioPortal | Multi-omic cancer context |

---

## Parameter Defaults and Decision Rules

| Parameter | Default | Notes |
|---|---|---|
| DEG adjusted p cutoff | FDR < 0.05 | Use Benjamini–Hochberg |
| DEG fold-change threshold | \|log2FC\| > 1.0 | Relax only if justified |
| Survival significance | p < 0.05 | Prefer effect size and confidence interval review too |
| LASSO alpha | 1.0 | Elastic-net only if explicitly justified |
| PPI interaction score | > 0.4 or > 0.7 | Use stricter threshold for cleaner hub prioritization |
| Diagnostic AUC interest | > 0.70 | Lower values require cautious wording |
| Collinearity control | required before multivariable Cox | Prevent unstable model claims |
| Immune / methylation interpretation | association-level by default | Do not phrase as causal proof |
