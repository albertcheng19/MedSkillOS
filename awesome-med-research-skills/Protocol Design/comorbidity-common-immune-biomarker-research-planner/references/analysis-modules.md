# Analysis Module Library
# comorbidity-common-immune-biomarker-research-planner

---

## Cross-Disease Dataset Architecture Modules

| Module | Purpose | When Required |
|---|---|---|
| Disease-pair dataset declaration | Define which datasets belong to each disease | Always |
| Platform harmonization review | Prevent uncontrolled cross-platform inconsistency | Standard+ |
| Control-group logic | Ensure comparable normal/control baseline per dataset | Always |
| Overlap-gene extraction logic | Make shared-biomarker discovery reproducible | Always |
| Validation-dataset declaration | Define external validation resources clearly | Standard+ |
| Immune-analysis resource declaration | Define CIBERSORT / equivalent immune estimation plan | Pattern D / Standard+ |

### Dataset Declaration and Reference Block

| Item | Required Content |
|---|---|
| Disease A datasets | source, sample groups, platform, case/control counts |
| Disease B datasets | source, sample groups, platform, case/control counts |
| Validation datasets | source, sample groups, platform, case/control counts |
| Immune-analysis resources | CIBERSORT / signature matrix / equivalent |
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

## Hub-Gene and Machine-Learning Modules

| Module | Purpose | When Required |
|---|---|---|
| PPI network construction | Build interaction-supported common-gene structure | Standard+ |
| Topological prioritization | Identify candidate hub genes systematically | Standard+ |
| LASSO feature selection | Select sparse biomarker candidates | Pattern C / Standard+ |
| Random Forest / equivalent selection | Identify non-linear feature importance | Pattern C / Standard+ |
| Intersection of ML-selected genes | Increase feature robustness | Pattern C / Standard+ |
| ROC and AUC validation | Evaluate diagnostic value conservatively | Pattern E / Standard+ |

## Regulatory and Immune Interpretation Modules

| Module | Purpose | When Required |
|---|---|---|
| Gene-gene interaction analysis | Add neighboring functional context | Pattern D / Standard+ |
| TF-gene interaction network | Explore upstream regulatory architecture | Pattern D / Advanced+ |
| Immune infiltration estimation | Estimate immune-cell shifts in each disease | Pattern D / Standard+ |
| Gene-immune correlation | Link candidate biomarkers to immune context | Pattern D / Standard+ |
| Immune-pattern comparison across diseases | Identify convergent and divergent immune features | Advanced+ |
| Mechanistic-claim boundary layer | Prevent inflammatory interpretation from becoming causal proof | Always |

## Validation and Reporting Modules

| Module | Purpose | When Required |
|---|---|---|
| External validation dataset review | Check expression direction and biomarker stability | Standard+ |
| Public biomarker validation summary | Improve reviewer-facing signal coherence | Standard+ |
| Bias and reproducibility review | Control cross-dataset and small-sample limitations | Always |
| Follow-up prioritization ladder | Rank which biomarkers deserve deeper study | Advanced+ |
| Claim-boundary summary | Separate biomarkers from therapeutic or mechanistic proof | Always |
