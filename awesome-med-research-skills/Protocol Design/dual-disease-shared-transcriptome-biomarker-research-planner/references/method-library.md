# Method Library
# dual-disease-shared-transcriptome-biomarker-research-planner

---

## Differential Expression

### Default rule
- **Count data → DESeq2 (recommended)**
- **Non-count normalized microarray data, log-transformed expression matrices, or processed expression values → limma**

### Typical thresholds
- Adjusted p < 0.05
- |log2FC| threshold chosen according to tissue heterogeneity and platform
- Same-direction requirement for shared-DEG overlap unless an alternative is explicitly justified

### Notes
- Do not recommend count-based workflows for already normalized GEO matrices.
- If disease A and disease B use different input types, declare the branch-specific method choice explicitly.

---

## Shared-Candidate Generation

| Strategy | When to Use | Caution |
|---|---|---|
| Strict same-direction overlap | Default for conventional dual-disease transcriptome studies | Can become too sparse |
| Ranked concordance integration | When overlap is too sparse but effect-direction agreement is still meaningful | Must be explicitly defined |
| Predeclared weighted integration | Advanced+ when multiple evidence layers are combined | Do not hide weighting rules |

---

## Network and Prioritization

| Method | Default | Notes |
|---|---|---|
| PPI network | STRING | Use confidence threshold and document it |
| Network visualization | Cytoscape | Standard+ |
| Hub ranking | cytoHubba | Prefer MCC plus at least one secondary metric |
| Candidate compression | overlap ∩ PPI hubs ∩ ROC support | Do not compress to one gene without explicit logic |

---

## Utility Evaluation

| Method | Use | Notes |
|---|---|---|
| ROC / AUC | Diagnostic separation in each disease | Evaluate separately in both diseases |
| Expression boxplot / violin plot | Direction consistency | Discovery and validation cohorts |
| Cross-cohort consistency review | Reviewer-facing robustness | Standard+ |

---

## Immune / Pathway Interpretation

| Method | Use | Notes |
|---|---|---|
| CIBERSORT / CIBERSORTx | Immune-cell inference from bulk data | Label as inference, not direct measurement |
| ssGSEA / GSVA | Pathway or immune-score interpretation | Good for single-gene downstream context |
| Single-gene GSEA | Lead-gene-centered pathway interpretation | Standard+ |
| Correlation analysis | Lead gene vs immune cells / pathways | Association only |

---

## Validation and Orthogonal Support

| Method | Use | Notes |
|---|---|---|
| Independent GEO cohort | External expression validation | Prefer one cohort per disease |
| Protein atlas / portal review | Orthogonal plausibility support | Advanced+ |
| Tissue qPCR / IHC | Translational validation | Publication+ |
| Functional experiments | Mechanistic plausibility | Publication+ only if truly available |
