# Workload Configurations
# dual-disease-shared-transcriptome-biomarker-research-planner

---

## Lite

| Attribute | Detail |
|---|---|
| **Goal** | Rapid preliminary study; proof-of-concept dual-disease shared-biomarker plan |
| **Timeline** | 2–4 weeks |
| **Data** | 1 discovery cohort for disease A + 1 discovery cohort for disease B with case-control comparison |
| **Core Modules** | Per-disease DEG, strict overlap or concordance rule, enrichment, one prioritization route, limited interpretation |
| **Validation** | Within-dataset consistency check only |
| **Figure complexity** | 4–5 figures: workflow, per-disease DEG landscape, overlap summary, basic utility plot, limited interpretation |
| **Strengths** | Executable fast; low barrier; establishes shared-endpoint logic |
| **Weaknesses** | No strong external validation; limited reviewer defensibility |
| **Typical target** | Pilot report; early feasibility work; lower-tier journal preparation |

---

## Standard

| Attribute | Detail |
|---|---|
| **Goal** | Complete dual-disease conventional bioinformatics biomarker paper |
| **Timeline** | 1–2 months |
| **Data** | 1 discovery cohort per disease + 1 independent validation cohort per disease if available; optional immune or portal support |
| **Core Modules** | All Lite modules + PPI prioritization, dual-disease diagnostic evaluation, lead-gene or compact-hub compression, one immune or pathway layer, external validation |
| **Validation** | External bulk validation in one or both diseases; asymmetry must be stated if incomplete |
| **Figure complexity** | 7–8 figures (see figure plan) |
| **Strengths** | Meets typical reviewer expectation for conventional shared-biomarker papers |
| **Weaknesses** | Still largely association-based; mechanistic confidence remains limited |
| **Typical target** | Mid-tier journals (BMC / Frontiers / IJMS-type space) |

---

## Advanced

| Attribute | Detail |
|---|---|
| **Goal** | Competitive journals; stronger shared-endpoint defensibility and interpretation depth |
| **Timeline** | 2–3 months |
| **Data** | Standard data + richer dual-disease validation cohorts or orthogonal protein / portal support |
| **Core Modules** | All Standard + stronger candidate-compression logic, immune robustness or richer orthogonal support, better claim-boundary management |
| **Validation** | Broader cross-cohort or cross-tool consistency + orthogonal plausibility support |
| **Figure complexity** | 8–10 figures; more integrated summary figures |
| **Strengths** | Stronger reviewer-facing rigor; better shared-biology framing |
| **Weaknesses** | More moving parts; higher risk of overclaiming if not tightly controlled |
| **Typical target** | Mid-to-high tier translational / bioinformatics journals |

---

## Publication+

| Attribute | Detail |
|---|---|
| **Goal** | High-ambition manuscript with maximum reviewer defensibility |
| **Timeline** | 3–6 months |
| **Data** | Multiple external cohorts + richer orthogonal support + tissue or functional validation if available |
| **Core Modules** | All Advanced + stronger endpoint compression, tighter evidence labeling, clearer limitation handling, optional tissue / functional follow-up with one final lead gene |
| **Validation** | Maximum: multi-cohort + orthogonal + translational support chain |
| **Figure complexity** | 10–12 figures; publication-quality integrated endpoint schematic |
| **Strengths** | Reviewer-proof structure; strongest paper logic in this family |
| **Weaknesses** | Major time investment; not suitable if validation resources are weak |
| **Typical target** | High-ambition translational journals |

---

## Config Selection Decision Tree

```
User wants results in < 1 month, public data only?
  → Lite (or Standard if output quality is critical)

User wants a conventional dual-disease shared-biomarker paper?
  → Standard (primary); Advanced (if timeline allows)

User mentions stronger reviewer-proofing, multiple validations, or orthogonal support?
  → Advanced

User mentions tissue / functional validation, stronger publication target, or one final lead gene with translational support?
  → Publication+

User doesn't specify?
  → Default: Standard as primary, Lite as minimum, Advanced as upgrade path
```

---

## Dependency Consistency Rules

### Core Principle
A downstream step may appear **only if its prerequisite data source, evidence layer, and method family have already been explicitly included** in that same configuration.

### Mandatory Dependency Rules

1. **External-validation-dependent analyses** may appear only when the configuration explicitly includes at least one of:
   - independent validation cohort for disease A
   - independent validation cohort for disease B
   - portal-based orthogonal resource
   - protein support
   - institutional tissue cohort

2. If a configuration is defined as **bulk-expression-only**, then downstream steps must remain limited to:
   - per-disease DEG
   - overlap / concordance screening
   - PPI / prioritization
   - enrichment
   - limited immune or pathway association context

   and must **not** introduce:
   - tissue validation
   - cell functional assays
   - protein-level conclusions without protein resource
   - mechanistic claims unsupported by functional evidence

3. **Minimal Executable Version** must inherit only the modules declared in the Lite plan unless the skill explicitly states that this minimal version is being upgraded into a stronger variant.

4. **Publication Upgrade Version** may add new dependency-bearing modules, but each newly added module must be labeled as:
   - newly introduced
   - why it is being added
   - what new evidence tier it enables

### Required Self-Check Questions
Before finalizing any output, verify:
- Does any step require data that was never declared earlier?
- Does any lead-gene prioritization step assume evidence absent from the configuration?
- Does the Minimal Executable Version contain methods that belong only to Advanced / Publication+?
- Are all endpoint formulas logically valid given the available inputs?

If the answer to any of the above is yes, the plan must be revised before output.

### Intersection Formula Reference

Every endpoint-selection step must declare its exact logic formula. Valid examples:
- same-direction DEG overlap only
- same-direction DEG overlap ∩ PPI hubs
- same-direction DEG overlap ∩ PPI hubs ∩ ROC support in both diseases
- concordant ranked candidates ∩ PPI hubs ∩ external consistency

The skill must not switch from one formula to another silently.
