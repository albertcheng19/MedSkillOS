# Analysis Module Library
# conventional-non-oncology-hub-gene-research-planner

---

## Dataset and Process-Gene Architecture Modules

| Module | Purpose | When Required |
|---|---|---|
| Discovery dataset declaration | Define primary bulk expression datasets | Always |
| Multi-dataset merge and batch correction | Improve cross-dataset integration when >1 dataset is used | Standard+ |
| Process-gene-family declaration | Make metabolic reprogramming / oxidative stress / custom biology theme explicit | Always |
| Validation-support declaration | Define ROC or orthogonal public support resources | Standard+ |
| Immune-analysis resource declaration | Define ssGSEA / immune-signature estimation plan | Pattern D / Standard+ |
| Regulatory-resource declaration | Define TF / miRNA network sources | Pattern D / Advanced+ |

### Dataset Declaration and Reference Block

| Item | Required Content |
|---|---|
| Discovery datasets | source, sample groups, platform, case/control counts |
| Batch-correction plan | whether multiple datasets are merged and how |
| Process-gene source | GeneCards / PubMed / MSigDB / curated source |
| Validation resources | ROC support dataset or within-dataset support rule |
| Immune / regulatory resources | ssGSEA / TF / miRNA network sources |

> **Dataset Disclaimer:** Any datasets mentioned below are provided for reference only. Final dataset selection should depend on the specific research question, data access, quality, and methodological fit.

---

## Core Discovery Modules

| Module | Purpose | When Required |
|---|---|---|
| DEG analysis | Identify disease-associated differential expression | Always |
| Process-gene intersection | Focus on process-relevant DEGs | Always |
| GO enrichment | Describe process-related biology | Lite+ |
| KEGG enrichment | Describe pathway-level involvement | Lite+ |
| GSEA | Provide ranked-list pathway interpretation | Pattern B / Standard+ |
| Candidate shortlist construction | Reduce noise before downstream prioritization | Standard+ |

## Hub-Gene and Network Modules

| Module | Purpose | When Required |
|---|---|---|
| PPI network construction | Build interaction-supported candidate structure | Standard+ |
| Multi-algorithm hub-gene prioritization | Increase robustness of hub-gene selection | Standard+ |
| mRNA-TF regulatory network | Explore transcriptional regulatory context | Pattern D / Advanced+ |
| mRNA-miRNA regulatory network | Add post-transcriptional interpretation layer | Pattern D / Advanced+ |
| Network-size control | Prevent decorative over-expansion of weak nodes | Advanced+ |
| Hub-gene ranking coherence review | Check consistency across prioritization algorithms | Standard+ |

## Validation and Immune Interpretation Modules

| Module | Purpose | When Required |
|---|---|---|
| Differential expression re-check for hub genes | Confirm direction and magnitude | Standard+ |
| ROC / AUC support | Assess biomarker value conservatively | Pattern E / Standard+ |
| ssGSEA immune infiltration | Estimate immune-cell abundance differences | Pattern D / Standard+ |
| Gene-immune correlation | Link hub genes to immune context | Pattern D / Standard+ |
| Immune-cell correlation structure | Describe immune-pattern internal structure | Advanced+ |
| Claim-boundary summary | Separate biomarker support from mechanistic proof | Always |
