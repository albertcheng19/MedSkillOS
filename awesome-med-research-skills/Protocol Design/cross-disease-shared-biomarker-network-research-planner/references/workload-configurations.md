# Workload Configurations
# cross-disease-shared-biomarker-network-research-planner

---

## Lite

| Attribute | Detail |
|---|---|
| **Goal** | Rapid proof-of-concept cross-disease shared-biomarker study |
| **Timeline** | 2–4 weeks |
| **Data** | Two disease-expression datasets with control groups |
| **Core Modules** | DEG analysis, overlap, enrichment, simple PPI/hub screen |
| **Validation** | Discovery-level only or one limited public check |
| **Figure complexity** | 4–5 figures |
| **Strengths** | Executable fast; low barrier; establishes shared-biology concept |
| **Weaknesses** | Limited validation and interpretation depth |

## Standard

| Attribute | Detail |
|---|---|
| **Goal** | Complete conventional cross-disease biomarker paper |
| **Timeline** | 1–2 months |
| **Data** | Multi-dataset discovery + at least one public validation resource |
| **Core Modules** | All Lite modules + hub-gene prioritization, public validation, one interpretation branch |
| **Validation** | Public-database orthogonal support |
| **Figure complexity** | 7–8 figures |
| **Strengths** | Meets typical reviewer expectation for conventional shared-biomarker bioinformatics papers |
| **Weaknesses** | Limited experimental certainty |

## Advanced

| Attribute | Detail |
|---|---|
| **Goal** | Competitive multi-layer cross-disease bioinformatics paper |
| **Timeline** | 2–3 months |
| **Data** | Standard data + regulatory / immune / drug platforms + stronger public validation |
| **Core Modules** | All Standard + TF/miRNA network, immune infiltration, drug-gene screening, stronger prioritization logic |
| **Validation** | Richer public support and multi-layer interpretation |
| **Figure complexity** | 8–10 figures |
| **Strengths** | Better reviewer-proofing and richer biological context |
| **Weaknesses** | More complexity; higher risk of overinterpretation if not controlled |

## Publication+

| Attribute | Detail |
|---|---|
| **Goal** | High-ambition manuscript with maximum reviewer defensibility |
| **Timeline** | 3–6 months |
| **Data** | Advanced data + optional qRT-PCR / cell validation + stronger claim-boundary map |
| **Core Modules** | All Advanced + richer validation coherence, optional experimental support, reviewer-facing downgrade logic |
| **Validation** | Maximum within comparative-bioinformatics scope without overclaiming mechanism |
| **Figure complexity** | 10–12 figures |
| **Strengths** | Reviewer-proof structure; strongest paper logic in this family |
| **Weaknesses** | Major time investment; still not equivalent to full mechanistic proof |

---

## Dependency Consistency Rules

### Core Principle
A downstream step may appear **only if its prerequisite data source, evidence layer, and method family have already been explicitly included** in that same configuration.

### Mandatory Dependency Rules

1. **Hub-gene-dependent analyses** may appear only when the configuration explicitly includes overlap/shared-gene logic plus PPI or prioritization logic.
2. **Public-validation-dependent analyses** may appear only when the configuration explicitly includes TCGA / GEPIA / HPA / equivalent resources.
3. **Network- and immune-dependent analyses** may appear only when the configuration explicitly includes the relevant platforms and hub-gene backbone.
4. **Experimental-validation-dependent analyses** may appear only when qRT-PCR / cell-line / tissue resources are declared.
5. **Minimal Executable Version** must inherit only the modules declared in the Lite plan unless the skill explicitly states that this minimal version is being upgraded into a stronger variant.
