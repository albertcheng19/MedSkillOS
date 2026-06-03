# Workload Configurations
# generic-phenotype-scoring-research-planner

---

## Lite

| Attribute | Detail |
|---|---|
| **Goal** | Rapid proof-of-concept signature study |
| **Timeline** | 2–4 weeks |
| **Data** | One bulk dataset + one signature gene set |
| **Core Modules** | DEG, signature intersection, enrichment, one limited scoring or PPI branch |
| **Validation** | Discovery-level only or one lightweight support branch |
| **Figure complexity** | 4–5 figures |
| **Strengths** | Executable fast; low barrier; establishes signature concept |
| **Weaknesses** | Limited validation and interpretation depth |

## Standard

| Attribute | Detail |
|---|---|
| **Goal** | Complete conventional phenotype-oriented bioinformatics paper |
| **Timeline** | 1–2 months |
| **Data** | One main bulk dataset + one validation or interpretation resource |
| **Core Modules** | All Lite modules + phenotype scoring, immune infiltration or PPI branch, one orthogonal validation branch |
| **Validation** | Public or second-bulk orthogonal support |
| **Figure complexity** | 7–8 figures |
| **Strengths** | Meets typical reviewer expectation for conventional signature papers |
| **Weaknesses** | Limited experimental certainty |

## Advanced

| Attribute | Detail |
|---|---|
| **Goal** | Competitive multi-layer phenotype-signature paper |
| **Timeline** | 2–3 months |
| **Data** | Standard data + machine-learning, network, and scRNA or richer validation resources |
| **Core Modules** | All Standard + feature selection, diagnostic evaluation, TF/miRNA network, immune/cell-level interpretation |
| **Validation** | Multi-layer in silico support and richer reviewer-proofing |
| **Figure complexity** | 8–10 figures |
| **Strengths** | Better reviewer-proofing and richer biological context |
| **Weaknesses** | More complexity; higher risk of overinterpretation if not controlled |

## Publication+

| Attribute | Detail |
|---|---|
| **Goal** | High-ambition manuscript with maximum reviewer defensibility |
| **Timeline** | 3–6 months |
| **Data** | Advanced data + optional qRT-PCR / richer orthogonal validation |
| **Core Modules** | All Advanced + stronger validation coherence, explicit downgrade map, optional experimental support |
| **Validation** | Maximum within comparative-bioinformatics scope without overclaiming mechanism |
| **Figure complexity** | 10–12 figures |
| **Strengths** | Reviewer-proof structure; strongest paper logic in this family |
| **Weaknesses** | Major time investment; still not equivalent to full mechanistic proof |

---

## Dependency Consistency Rules

### Core Principle
A downstream step may appear **only if its prerequisite data source, evidence layer, and method family have already been explicitly included** in that same configuration.

### Mandatory Dependency Rules

1. **Phenotype-scoring-dependent analyses** may appear only when the configuration explicitly includes a declared signature-gene or feature set.
2. **Machine-learning-dependent analyses** may appear only when the configuration explicitly includes feature-selection and validation rules.
3. **Immune- and scRNA-dependent analyses** may appear only when the configuration explicitly includes those resources and upstream signature or candidate-gene context.
4. **Experimental-validation-dependent analyses** may appear only when qRT-PCR / cell or tissue resources are declared.
5. **Minimal Executable Version** must inherit only the modules declared in the Lite plan unless the skill explicitly states that this minimal version is being upgraded into a stronger variant.
