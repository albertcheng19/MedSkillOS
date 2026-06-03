# Validation and Evidence Hierarchy
# comorbidity-common-immune-biomarker-research-planner

---

## Evidence Tiers

### Shared-Discovery Evidence (supportive — label explicitly as discovery)

| Evidence | Source | What It Establishes |
|---|---|---|
| Shared DEGs across diseases | overlap analysis | common expression signature across datasets |
| GO / KEGG enrichment | enrichment analysis | shared biological processes and pathways |
| PPI network position | STRING / Cytoscape | interaction-supported hub candidacy |

### Biomarker-Selection Evidence (stronger — label explicitly as biomarker selection)

| Evidence | Source | What It Establishes |
|---|---|---|
| LASSO / RF feature selection | machine-learning workflow | more focused candidate biomarker set |
| Intersection of selected genes | multi-method agreement | stronger feature prioritization |
| ROC / AUC validation | external dataset validation | diagnostic support, not clinical readiness |

### Immune and Regulatory Interpretation Evidence (supportive — label explicitly as interpretation)

| Evidence | Source | What It Establishes |
|---|---|---|
| Immune infiltration estimation | CIBERSORT / equivalent | immune-context linkage |
| Gene-immune correlation | correlation analysis | biomarker–immune association |
| GeneMANIA / TF network | interaction analysis | functional and upstream regulatory context |

### Validation-Support Evidence (stronger — label explicitly as validation support)

| Evidence | Source | What It Establishes |
|---|---|---|
| External dataset expression check | independent dataset | reproducible expression direction |
| Multiple validation views | expression + ROC + immune context | stronger biomarker support coherence |
| Conservative multi-layer agreement | discovery + ML + validation alignment | more credible candidate prioritization |

---

## Language Rules

- Discovery findings: "shared differential expression", "hub-gene candidate", "common pathway enrichment"
- Biomarker findings: "feature-selected biomarker", "diagnostic support", "externally validated expression pattern"
- Immune/regulatory findings: "suggests immune-context linkage", "supports regulatory relevance"
- Validation findings: "orthogonal support", "direction-consistent validation"

- **NEVER use:** "proves mechanism", "confirms therapeutic target", "establishes diagnosis" from bioinformatics and limited validation alone
