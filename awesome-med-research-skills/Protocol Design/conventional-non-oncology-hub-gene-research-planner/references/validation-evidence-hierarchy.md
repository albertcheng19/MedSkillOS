# Validation and Evidence Hierarchy
# conventional-non-oncology-hub-gene-research-planner

---

## Evidence Tiers

### Process-Signature Discovery Evidence (supportive — label explicitly as discovery)

| Evidence | Source | What It Establishes |
|---|---|---|
| Process-related DEGs | bulk DEG + process-gene intersection | disease-linked process signature |
| GO / KEGG enrichment | enrichment analysis | pathway-level relevance |
| GSEA | ranked-list pathway interpretation | broader pathway activation context |
| Batch-corrected dataset support | integrated discovery workflow | more coherent multi-dataset basis |

### Hub-Gene Prioritization Evidence (stronger — label explicitly as hub-gene evidence)

| Evidence | Source | What It Establishes |
|---|---|---|
| PPI network | interaction analysis | candidate interaction-supported structure |
| Multi-algorithm topological ranking | CytoHubba or equivalent | stronger hub-gene prioritization |
| Expression re-check of hub genes | within-discovery or merged dataset | coherent biomarker direction |

### Regulatory and Immune Interpretation Evidence (supportive — label explicitly as interpretation)

| Evidence | Source | What It Establishes |
|---|---|---|
| TF-gene / miRNA network | regulatory analysis | upstream/post-transcriptional context |
| ssGSEA immune infiltration | bulk immune estimation | immune-context linkage |
| Gene-immune correlation | correlation analysis | biomarker–immune association |

### Public-Validation Evidence (stronger — label explicitly as validation support)

| Evidence | Source | What It Establishes |
|---|---|---|
| ROC / AUC support | biomarker evaluation | diagnostic support, not clinical readiness |
| Multiple support views | expression + ROC + immune context | stronger biomarker coherence |
| Conservative multi-layer agreement | discovery + hub-gene + validation alignment | more credible candidate prioritization |

---

## Language Rules

- Discovery findings: "process-related DEGs", "hub-gene candidates", "pathway enrichment"
- Hub-gene findings: "interaction-supported biomarker", "topologically prioritized hub gene"
- Immune/regulatory findings: "suggests immune-context linkage", "supports regulatory relevance"
- Validation findings: "ROC support", "orthogonal biomarker support", "direction-consistent validation"

- **NEVER use:** "proves mechanism", "confirms therapeutic target", "establishes diagnosis" from bioinformatics and public validation alone
