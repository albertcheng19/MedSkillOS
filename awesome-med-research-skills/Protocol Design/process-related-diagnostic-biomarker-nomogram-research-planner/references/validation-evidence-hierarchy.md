# Validation and Evidence Hierarchy
# process-related-diagnostic-biomarker-nomogram-research-planner

---

## Evidence Tiers

### Process-Signature Discovery Evidence (supportive — label explicitly as discovery)

| Evidence | Source | What It Establishes |
|---|---|---|
| Process-related DEGs | bulk DEG + process-gene intersection | disease-linked process signature |
| GO / KEGG enrichment | enrichment analysis | pathway relevance around signature |
| WGCNA module support | co-expression analysis | disease-associated module reinforcement |
| PPI position | network analysis | interaction-supported feature centrality |

### Machine-Learning Biomarker Evidence (stronger — label explicitly as biomarker selection)

| Evidence | Source | What It Establishes |
|---|---|---|
| LASSO / RF / RFE feature selection | machine-learning workflow | more focused candidate biomarker set |
| Multi-method intersection | multi-method agreement | stronger feature prioritization |
| ROC / external validation | validation analysis | diagnostic support, not clinical readiness |

### Diagnostic-Model Evidence (supportive — label explicitly as model support)

| Evidence | Source | What It Establishes |
|---|---|---|
| Nomogram | biomarker-based model | structured diagnostic-support tool |
| Calibration | calibration curve | internal model agreement |
| Decision-curve analysis | DCA | net-benefit support, not deployment readiness |

### Immune, Regulatory, and Experimental Evidence (supportive to stronger — label explicitly)

| Evidence | Source | What It Establishes |
|---|---|---|
| ssGSEA immune association | bulk immune estimation | immune-context linkage |
| miRNA-TF-mRNA network | regulatory analysis | upstream regulatory context |
| single-gene GSEA | single-biomarker pathway context | plausible biological roles |
| experimental validation | orthogonal support | preliminary biological confirmation |

---

## Language Rules

- Discovery findings: "process-related DEGs", "candidate biomarkers", "pathway-linked candidates"
- Biomarker findings: "feature-selected biomarker", "diagnostic support", "externally validated expression pattern"
- Model findings: "nomogram-based diagnostic support", "calibrated model", "decision-curve net-benefit support"
- Immune/regulatory findings: "suggests immune-context linkage", "supports regulatory relevance"
- Experimental findings: "orthogonal support", "direction-consistent validation"

- **NEVER use:** "proves mechanism", "confirms diagnosis", "establishes treatment target" from bioinformatics and limited validation alone
