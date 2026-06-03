# Analysis Module Library
# cross-disease-shared-biomarker-network-research-planner

---

## Cross-Disease Dataset Architecture Modules

| Module | Purpose | When Required |
|---|---|---|
| Disease-pair dataset declaration | Define which datasets belong to each disease | Always |
| Platform harmonization review | Prevent uncontrolled cross-platform inconsistency | Standard+ |
| Control-group logic | Ensure comparable normal/control baseline per dataset | Always |
| Overlap-gene extraction logic | Make shared-biomarker discovery reproducible | Always |
| Validation-platform declaration | Define TCGA / GEPIA / HPA or equivalent resources | Standard+ |
| Experimental-resource declaration | Define qRT-PCR / cell-line or tissue validation availability | Pattern E |

### Dataset Declaration and Reference Block

| Item | Required Content |
|---|---|
| Disease A datasets | source, sample groups, platform, case/control counts |
| Disease B datasets | source, sample groups, platform, case/control counts |
| Validation datasets/platforms | TCGA / GEPIA / HPA / TIMER / DGIdb / others |
| Experimental resources | cell lines, tissue, qRT-PCR availability if used |
| Overlap rule | how shared genes are defined across datasets |

> **Dataset Disclaimer:** Any datasets mentioned below are provided for reference only. Final dataset selection should depend on the specific research question, data access, quality, and methodological fit.

---

## Core Discovery Modules

| Module | Purpose | When Required |
|---|---|---|
| DEG analysis per dataset | Identify disease-specific differential expression | Always |
| Shared-DEG intersection | Identify common genes across diseases | Always |
| Volcano / heatmap visualization | Summarize differential expression landscape | Lite+ |
| GO enrichment | Describe shared biological processes | Lite+ |
| KEGG enrichment | Describe shared pathway involvement | Lite+ |
| Shared-gene shortlist construction | Reduce noise before downstream prioritization | Standard+ |

## Hub-Gene and Network Modules

| Module | Purpose | When Required |
|---|---|---|
| PPI network construction | Build interaction-supported common-gene structure | Standard+ |
| cytoHubba / topological prioritization | Identify candidate hub genes systematically | Standard+ |
| TF-gene interaction network | Explore upstream regulatory architecture | Pattern C / Advanced+ |
| TF-miRNA co-regulatory network | Add regulatory-layer interpretation | Pattern C / Advanced+ |
| Network-size control | Prevent decorative over-expansion of weak nodes | Advanced+ |

## Public Validation and Follow-Up Modules

| Module | Purpose | When Required |
|---|---|---|
| GEPIA / TCGA expression validation | Test whether hub genes validate in cancer/public data | Standard+ |
| HPA protein plausibility | Add orthogonal protein-level support | Standard+ |
| Survival analysis | Test prognostic relevance where appropriate | Standard+ |
| TIMER / immune infiltration | Explore tumor immune-context relevance | Pattern D / Advanced+ |
| DGIdb drug-gene screening | Identify candidate drug-target interactions | Pattern D / Advanced+ |
| Candidate-drug prioritization logic | Prevent inflated therapeutic claims | Advanced+ |

## Experimental Validation Modules

| Module | Purpose | When Required |
|---|---|---|
| qRT-PCR validation | Test mRNA expression in cell lines or tissues | Pattern E |
| Cell-line direction consistency | Confirm direction relative to in silico findings | Pattern E |
| Minimal experimental support layer | Add limited orthogonal confirmation without overclaiming mechanism | Publication+ |
| Experimental-result caveat layer | Prevent overinterpreting small validation studies | Always when experiments are used |

## Interpretation and Reporting Modules

| Module | Purpose | When Required |
|---|---|---|
| Shared-pathogenesis interpretation | Link two diseases through common biology | Always |
| Claim-boundary summary | Separate shared biomarkers from causal mechanisms | Always |
| Bias and reproducibility review | Control cross-platform and small-sample limitations | Always |
| Follow-up prioritization ladder | Rank which hub genes deserve deeper study | Advanced+ |
