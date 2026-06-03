# Workload Configurations
# conventional-non-oncology-hub-gene-research-planner

---

## Lite

| Attribute | Detail |
|---|---|
| **Goal** | Rapid proof-of-concept non-oncology process-gene biomarker study |
| **Timeline** | 2–4 weeks |
| **Data** | One or two bulk datasets + one process gene-family resource |
| **Core Modules** | DEG, process intersection, enrichment, one limited PPI branch |
| **Validation** | Discovery-level only or one lightweight support branch |
| **Figure complexity** | 4–5 figures |
| **Strengths** | Executable fast; low barrier; establishes process-biomarker concept |
| **Weaknesses** | Limited validation and interpretation depth |

## Standard

| Attribute | Detail |
|---|---|
| **Goal** | Complete conventional non-oncology hub-gene biomarker paper |
| **Timeline** | 1–2 months |
| **Data** | One main bulk dataset or merged datasets + one validation or interpretation resource |
| **Core Modules** | All Lite modules + batch correction if needed, GSEA, hub-gene prioritization, ROC support, one interpretation branch |
| **Validation** | Public or within-study orthogonal support |
| **Figure complexity** | 7–8 figures |
| **Strengths** | Meets typical reviewer expectation for conventional non-oncology biomarker papers |
| **Weaknesses** | Limited translational certainty |

## Advanced

| Attribute | Detail |
|---|---|
| **Goal** | Competitive multi-layer non-oncology bioinformatics paper |
| **Timeline** | 2–3 months |
| **Data** | Standard data + immune and regulatory resources + stronger validation structure |
| **Core Modules** | All Standard + TF/miRNA network, immune infiltration, richer hub-gene prioritization coherence |
| **Validation** | Multi-layer public support and richer reviewer-proofing |
| **Figure complexity** | 8–10 figures |
| **Strengths** | Better reviewer-proofing and richer biological context |
| **Weaknesses** | More complexity; higher risk of overinterpretation if not controlled |

## Publication+

| Attribute | Detail |
|---|---|
| **Goal** | High-ambition manuscript with maximum reviewer defensibility |
| **Timeline** | 3–6 months |
| **Data** | Advanced data + stronger validation coherence + reviewer-facing downgrade logic |
| **Core Modules** | All Advanced + richer evidence layering, clearer claim-boundary map, stronger biomarker prioritization structure |
| **Validation** | Maximum within conventional public-bioinformatics scope without overclaiming mechanism |
| **Figure complexity** | 10–12 figures |
| **Strengths** | Reviewer-proof structure; strongest paper logic in this family |
| **Weaknesses** | Major time investment; still not equivalent to mechanistic proof |

---

## Dependency Consistency Rules

### Core Principle
A downstream step may appear **only if its prerequisite data source, evidence layer, and method family have already been explicitly included** in that same configuration.

### Mandatory Dependency Rules

1. **Batch-correction-dependent interpretations** may appear only when multiple datasets are explicitly merged and QC is declared.
2. **GSEA-dependent interpretations** may appear only when ranked-list pathway analysis is explicitly included.
3. **Hub-gene-dependent analyses** may appear only when the configuration explicitly includes process-gene and PPI logic.
4. **Regulatory- and immune-dependent analyses** may appear only when those resources and upstream candidate-gene context are declared.
5. **Validation-dependent analyses** may appear only when ROC or orthogonal validation rules are declared.
6. **Minimal Executable Version** must inherit only the modules declared in the Lite plan unless the skill explicitly states that this minimal version is being upgraded into a stronger variant.
