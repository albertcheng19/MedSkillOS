# Workload Configurations
# conventional-oncology-hub-gene-research-planner

---

## Lite

| Attribute | Detail |
|---|---|
| **Goal** | Rapid preliminary study; proof-of-concept conventional tumor biomarker plan |
| **Timeline** | 2–4 weeks |
| **Data** | 1 discovery bulk cohort (TCGA-like or GEO) with tumor-normal comparison and/or survival endpoint |
| **Core Modules** | DEG, limited survival screening, one prioritization route, enrichment, one lightweight interpretation branch at most |
| **Validation** | Within-dataset consistency check only |
| **Figure complexity** | 4–5 figures: workflow, expression landscape, candidate funnel, basic utility plot, limited interpretation |
| **Strengths** | Executable fast; low barrier; establishes basic endpoint logic |
| **Weaknesses** | No strong external validation; limited reviewer defensibility |
| **Typical target** | Pilot report; early feasibility work; lower-tier journal preparation |

---

## Standard

| Attribute | Detail |
|---|---|
| **Goal** | Complete conventional bioinformatics biomarker paper |
| **Timeline** | 1–2 months |
| **Data** | 1 discovery bulk cohort + 1 independent bulk validation cohort + clinical metadata; optional HPA / portal support |
| **Core Modules** | All Lite modules + Cox-based prognostic evaluation or risk-model route, PPI prioritization, diagnostic/prognostic assessment, clinical association, one immune or methylation interpretation layer, external validation |
| **Validation** | External bulk or orthogonal portal / protein support |
| **Figure complexity** | 7–8 figures (see figure plan) |
| **Strengths** | Meets typical reviewer expectation for conventional retrospective biomarker papers |
| **Weaknesses** | Still largely association-based; limited mechanistic confidence |
| **Typical target** | Mid-tier journals (Frontiers, BMC, IJMS-type space) |

---

## Advanced

| Attribute | Detail |
|---|---|
| **Goal** | Competitive journals; stronger endpoint defensibility and interpretation depth |
| **Timeline** | 2–3 months |
| **Data** | Standard data + richer validation cohorts or protein / portal / methylation support + stronger clinical annotations |
| **Core Modules** | All Standard + stronger candidate-compression logic, multi-tool immune robustness or richer methylation context, better clinical independence testing, stronger orthogonal support |
| **Validation** | Broader cross-cohort or cross-tool consistency + protein/tissue plausibility |
| **Figure complexity** | 8–10 figures; more integrated summary figures |
| **Strengths** | Stronger reviewer-facing rigor; better translational framing |
| **Weaknesses** | More moving parts; higher risk of overclaiming if not tightly controlled |
| **Typical target** | Mid-to-high tier translational / oncology bioinformatics journals |

---

## Publication+

| Attribute | Detail |
|---|---|
| **Goal** | High-ambition manuscript with maximum reviewer defensibility |
| **Timeline** | 3–6 months |
| **Data** | Multiple external cohorts + richer clinical support + orthogonal portal/protein support + tissue or cell validation if available |
| **Core Modules** | All Advanced + stronger endpoint compression, tighter evidence labeling, clearer limitation handling, optional tissue/cell follow-up with one final lead gene |
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

User wants a conventional bioinformatics biomarker paper?
  → Standard (primary); Advanced (if timeline allows)

User mentions richer methylation support, multiple validations, or stronger reviewer-proofing?
  → Advanced

User mentions tissue/cell validation, stronger publication target, or one final lead gene with translational support?
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
   - GEO / TCGA independent validation cohort
   - portal-based orthogonal resource
   - HPA / protein support
   - institutional tissue cohort

2. If a configuration is defined as **bulk-expression-only**, then downstream steps must remain limited to:
   - DEG
   - survival / prognostic analyses
   - PPI / prioritization
   - enrichment
   - limited immune or methylation association context

   and must **not** introduce:
   - tissue validation
   - cell functional assays
   - protein-level conclusions without protein resource
   - methylation-driven regulatory claims without methylation resource

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
- DEG only
- DEG ∩ survival-associated genes
- DEG ∩ survival-associated genes ∩ PPI hubs
- DEG ∩ survival-associated genes ∩ PPI hubs ∩ external consistency

The skill must not switch from one formula to another silently.
