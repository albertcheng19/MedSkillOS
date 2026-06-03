# Validation and Evidence Hierarchy
# cross-disease-shared-biomarker-network-research-planner

---

## Evidence Tiers

### Shared-Discovery Evidence (supportive — label explicitly as discovery)

| Evidence | Source | What It Establishes |
|---|---|---|
| Shared DEGs across diseases | overlap analysis | common expression signature across datasets |
| GO / KEGG enrichment | enrichment analysis | shared biological processes and pathways |
| PPI network position | STRING / Cytoscape | interaction-supported hub candidacy |

### Public-Validation Evidence (stronger — label explicitly as public validation)

| Evidence | Source | What It Establishes |
|---|---|---|
| GEPIA / TCGA expression validation | public cancer dataset | external consistency of expression direction |
| Survival association | public survival analysis | prognostic relevance in validation dataset |
| HPA protein support | public protein atlas | orthogonal expression plausibility |

### Interpretation-Layer Evidence (supportive — label explicitly as interpretation)

| Evidence | Source | What It Establishes |
|---|---|---|
| TF-gene / TF-miRNA network | NetworkAnalyst / related platforms | upstream regulatory context |
| Immune infiltration association | TIMER / similar tools | immune-context linkage |
| DGIdb interaction | drug-gene database | candidate follow-up relevance, not therapeutic proof |

### Experimental-Support Evidence (stronger — label explicitly as experimental support)

| Evidence | Source | What It Establishes |
|---|---|---|
| qRT-PCR direction consistency | cell or tissue validation | orthogonal expression support |
| Cell-line comparison | experimental model | limited translational plausibility |
| Small validation panel | limited experiment | preliminary support, not mechanism proof |

---

## Language Rules

- Discovery findings: "shared differential expression", "hub-gene candidate", "common pathway enrichment"
- Validation findings: "publicly validated expression pattern", "orthogonal protein support", "survival-associated"
- Interpretation findings: "suggests immune-context linkage", "supports regulatory-network relevance", "identifies candidate drug interactions"
- Experimental findings: "supports expression-direction consistency"

- **NEVER use:** "proves mechanism", "confirms target", "establishes therapy" from bioinformatics and limited validation alone
