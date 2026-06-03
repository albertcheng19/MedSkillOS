# Analysis Module Library
# conventional-oncology-hub-gene-research-planner

---

## Bulk-Tumor Core Modules

| Module | Purpose | When Required |
|---|---|---|
| Cohort selection and endpoint harmonization | Define discovery and validation cohorts with usable survival / clinical endpoints | Always |
| Tumor vs normal differential expression | Identify disease-associated transcriptional changes | Always |
| Clinical variable harmonization | Prevent invalid subgroup and independence analyses | Always |
| DEG visualization | Volcano / heatmap / candidate summary for interpretable screening | Lite+ |
| Candidate-gene reduction logic | Prevent arbitrary downstream prioritization | Always |
| Enrichment analysis | Summarize biology of candidate genes or endpoints | Lite+ |

## Prognostic Modeling Modules

| Module | Purpose | When Required |
|---|---|---|
| Univariate Cox screening | Identify survival-associated candidates | Standard+ |
| LASSO feature reduction | Control overfitting during risk-model construction | Pattern A / C |
| Multivariable Cox model | Build final risk score or independent prognostic model | Pattern A / C |
| Kaplan–Meier stratification | Demonstrate survival separation | Standard+ |
| Time-dependent ROC | Evaluate 1/3/5-year prognostic discrimination | Standard+ |
| C-index / calibration | Strengthen reviewer-facing model quality | Advanced+ |
| Nomogram | Translational utility presentation | Advanced+ |
| External survival validation | Test generalizability of prognostic signal | Standard+ |

## Hub-Gene Prioritization Modules

| Module | Purpose | When Required |
|---|---|---|
| STRING PPI network | Build interaction-supported candidate structure | Pattern B / C, Standard+ |
| Cytoscape / cytoHubba ranking | Prioritize central candidates systematically | Pattern B / C, Standard+ |
| Overlap ranking across criteria | Combine DEG, survival, PPI, and clinical signals | Pattern B / C, Standard+ |
| Diagnostic ROC comparison | Evaluate tumor vs normal discrimination | Pattern B / C, Standard+ |
| Clinical association of lead gene | Support stage / grade / prognosis relevance | Standard+ |
| Compression to one preferred lead gene | Create a coherent translational endpoint | Pattern C / E |

## Immune and Regulation Context Modules

| Module | Purpose | When Required |
|---|---|---|
| ssGSEA / GSVA immune scoring | Estimate immune activity from bulk expression data | Standard+ when immune angle requested |
| Immune deconvolution | Estimate immune-cell composition and reduce one-tool bias | Advanced+ |
| Checkpoint expression context | Add immunotherapy-related interpretation layer | Standard+ when immune angle requested |
| Expression–methylation association | Explore regulatory plausibility | Standard+ when methylation requested |
| CpG survival exploration | Add clinically relevant methylation detail | Advanced+ |
| Portal-based context (UALCAN / cBioPortal / HPA) | Add orthogonal protein or regulation support | Standard+ |

## Translational Validation Modules

| Module | Purpose | When Required |
|---|---|---|
| External bulk cohort replication | Confirm expression / survival consistency in independent dataset | Standard+ |
| HPA protein plausibility review | Check protein-level directionality support | Standard+ |
| Institutional tissue qPCR | Validate expression in local tissue cohort | Pattern E |
| Western blot | Validate protein-level expression direction | Pattern E |
| CCK8 / colony formation | Assess proliferative phenotype support | Pattern E |
| Transwell migration / invasion | Assess migration or invasion phenotype support | Pattern E |
| Knockdown / overexpression follow-up | Strengthen functional plausibility around final lead gene | Publication+ |

## Integration and Reporting Modules

| Module | Purpose | When Required |
|---|---|---|
| Evidence-label matrix | Separate association, prognosis, utility, and functional support | Always |
| Figure dependency map | Ensure story flows from discovery to final endpoint | Standard+ |
| Risk and downgrade review | Control infeasible overdesign and overclaiming | Always |
| Literature support layer | Justify biology, methods, and novelty gap | Always |
