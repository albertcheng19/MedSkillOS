# Validation and Evidence Hierarchy
# generic-phenotype-scoring-research-planner

---

## Evidence Tiers

### Signature Discovery Evidence (supportive — label explicitly as discovery)

| Evidence | Source | What It Establishes |
|---|---|---|
| Signature-related DEGs | bulk DEG + signature-gene intersection | disease-linked signature pattern |
| GO / KEGG enrichment | enrichment analysis | pathway relevance around signature |
| PPI position | network analysis | interaction-supported feature centrality |

### Phenotype-Scoring and Diagnostic Evidence (stronger — label explicitly as scoring / diagnostic)

| Evidence | Source | What It Establishes |
|---|---|---|
| z-score / GSVA phenotype score | scoring workflow | per-sample signature activity pattern |
| High/low group comparison | score-stratified analysis | phenotype-linked downstream differences |
| Feature-selection / classifier result | SVM-RFE / Random Forest / equivalent | potential diagnostic or stratification value, not clinical readiness |

### Immune and Cellular-Resolution Evidence (supportive — label explicitly as interpretation)

| Evidence | Source | What It Establishes |
|---|---|---|
| ssGSEA immune association | bulk immune estimation | immune-context linkage |
| scRNA cell-level score | single-cell analysis | which cell types carry signature activity |
| Cell-type proportion shifts | scRNA cluster comparison | cellular-context association |

### Experimental-Support Evidence (stronger — label explicitly as experimental support)

| Evidence | Source | What It Establishes |
|---|---|---|
| second-bulk validation | orthogonal dataset | reproducible expression direction |
| qRT-PCR validation | small lab validation | orthogonal expression support |
| limited cell/tissue confirmation | experimental add-on | preliminary translational plausibility |

---

## Language Rules

- Discovery findings: "signature-related DEGs", "signature genes", "pathway-linked candidates"
- Scoring findings: "phenotype score", "score-associated pattern", "diagnostic potential"
- Immune/cell findings: "suggests immune-context linkage", "cell-level enrichment", "cluster-specific signature activity"
- Validation findings: "orthogonal support", "direction-consistent validation"

- **NEVER use:** "proves mechanism", "confirms diagnosis", "establishes treatment target" from bioinformatics and limited validation alone
