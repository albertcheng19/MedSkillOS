# Workload Configurations
# process-related-diagnostic-biomarker-nomogram-research-planner

---

## Lite

| Attribute | Detail |
|---|---|
| **Goal** | Rapid proof-of-concept process-related biomarker study |
| **Timeline** | 2–4 weeks |
| **Data** | One bulk dataset + one process gene-family resource |
| **Core Modules** | DEG, process intersection, enrichment, one limited PPI or model branch |
| **Validation** | Discovery-level only or one lightweight support branch |
| **Figure complexity** | 4–5 figures |
| **Strengths** | Executable fast; low barrier; establishes process-biomarker concept |
| **Weaknesses** | Limited validation and interpretation depth |

## Standard

| Attribute | Detail |
|---|---|
| **Goal** | Complete conventional process-related diagnostic biomarker paper |
| **Timeline** | 1–2 months |
| **Data** | One main bulk dataset + one validation or interpretation resource |
| **Core Modules** | All Lite modules + WGCNA or equivalent integration, feature selection, external validation, one interpretation branch |
| **Validation** | Public or second-bulk orthogonal support |
| **Figure complexity** | 7–8 figures |
| **Strengths** | Meets typical reviewer expectation for conventional diagnostic-biomarker papers |
| **Weaknesses** | Limited experimental certainty |

## Advanced

| Attribute | Detail |
|---|---|
| **Goal** | Competitive multi-layer process-related biomarker paper |
| **Timeline** | 2–3 months |
| **Data** | Standard data + machine-learning, nomogram, immune, and regulatory resources |
| **Core Modules** | All Standard + nomogram, calibration/DCA, immune infiltration, regulatory network, stronger validation logic |
| **Validation** | Multi-layer in silico support and richer reviewer-proofing |
| **Figure complexity** | 8–10 figures |
| **Strengths** | Better reviewer-proofing and richer biological context |
| **Weaknesses** | More complexity; higher risk of overinterpretation if not controlled |

## Publication+

| Attribute | Detail |
|---|---|
| **Goal** | High-ambition manuscript with maximum reviewer defensibility |
| **Timeline** | 3–6 months |
| **Data** | Advanced data + optional experimental support + stronger claim-boundary map |
| **Core Modules** | All Advanced + richer validation coherence, explicit downgrade map, optional experimental support |
| **Validation** | Maximum within comparative-bioinformatics scope without overclaiming mechanism |
| **Figure complexity** | 10–12 figures |
| **Strengths** | Reviewer-proof structure; strongest paper logic in this family |
| **Weaknesses** | Major time investment; still not equivalent to full mechanistic proof |

---

## Dependency Consistency Rules

### Core Principle
A downstream step may appear **only if its prerequisite data source, evidence layer, and method family have already been explicitly included** in that same configuration.

### Mandatory Dependency Rules

1. **WGCNA-dependent analyses** may appear only when the configuration explicitly includes module-integration logic.
2. **Machine-learning-dependent analyses** may appear only when the configuration explicitly includes feature-selection and validation rules.
3. **Nomogram-dependent analyses** may appear only when upstream biomarker selection and evaluation logic are already declared.
4. **Immune- and regulatory-dependent analyses** may appear only when those resources and upstream candidate-gene context are declared.
5. **Experimental-validation-dependent analyses** may appear only when animal model / qRT-PCR / protein resources are declared.
6. **Minimal Executable Version** must inherit only the modules declared in the Lite plan unless the skill explicitly states that this minimal version is being upgraded into a stronger variant.
