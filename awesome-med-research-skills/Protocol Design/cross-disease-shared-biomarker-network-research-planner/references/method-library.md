# Method Library
# cross-disease-shared-biomarker-network-research-planner

---

## Core Bioinformatics Tooling

### Primary Analysis Environments
| Tool | Language | Use Case |
|---|---|---|
| limma | R | DEG analysis for preprocessed expression matrices |
| clusterProfiler | R | GO / KEGG enrichment |
| STRING | web/database | PPI network construction |
| Cytoscape / cytoHubba | mixed | network visualization and hub-gene prioritization |
| ggplot2 / pheatmap | R | volcano plots, heatmaps, enrichment figures |

### Public Validation and Interpretation Platforms
| Tool / Resource | Use Case |
|---|---|
| GEPIA / TCGA | cancer expression and survival validation |
| HPA | protein-expression plausibility |
| TIMER | immune-infiltration correlation |
| NetworkAnalyst | TF-gene and TF-miRNA regulatory network analysis |
| DGIdb | drug-gene interaction screening |

### Experimental Follow-Up
| Tool / Method | Use Case |
|---|---|
| qRT-PCR | mRNA-level orthogonal validation |
| cell-line comparison | direction consistency between normal and disease lines |
| tissue validation | optional if explicitly available |

---

## Data Resources

### Common Public Resources
| Resource | Coverage |
|---|---|
| GEO | disease-expression datasets |
| TCGA / GEPIA | tumor validation and survival |
| HPA | protein-level support |
| TIMER | immune infiltration |
| DGIdb | drug-gene interaction |
| NetworkAnalyst / ENCODE / RegNetwork | transcription-factor and miRNA regulation context |

### Dataset Planning Requirement

| Item | What to Declare |
|---|---|
| Disease A datasets | source, case/control groups, platform |
| Disease B datasets | source, case/control groups, platform |
| Validation resources | GEPIA / HPA / TIMER / DGIdb or equivalents |
| Experimental resources | qRT-PCR / cell line / tissue if used |
| Integration rule | overlap / union / consistency logic |

> **Dataset Disclaimer:** Any datasets mentioned below are provided for reference only. Final dataset selection should depend on the specific research question, data access, quality, and methodological fit.

---

## Parameter Defaults and Decision Rules

| Parameter | Default | Notes |
|---|---|---|
| DEG threshold | p < 0.05 and fold-change threshold declared | harmonize across datasets where possible |
| PPI confidence | medium confidence or stricter | declare exact cutoff |
| Hub-gene selection | topological ranking with declared method | avoid arbitrary selection |
| Validation rule | public validation before experimental validation | keep evidence layers separate |
| Immune / drug modules | interpretation and follow-up only | not causal proof |
| Experimental validation | expression-direction confirmation only unless more assays exist | keep conservative |
