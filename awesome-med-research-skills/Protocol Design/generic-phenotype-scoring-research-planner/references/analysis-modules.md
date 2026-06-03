# Analysis Module Library
# generic-phenotype-scoring-research-planner

---

## Dataset and Signature Architecture Modules

| Module | Purpose | When Required |
|---|---|---|
| Discovery bulk-dataset declaration | Define primary training / discovery expression datasets | Always |
| Validation bulk-dataset declaration | Define secondary validation bulk datasets if available | Standard+ |
| Signature-gene-set declaration | Make pathway / process / phenotype signature source explicit | Always |
| Single-cell dataset declaration | Define scRNA-seq availability and scope | Pattern D / Advanced+ |
| Platform harmonization review | Prevent uncontrolled cross-platform inconsistency | Standard+ |
| Overlap / signature-intersection rule | Make signature-focused candidate discovery reproducible | Always |

### Dataset Declaration and Reference Block

| Item | Required Content |
|---|---|
| Discovery datasets | source, sample groups, platform, case/control counts |
| Validation datasets | source, sample groups, platform, case/control counts |
| scRNA-seq resource | source, sample counts, tissue/cell context |
| Signature source | MSigDB / curated set / literature-derived / custom source |
| Validation platforms | PPI / NetworkAnalyst / public classifier / orthogonal resources |

> **Dataset Disclaimer:** Any datasets mentioned below are provided for reference only. Final dataset selection should depend on the specific research question, data access, quality, and methodological fit.

---

## Core Signature Discovery Modules

| Module | Purpose | When Required |
|---|---|---|
| DEG analysis | Identify disease-associated differential expression | Always |
| Signature-gene intersection | Focus on signature-relevant DEGs | Always |
| Secondary filtering | Remove weak or non-reproducible features | Standard+ |
| GO enrichment | Describe signature-related biology | Lite+ |
| KEGG enrichment | Describe pathway-level involvement | Lite+ |
| Key gene shortlist construction | Reduce noise before downstream modeling | Standard+ |

## Phenotype Scoring and Classifier Modules

| Module | Purpose | When Required |
|---|---|---|
| SVM-RFE or equivalent feature selection | Identify strongest predictive signature genes | Pattern C / Standard+ |
| z-score / GSVA phenotype scoring | Quantify pathway/signature activity per sample | Pattern B / Standard+ |
| High/low phenotype grouping | Enable downstream GSEA or immune comparisons | Standard+ |
| Machine-learning diagnostic or stratification evaluation | Assess classification or grouping potential | Pattern C / Advanced+ |
| Cross-validation review | Prevent inflated diagnostic claims | Advanced+ |
| Accuracy / AUC caveat layer | Keep classifier claims conservative | Always when ML is used |

## Immune and Cellular-Resolution Modules

| Module | Purpose | When Required |
|---|---|---|
| ssGSEA immune infiltration | Estimate immune-cell activity in bulk data | Pattern D / Standard+ |
| Phenotype-score vs immune correlation | Link signature activity to immune shifts | Pattern D / Standard+ |
| scRNA-seq cell clustering | Identify cell-type-specific signature activity | Pattern D / Advanced+ |
| Cell-level signature scoring | Quantify phenotype/process activity by cell type | Pattern D / Advanced+ |
| Cell-type proportion comparison | Support cellular-context interpretation | Advanced+ |
| Cell-specific expression comparison | Identify which clusters carry pathway activity shifts | Advanced+ |

## Network and Validation Modules

| Module | Purpose | When Required |
|---|---|---|
| PPI network construction | Build interaction-supported candidate structure | Standard+ |
| TF-gene / TF-miRNA network | Explore upstream regulatory architecture | Pattern E / Advanced+ |
| Orthogonal validation in second bulk dataset | Check reproducible expression direction | Standard+ |
| qRT-PCR / orthogonal lab validation | Add limited experimental support | Publication+ |
| Public or machine-learning validation summary | Improve reviewer-facing signal coherence | Standard+ |
| Claim-boundary summary | Separate feature value from mechanism proof | Always |
