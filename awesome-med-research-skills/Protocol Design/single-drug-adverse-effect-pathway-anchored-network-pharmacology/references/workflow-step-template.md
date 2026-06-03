# Workflow Step Template
# single-drug adverse-effect network pharmacology planners

---

## 8-Field Step Template

Every step in the workflow output (Section D) must include all 8 fields. Do not omit any field. Do not replace detailed method descriptions with bare tool-name lists.

## Dataset Disclaimer Rule

If any workflow step mentions a dataset, cohort, database, registry, structure resource, public resource, or pathway tool, the workflow section must begin with the following line exactly once before the first step:

> **Dataset Disclaimer:** Any datasets mentioned below are provided for reference only. Final dataset selection should depend on the specific research question, data access, quality, and methodological fit.

This disclaimer is mandatory whenever data sources are mentioned in the workflow and must not be omitted, paraphrased away, or moved to another section.

```text
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

### Core Evidence Block

1. Endpoint Framing and Drug Scope Definition
2. Drug-Target Collection and Harmonization
3. Adverse-Effect / Disease Target Collection and Harmonization
4. Overlap Target Definition
5. PPI / Pathway Anchoring and Target Prioritization

### Mechanism Block

6. GO / KEGG / Hallmark or Reactome Interpretation
7. Core-Target Nomination
8. Docking Preparation and Structure Selection
9. Molecular Docking and Interaction Summary
10. Mechanism Synthesis and Claim Boundary Audit

### Validation and Synthesis Block

11. Orthogonal Public Validation
12. Literature Triangulation
13. Optional Pharmacovigilance / Tissue / Experimental Follow-Up
14. Integrated Evidence and Limitation Summary Figure

## Dependency Formula Requirement

Every step that adds downstream interpretation must explicitly declare its logic formula. Do not omit this or switch formulas silently between configurations.

```text
Dependency Formula: [e.g., fixed drug + fixed adverse-effect endpoint + overlap targets + prioritization rule]
Dependency Check:   [list what data/analyses this formula requires]
```
