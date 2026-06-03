# Analysis Module Library
# comparative-network-toxicology-shared-mechanism-reference-grounded-research-planner-aligned

---

## Exposure and Toxic-Target Architecture Modules

| Module | Purpose | When Required |
|---|---|---|
| Exposure-A target declaration | Define target set for exposure A | Always |
| Exposure-B target declaration | Define target set for exposure B | Always |
| Toxic-phenotype target declaration | Define disease / toxicity target universe | Always |
| Shared-vs-specific decomposition | Separate common vs exposure-specific signals | Always |
| Validation-support declaration | Define transcriptomic, literature, or orthogonal cross-check resources | Pattern E / Advanced+ |
| Docking-resource declaration | Define receptor structure and ligand preparation source | Pattern D / Standard+ |

### Dataset Declaration and Reference Block

| Item | Required Content |
|---|---|
| Exposure A / B sources | target-prediction databases and retrieval rules |
| Toxic phenotype source | gene / target resource and keyword logic |
| PPI / enrichment resources | STRING, enrichment platform, or equivalent |
| Docking resources | receptor structure source, ligand source, scoring rules |
| Cross-check resources | transcriptomic dataset, AOP source, or literature validation |

> **Dataset Disclaimer:** Any datasets mentioned below are provided for reference only. Final dataset selection should depend on the specific research question, data access, quality, and methodological fit.

---

## Core Discovery Modules

| Module | Purpose | When Required |
|---|---|---|
| Exposure-target collection | Build target sets for both exposures | Always |
| Toxic-target overlap analysis | Connect exposure targets to shared outcome | Always |
| Shared vs specific target decomposition | Separate common and divergent mechanisms | Always |
| GO enrichment | Describe biological-process context | Lite+ |
| KEGG enrichment | Describe pathway-level involvement | Lite+ |
| Candidate shortlist construction | Reduce noise before downstream prioritization | Standard+ |

## Hub, Docking, and Validation Modules

| Module | Purpose | When Required |
|---|---|---|
| PPI network construction | Build interaction-supported target structure | Standard+ |
| Hub-target prioritization | Identify central common or exposure-specific targets | Standard+ |
| Molecular docking | Evaluate binding plausibility for shortlisted targets | Pattern D / Standard+ |
| Transcriptomic or orthogonal cross-check | Add secondary support for shared targets or pathways | Pattern E / Advanced+ |
| AOP or mechanistic synthesis layer | Organize shared-vs-specific evidence coherently | Advanced+ |
| Claim-boundary summary | Separate mechanistic hypotheses from proof | Always |
