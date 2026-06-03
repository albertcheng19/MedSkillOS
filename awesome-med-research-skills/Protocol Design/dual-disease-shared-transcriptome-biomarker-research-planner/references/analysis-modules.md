# Analysis Module Library
# dual-disease-shared-transcriptome-biomarker-research-planner

---

## Dual-Disease Core Modules

| Module | Purpose | When Required |
|---|---|---|
| Disease-pair cohort selection and endpoint harmonization | Define discovery and validation cohorts for both diseases with comparable case-control structure | Always |
| Per-disease differential expression | Identify disease-associated transcriptional changes for each disease separately | Always |
| Cross-disease direction-concordance check | Prevent invalid mixing of opposite-direction signals | Always |
| DEG visualization | Volcano / heatmap / overlap summary for interpretable screening | Lite+ |
| Shared-candidate reduction logic | Prevent arbitrary downstream prioritization | Always |
| Enrichment analysis | Summarize biology of shared candidates or final endpoints | Lite+ |

## Shared-Biomarker Prioritization Modules

| Module | Purpose | When Required |
|---|---|---|
| Strict DEG overlap | Define shared candidate universe transparently | Pattern A / B / C |
| Ranked concordance integration | Rescue sparse intersections while preserving explicit logic | Advanced+ when overlap is too small |
| STRING PPI network | Build interaction-supported candidate structure | Pattern B / C, Standard+ |
| Cytoscape / cytoHubba ranking | Prioritize central shared candidates systematically | Pattern B / C, Standard+ |
| Overlap ranking across criteria | Combine overlap, PPI, ROC, and external consistency signals | Pattern B / C, Standard+ |
| Compression to one preferred lead gene | Create a coherent dual-disease translational endpoint | Pattern C / E |

## Utility and Context Modules

| Module | Purpose | When Required |
|---|---|---|
| ROC evaluation in disease A | Evaluate diagnostic separation in the first disease | Standard+ |
| ROC evaluation in disease B | Evaluate diagnostic separation in the second disease | Standard+ |
| Dual-disease expression validation | Confirm directionality in independent cohorts for both diseases | Standard+ |
| Single-gene GSEA / GSVA | Interpret pathway context around a final lead gene | Standard+ |
| Immune deconvolution | Estimate immune-cell composition and contextualize shared biomarker findings | Standard+ when immune angle requested |
| Lead gene–immune correlation | Add focused immune interpretation downstream of endpoint selection | Standard+ when immune angle requested |
| External protein / portal plausibility review | Add orthogonal support without overstating evidence | Advanced+ |

## Translational Validation Modules

| Module | Purpose | When Required |
|---|---|---|
| Independent cohort replication in both diseases | Confirm expression / utility consistency across datasets | Standard+ |
| Disease-asymmetric validation note | Preserve claim boundaries when only one disease has validation | Always when validation is uneven |
| Protein plausibility review | Check whether orthogonal resources support expression direction | Advanced+ |
| Tissue validation | Add local translational evidence if samples exist | Pattern E |
| Functional follow-up | Test biological plausibility around the final lead gene | Publication+ |

## Integration and Reporting Modules

| Module | Purpose | When Required |
|---|---|---|
| Evidence-label matrix | Separate association, diagnostic utility, sharedness, and functional support | Always |
| Figure dependency map | Ensure story flows from per-disease discovery to final shared endpoint | Standard+ |
| Risk and downgrade review | Control infeasible overdesign and overclaiming | Always |
| Literature support layer | Justify biology, methods, and novelty gap | Always |
