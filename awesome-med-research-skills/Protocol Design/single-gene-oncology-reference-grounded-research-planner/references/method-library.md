# Method Library
# single-gene-oncology-reference-grounded-research-planner-aligned

---

## Core Analysis Environments

### Primary Analysis Environments
| Tool / Resource | Use Case |
|---|---|
| TCGA / GTEx-compatible portals | tumor-vs-normal expression context |
| survival / Cox / Kaplan–Meier framework | prognostic association |
| limma / DESeq2 / portal-native statistics | expression comparison and subgroup review |
| clusterProfiler / GSEA framework | pathway interpretation |
| TIMER / GSVA / ssGSEA | immune association |
| cBioPortal | mutation and CNV context |
| methylation or proteomic portals | epigenetic / protein support |
| pROC | ROC-style support when explicitly used |

### Translational Context Tools
| Tool / Resource | Use Case |
|---|---|
| HPA / CPTAC / tissue atlas resources | orthogonal protein support |
| GDSC / CTRP / CellMiner-style resources | conservative drug-response context |
| correlation / partial-correlation framework | checkpoint or immune linkage |

---

## Data Resources

### Common Public Resources
| Resource | Coverage |
|---|---|
| TCGA / GTEx / UCSC Xena / GEPIA-like portals | expression and survival context |
| GEO | external transcriptomic validation |
| TIMER / TISIDB / GSVA-like frameworks | immune context |
| cBioPortal | genomic alteration context |
| HPA / CPTAC | orthogonal protein context |

### Dataset Planning Requirement

| Item | What to Declare |
|---|---|
| Primary tumor cohorts | source, tumor vs normal availability, sample counts |
| Survival endpoints | OS / DSS / PFI / RFS or equivalent |
| Immune resources | portal or algorithm used |
| Genomic resources | CNV / mutation / methylation source |
| Validation resources | external cohort or protein-support source |

> **Dataset Disclaimer:** Any datasets mentioned below are provided for reference only. Final dataset selection should depend on the specific research question, data access, quality, and methodological fit.

---

## Parameter Defaults and Decision Rules

| Parameter | Default | Notes |
|---|---|---|
| Expression threshold | declare exact statistical rule | avoid mixing incompatible normal references silently |
| Survival model | Kaplan–Meier + Cox logic declared explicitly | avoid overclaiming causality |
| Immune analysis | correlation + group comparison | interpretation only |
| Checkpoint analysis | predefined checkpoint panel | context support only |
| Genomic analysis | descriptive alteration frequencies | not mechanistic proof |
| Drug-response analysis | hypothesis-generating only | no efficacy claims |
| Validation interpretation | orthogonal support only | not clinical readiness |
