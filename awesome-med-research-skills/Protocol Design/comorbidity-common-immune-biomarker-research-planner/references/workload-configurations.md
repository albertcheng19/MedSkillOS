# Workload Configurations
# comorbidity-common-immune-biomarker-research-planner

---

## Lite

| Attribute | Detail |
|---|---|
| **Goal** | Rapid proof-of-concept comorbidity shared-biomarker study |
| **Timeline** | 2–4 weeks |
| **Data** | Two disease-expression datasets with control groups |
| **Core Modules** | DEG analysis, overlap, enrichment, simple PPI/hub screen |
| **Validation** | Discovery-level only or one limited support branch |
| **Figure complexity** | 4–5 figures |
| **Strengths** | Executable fast; low barrier; establishes shared-biology concept |
| **Weaknesses** | Limited validation and interpretation depth |

## Standard

| Attribute | Detail |
|---|---|
| **Goal** | Complete conventional comorbidity biomarker paper |
| **Timeline** | 1–2 months |
| **Data** | Multi-dataset discovery + at least one validation resource |
| **Core Modules** | All Lite modules + hub-gene prioritization, external validation, one interpretation branch |
| **Validation** | Public-dataset orthogonal support |
| **Figure complexity** | 7–8 figures |
| **Strengths** | Meets typical reviewer expectation for conventional shared-biomarker bioinformatics papers |
| **Weaknesses** | Limited translational certainty |

## Advanced

| Attribute | Detail |
|---|---|
| **Goal** | Competitive multi-layer comorbidity bioinformatics paper |
| **Timeline** | 2–3 months |
| **Data** | Standard data + machine-learning, immune, and regulatory resources |
| **Core Modules** | All Standard + feature selection, immune infiltration, TF network, stronger prioritization logic |
| **Validation** | Richer public support and multi-layer interpretation |
| **Figure complexity** | 8–10 figures |
| **Strengths** | Better reviewer-proofing and richer biological context |
| **Weaknesses** | More complexity; higher risk of overinterpretation if not controlled |

## Publication+

| Attribute | Detail |
|---|---|
| **Goal** | High-ambition manuscript with maximum reviewer defensibility |
| **Timeline** | 3–6 months |
| **Data** | Advanced data + stronger validation coherence + reviewer-facing downgrade logic |
| **Core Modules** | All Advanced + richer validation coherence, clearer claim-boundary map, stronger biomarker prioritization structure |
| **Validation** | Maximum within comparative-bioinformatics scope without overclaiming mechanism |
| **Figure complexity** | 10–12 figures |
| **Strengths** | Reviewer-proof structure; strongest paper logic in this family |
| **Weaknesses** | Major time investment; still not equivalent to mechanistic proof |

---

## Dependency Consistency Rules

### Core Principle
A downstream step may appear **only if its prerequisite data source, evidence layer, and method family have already been explicitly included** in that same configuration.

### Mandatory Dependency Rules

1. **Hub-gene-dependent analyses** may appear only when the configuration explicitly includes overlap/shared-gene logic plus PPI or prioritization logic.
2. **Machine-learning-dependent analyses** may appear only when the configuration explicitly includes feature-selection and validation rules.
3. **Immune- and regulatory-dependent analyses** may appear only when the configuration explicitly includes those resources and upstream candidate-gene context.
4. **Validation-dependent analyses** may appear only when validation datasets and rules are declared.
5. **Minimal Executable Version** must inherit only the modules declared in the Lite plan unless the skill explicitly states that this minimal version is being upgraded into a stronger variant.
