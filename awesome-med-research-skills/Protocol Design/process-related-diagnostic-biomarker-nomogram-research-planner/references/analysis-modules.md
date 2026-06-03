# Analysis Module Library
# process-related-diagnostic-biomarker-nomogram-research-planner

---

## Dataset and Gene-Family Architecture Modules

| Module | Purpose | When Required |
|---|---|---|
| Discovery bulk-dataset declaration | Define primary training / discovery expression datasets | Always |
| Validation bulk-dataset declaration | Define orthogonal validation datasets if available | Standard+ |
| Process-gene-family declaration | Make anoikis / ferroptosis / custom process family explicit | Always |
| WGCNA/module resource declaration | Define co-expression integration availability | Pattern B / Standard+ |
| Experimental-resource declaration | Define animal model, qRT-PCR, or protein validation availability | Pattern E |
| Tissue-source comparability review | Prevent uncontrolled source-mismatch interpretation | Standard+ |

### Dataset Declaration and Reference Block

| Item | Required Content |
|---|---|
| Discovery datasets | source, sample groups, platform, case/control counts |
| Validation datasets | source, sample groups, platform, case/control counts |
| Process-gene source | GeneCards / Harmonizome / MSigDB / curated literature list |
| Module-integration resources | WGCNA or equivalent co-expression pipeline |
| Experimental resources | animal model, qRT-PCR, western blot, or none |

> **Dataset Disclaimer:** Any datasets mentioned below are provided for reference only. Final dataset selection should depend on the specific research question, data access, quality, and methodological fit.

---

## Core Discovery Modules

| Module | Purpose | When Required |
|---|---|---|
| DEG analysis | Identify disease-associated differential expression | Always |
| Process-gene intersection | Focus on process-relevant DEGs | Always |
| GO enrichment | Describe process-related biology | Lite+ |
| KEGG enrichment | Describe pathway-level involvement | Lite+ |
| Correlation analysis among candidates | Identify internal structure before modeling | Standard+ |
| Candidate shortlist construction | Reduce noise before downstream modeling | Standard+ |

## Co-Expression and Biomarker Selection Modules

| Module | Purpose | When Required |
|---|---|---|
| WGCNA module screening | Add disease-associated co-expression structure | Pattern B / Standard+ |
| DEG ∩ process genes ∩ module genes intersection | Increase robustness of process-related candidates | Pattern B / Standard+ |
| LASSO feature selection | Select sparse biomarker candidates | Pattern C / Standard+ |
| Random Forest / RFE selection | Identify non-linear feature importance | Pattern C / Standard+ |
| Multi-method intersection of selected genes | Increase feature robustness | Pattern C / Standard+ |
| ROC and AUC evaluation | Assess diagnostic value conservatively | Pattern D / Standard+ |

## Diagnostic Model and Interpretation Modules

| Module | Purpose | When Required |
|---|---|---|
| Nomogram construction | Integrate selected biomarkers into a prediction tool | Pattern D / Advanced+ |
| Calibration analysis | Evaluate agreement between predicted and observed risk | Pattern D / Advanced+ |
| Decision-curve analysis | Evaluate net benefit of the model | Pattern D / Advanced+ |
| Tissue-specific validation review | Prevent cross-tissue overgeneralization | Advanced+ |
| Single-gene GSEA | Contextualize hub biomarkers biologically | Pattern E / Advanced+ |
| Claim-boundary summary | Separate diagnostic support from clinical deployment | Always |

## Immune, Regulatory, and Experimental Modules

| Module | Purpose | When Required |
|---|---|---|
| ssGSEA immune infiltration | Estimate immune-cell activity in bulk data | Pattern E / Standard+ |
| Gene-immune correlation | Link candidate biomarkers to immune context | Pattern E / Standard+ |
| miRNA-TF-mRNA network | Explore upstream regulatory architecture | Pattern E / Advanced+ |
| External expression validation | Check reproducible direction in independent datasets | Standard+ |
| Experimental validation | Add limited orthogonal support | Publication+ |
| Experimental-result caveat layer | Prevent overinterpreting small validation studies | Always when experiments are used |
