# Validation and Evidence Hierarchy
# non-tumor-mechanism-guided-diagnostic-ml-research-planner-aligned

---

## Evidence Tiers

### Candidate-Restriction Evidence (supportive — label explicitly as discovery)

| Evidence | Source | What It Establishes |
|---|---|---|
| Disease-associated DEGs | bulk DEG analysis | disease-linked expression basis |
| Mechanism-related candidate genes | DEG + mechanism intersection | biologically restricted candidate set |
| Batch-corrected dataset support | integrated discovery workflow | more coherent multi-dataset basis |

### Model-Construction and Evaluation Evidence (stronger — label explicitly as model evidence)

| Evidence | Source | What It Establishes |
|---|---|---|
| Feature-selection results | shrinkage / ranking methods | reduced candidate set |
| Diagnostic model | logistic or other declared classifier | model structure |
| ROC / AUC support | classification evaluation | diagnostic support, not deployment readiness |
| Calibration / DCA | agreement and decision-utility review | stronger evaluation coherence |

### Regulatory and Immune Interpretation Evidence (supportive — label explicitly as interpretation)

| Evidence | Source | What It Establishes |
|---|---|---|
| TF-gene / miRNA network | regulatory analysis | upstream / post-transcriptional context |
| ssGSEA immune infiltration | bulk immune estimation | immune-context linkage |
| Gene-immune correlation | correlation analysis | biomarker–immune association |

### Public-Validation Evidence (stronger — label explicitly as validation support)

| Evidence | Source | What It Establishes |
|---|---|---|
| External expression / model validation | independent dataset support | direction-consistent validation |
| Multiple support views | expression + model + immune context | stronger biomarker coherence |
| Conservative multi-layer agreement | discovery + model + validation alignment | more credible candidate prioritization |

---

## Language Rules

- Discovery findings: "mechanism-related candidates", "disease-linked candidate genes"
- Model findings: "diagnostic support", "classification performance support"
- Immune/regulatory findings: "suggests immune-context linkage", "supports regulatory relevance"
- Validation findings: "external validation support", "direction-consistent validation"

- **NEVER use:** "proves diagnosis", "confirms clinical deployment", "establishes mechanism" from public bioinformatics and model evaluation alone
