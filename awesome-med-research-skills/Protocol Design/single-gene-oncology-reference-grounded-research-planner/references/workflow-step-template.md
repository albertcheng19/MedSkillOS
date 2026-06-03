# Workflow Step Template
# single-gene-oncology-reference-grounded-research-planner-aligned

---

## 8-Field Step Template

Every step in the workflow output (Section D) must include all 8 fields. Do not omit any field. Do not replace detailed method descriptions with bare tool name lists.

## Dataset Disclaimer Rule

If any workflow step mentions a dataset, cohort, database, portal, registry, or public resource, the workflow section must begin with the following line exactly once before the first step:

> **Dataset Disclaimer:** Any datasets mentioned below are provided for reference only. Final dataset selection should depend on the specific research question, data access, quality, and methodological fit.

This disclaimer is mandatory whenever data sources are mentioned in the workflow and must not be omitted, paraphrased away, or moved to another section.

```
Step Name:        Short descriptive label
Purpose:          What this step accomplishes in the overall pipeline
Input:            Exact cohorts / target gene / outputs from prior steps needed
Method:           Specific tool(s) and calculation logic — explain WHY this choice over the main alternative(s)
Key Parameters / Decision Rules:   Thresholds, cutoffs, acceptance criteria — be specific
Expected Output:  File format + content description + what "success" looks like
Failure Points:   What could go wrong; how to detect it; what it looks like
Alternative Approaches:       Backup tool/method if primary fails or data doesn't support it
```

---

## Standard Step Sequence (adapt to selected pattern and config)

1. **Cancer Cohort and Target-Gene Selection**
2. **Tumor-vs-Normal Expression Review**
3. **Clinicopathologic and Survival Analysis**
4. **Functional / Pathway Interpretation**
5. **Immune Infiltration and Checkpoint Correlation**
6. **Genomic / Epigenetic / Proteomic Context Review**
7. **External Validation or Orthogonal Support**
8. **Integrated Evidence, Limitations, and Claim-Boundary Summary**
