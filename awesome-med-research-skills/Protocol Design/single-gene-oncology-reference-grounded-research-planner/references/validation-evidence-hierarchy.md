# Validation and Evidence Hierarchy
# single-gene-oncology-reference-grounded-research-planner-aligned

---

## Evidence Tiers

### Expression and Prognostic Evidence (supportive — label explicitly as biomarker evidence)

| Evidence | Source | What It Establishes |
|---|---|---|
| Tumor-vs-normal expression | portal or cohort comparison | direction of differential abundance |
| Clinical subgroup expression | stratified comparison | context-linked variation |
| Survival association | KM / Cox support | prognostic association, not causality |
| Multi-cohort agreement | repeated directional support | stronger biomarker coherence |

### Functional and Immune Interpretation Evidence (supportive — label explicitly as interpretation)

| Evidence | Source | What It Establishes |
|---|---|---|
| Co-expression / pathway context | enrichment or ranked interpretation | pathway relevance |
| Immune infiltration correlation | immune-estimation analysis | immune-context linkage |
| Checkpoint correlation | predefined immune panel | immunologic association |

### Genomic / Epigenetic / Translational Context Evidence (supportive — label explicitly as context support)

| Evidence | Source | What It Establishes |
|---|---|---|
| CNV / mutation summary | cBioPortal or equivalent | alteration context |
| Methylation / protein support | methylation or proteomic resources | orthogonal abundance context |
| Drug-sensitivity association | pharmacogenomic resource | therapy-response hypothesis, not efficacy proof |

### Orthogonal Validation Evidence (stronger — label explicitly as validation support)

| Evidence | Source | What It Establishes |
|---|---|---|
| External transcriptomic support | GEO or independent cohort | direction-consistent validation |
| Protein / tissue support | HPA / CPTAC / TMA | orthogonal abundance support |
| Conservative multi-layer agreement | expression + prognosis + context + validation alignment | stronger candidate prioritization |

---

## Language Rules

- Expression findings: "overexpressed", "underexpressed", "direction-consistent biomarker signal"
- Prognostic findings: "associated with survival", "prognostic support"
- Immune findings: "suggests immune-context linkage", "supports checkpoint association"
- Genomic findings: "provides alteration context", "supports epigenetic association"
- Validation findings: "orthogonal support", "external validation coherence"

- **NEVER use:** "proves mechanism", "confirms therapeutic target", "establishes clinical utility" from public bioinformatics alone
