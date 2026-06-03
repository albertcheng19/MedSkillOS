# Workflow Step Template
# dual-disease-shared-transcriptome-biomarker-research-planner

---

## Mandatory 8-Field Template

Every step in Section D must follow this structure exactly.

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

1. **Disease-Pair Cohort Selection and Endpoint Harmonization**
2. **Disease A Differential Expression**
3. **Disease B Differential Expression**
4. **Shared-Candidate Generation and Direction-Concordance Check**
5. **Initial Functional Enrichment and Candidate Reduction**

### Model / Prioritization Block

6. **PPI Network Construction and Centrality Ranking** (Pattern B / C)
7. **Lead Endpoint Compression** (final hub set or one preferred lead gene)
8. **Diagnostic Utility Assessment in Disease A and Disease B**
9. **External Dual-Disease Validation**

### Interpretation and Validation Block

10. **Functional Enrichment / Single-Gene GSEA Interpretation**
11. **Immune Infiltration and Lead-Gene Immune Correlation**
12. **Orthogonal Protein / Portal Context**
13. **Tissue / Functional Validation**
14. **Integrated Evidence and Limitation Summary Figure**

---

## Step Ordering Rules

- Both per-disease DEG branches run before any shared-candidate claim.
- Shared-candidate generation must occur before PPI or lead-gene compression.
- A final lead gene must not be selected before prioritization logic is complete.
- Immune and pathway modules should appear downstream of a fixed endpoint.
- Tissue / functional validation should appear only after a final lead endpoint is fixed.
- If the plan is data-only, translational language must remain conservative.

---

## Intersection Formula Requirement

Every step that prioritizes, filters, or selects genes must explicitly declare its logic formula. Do not omit this or switch formulas silently between configurations.

```
Intersection Formula: [e.g., same-direction DEG overlap ∩ PPI hubs]
Dependency Check:     [list what data/analyses this formula requires]
```

If a formula requires a resource not declared in the configuration (for example external validation or protein support), use the reduced formula and note the limitation.

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
