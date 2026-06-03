# Workflow Step Template
# conventional-oncology-hub-gene-research-planner

---

## 8-Field Step Template

Every step in the workflow output (Section D) must include all 8 fields. Do not omit any field. Do not replace detailed method descriptions with bare tool name lists.


## Dataset Disclaimer Rule

If any workflow step mentions a dataset, cohort, database, registry, GWAS source, or public resource, the workflow section must begin with the following line exactly once before the first step:

> **Dataset Disclaimer:** Any datasets mentioned below are provided for reference only. Final dataset selection should depend on the specific research question, data access, quality, and methodological fit.

This disclaimer is mandatory whenever data sources are mentioned in the workflow and must not be omitted, paraphrased away, or moved to another section.

```
Step Name:        Short descriptive label
Purpose:          What this step accomplishes in the overall pipeline
Input:            Exact data / files / outputs from prior steps needed
Method:           Specific tool(s) and algorithm(s) — explain WHY this choice
                  over the main alternative(s)
Key Parameters /
Decision Rules:   Thresholds, cutoffs, acceptance criteria — be specific
Expected Output:  File format + content description + what "success" looks like
Failure Points:   What could go wrong; how to detect it; what it looks like
Alternative
Approaches:       Backup tool/method if primary fails or data doesn't support it
```

---

## Standard Step Sequence (adapt to selected pattern and config)

### Discovery and Screening Block

1. **Discovery Cohort Selection and Endpoint Harmonization**
2. **Tumor vs Normal Differential Expression**
3. **Candidate-Gene Survival Screening**
4. **Initial Functional Enrichment and Candidate Reduction**

### Model / Prioritization Block

5. **Risk-Model Route** (Pattern A / C)
6. **PPI Network Construction and Centrality Ranking** (Pattern B / C)
7. **Lead Endpoint Compression** (final signature, hub set, or one preferred lead gene)
8. **Diagnostic and Prognostic Utility Assessment**
9. **Clinical Subgroup and Independence Analysis**

### Interpretation and Validation Block

10. **Functional Enrichment / GSEA Interpretation**
11. **Immune Infiltration and Checkpoint Context**
12. **Methylation / Portal-Based Regulatory Context**
13. **External Bulk / Protein Validation**
14. **Tissue / Cell Validation**
15. **Integrated Evidence and Limitation Summary Figure**

---

## Step Ordering Rules

- Discovery block runs first to define the candidate universe.
- Risk-model and PPI routes may run in parallel only if both are explicitly declared in the same pattern.
- A final lead gene must not be selected before prioritization logic is complete.
- Immune and methylation modules should appear downstream of a fixed endpoint.
- Tissue / cell validation should appear only after a final lead endpoint is fixed.
- If the plan is data-only, translational language must remain conservative.

---

## Intersection Formula Requirement

Every step that prioritizes, filters, or selects genes must explicitly declare its logic formula. Do not omit this or switch formulas silently between configurations.

```
Intersection Formula: [e.g., DEG ∩ survival-associated genes ∩ PPI hubs]
Dependency Check:     [list what data/analyses this formula requires]
```

If a formula requires a resource not declared in the configuration (for example external validation or methylation support), use the reduced formula and note the limitation.

---

## Upgrade-Only Module Labeling

When the Step-by-Step Workflow for Advanced or Publication+ introduces a module not present in Lite/Standard, label it explicitly:

```
[UPGRADE-ONLY — Advanced+]
Module: e.g., Multi-tool immune robustness comparison
Newly Introduced: Yes
Reason for Addition: Reduces one-tool interpretation bias and strengthens reviewer defensibility
New Evidence Tier Enabled: Stronger association / utility support
```

Do not back-propagate upgrade-only modules into the Lite or Standard sections.
