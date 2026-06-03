# Validation and Evidence Hierarchy
# conventional-oncology-hub-gene-research-planner

---

## Evidence Tiers

### Association-Level Evidence (supportive — label explicitly as associative)

| Evidence | Source | What It Establishes |
|---|---|---|
| Tumor vs normal DEG | limma / DESeq2 / edgeR | Differential expression — not mechanism |
| Enrichment / pathway results | clusterProfiler / GSEA / GSVA | Functional annotation — not causal proof |
| Immune infiltration correlation | ssGSEA / TIMER / CIBERSORT / xCell | Immune-context association — not response truth |
| Expression–methylation association | UALCAN / MethSurv / cBioPortal | Regulatory plausibility — not causal regulation |
| Clinical subgroup correlation | stage / grade / subtype analyses | Clinical association — not independent prognostic proof |

### Prognostic-Level Evidence (stronger — label explicitly as prognostic)

| Evidence | Source | What It Establishes |
|---|---|---|
| Univariate Cox (p < 0.05) | survival R | Survival-associated gene or feature |
| Multivariable Cox | survival / rms | Independent prognostic contribution robust to included covariates |
| LASSO-Cox risk model | glmnet + survival | Prognostic score with reduced overfitting risk |
| KM survival separation | survminer | Group-level survival stratification |
| Time-dependent ROC / C-index | timeROC / rms | Prognostic discrimination performance |
| External survival validation | GEO / TCGA validation cohort | Replication of prognostic signal — not mechanism |

### Diagnostic / Translational Utility Evidence (supportive — label explicitly as utility-level)

| Evidence | Source | What It Establishes |
|---|---|---|
| Diagnostic ROC | expression-based ROC analysis | Tumor vs normal discrimination ability |
| Protein plausibility | HPA / CPTAC | Orthogonal expression support |
| Tissue-level validation | qPCR / WB | Local biological plausibility and directionality |
| Clinical integration / nomogram | rms | Applied prognostic presentation — not deployment readiness |

### Functional-Support Evidence (stronger — label explicitly as functional support)

| Evidence | Source | What It Establishes |
|---|---|---|
| CCK8 / colony formation | cell assays | Phenotype support related to growth |
| Transwell migration / invasion | cell assays | Phenotype support related to motility |
| Knockdown / overexpression follow-up | cell manipulation experiments | Stronger lead-gene functional support; still not full mechanism alone |

---

## Validation Coverage by Config

| Validation Layer | Lite | Standard | Advanced | Publication+ |
|---|---|---|---|---|
| Within-dataset consistency | ✅ | ✅ | ✅ | ✅ |
| External bulk cohort | — | ✅ | ✅ | ✅ |
| Protein / portal plausibility | — | ✅ | ✅ | ✅ |
| Multi-tool immune robustness | — | — | ✅ | ✅ |
| Detailed methylation support | — | — | ✅ | ✅ |
| Tissue-level validation | — | — | Optional | ✅ |
| Cell functional follow-up | — | — | Optional | ✅ |
| Strong reviewer-facing limitation handling | — | — | ✅ | ✅ |

---

## Article Coverage Matrix

| Pattern | Minimum Required Modules | Recommended Additional |
|---|---|---|
| Signature-first prognostic | DEG or survival candidate screen, Cox route, KM / ROC | External cohort, nomogram |
| Hub-gene-first biomarker | DEG, PPI prioritization, diagnostic/prognostic check | Clinical association, HPA |
| Hybrid signature-to-hub | Candidate reduction, prognostic route, hub compression | Immune / methylation, external validation |
| Immune-context biomarker | Lead endpoint, immune scoring, checkpoint context | Multi-tool immune robustness |
| Translational validation | One fixed lead endpoint, orthogonal support | Tissue or cell phenotype follow-up |

---

## Self-Critical Risk Review Template

Every output plan must include a risk review covering:

1. **Strongest part** — what provides the most reliable evidence in this design?
2. **Most assumption-dependent part** — what assumption, if wrong, collapses the story?
3. **Most likely false-positive source** — where does spurious signal most easily enter?
4. **Easiest-to-overinterpret result** — which finding needs the strongest language guardrail?
5. **Likely reviewer criticisms** — what will reviewers challenge first?
6. **Fallback plan** — if survival signal is weak or hub compression is unstable, what is the alternative design?

---

## Language Rules

- Prognostic findings: "associated with survival", "supports prognostic relevance", "independent prognostic value"
- Association findings: "associated with", "differentially expressed in", "correlated with"
- Translational findings: "supports clinical utility", "shows orthogonal validation"
- **NEVER use:** "proves", "demonstrates mechanism", "confirms causality" for association-level evidence
- **ALWAYS state:** which evidence tier each claim belongs to

---

## Dependency-Aware Validation Rules

Every validation step must declare:
1. **What it proves** — be specific and bounded
2. **What it does not prove** — state the limitation explicitly
3. **What it depends on** — list the required upstream data or analysis

If the declared dependency is absent from the configuration, that validation step **cannot appear** in the plan.

### Examples

| Validation Step | Proves | Does Not Prove | Depends On |
|---|---|---|---|
| Univariate / multivariable Cox | Survival association or independence | Biological mechanism | Clinical endpoint + expression matrix |
| External bulk cohort expression | Replication of association in second dataset | Causal replication | ≥1 independent validation cohort |
| Diagnostic ROC | Discrimination between tumor and normal | Prognostic relevance | Tumor / normal labels |
| Immune deconvolution | Immune-context association | Treatment-response truth | Bulk expression data + chosen immune tool |
| Tissue qPCR / WB | Orthogonal expression support | Functional necessity | Final lead endpoint + tissue / sample availability |
| CCK8 / transwell | Functional phenotype support | Full signaling mechanism | Final lead endpoint + experimental system |

### Forbidden Combinations (without declared dependency)

- Tissue or cell validation without a fixed final lead gene → **forbidden**
- Methylation interpretation without an actual methylation / portal resource → **forbidden**
- Independent prognostic claim without survival endpoint and covariates → **forbidden**
- Mechanistic statement from enrichment or immune association alone → **forbidden**
