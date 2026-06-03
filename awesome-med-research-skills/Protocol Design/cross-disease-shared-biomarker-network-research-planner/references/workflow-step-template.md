# Workflow Step Template
# cross-disease-shared-biomarker-network-research-planner

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
Input:            Exact datasets / gene lists / outputs from prior steps needed
Method:           Specific tool(s) and calculation logic — explain WHY this choice over the main alternative(s)
Key Parameters / Decision Rules:   Thresholds, cutoffs, acceptance criteria — be specific
Expected Output:  File format + content description + what "success" looks like
Failure Points:   What could go wrong; how to detect it; what it looks like
Alternative Approaches:       Backup tool/method if primary fails or data doesn't support it
```

---

## Standard Step Sequence (adapt to selected pattern and config)

1. **Disease-Pair Dataset Selection and Harmonization**
2. **Per-Disease DEG Analysis**
3. **Shared-DEG Intersection and Overlap Filtering**
4. **GO / KEGG Enrichment**
5. **PPI Network Construction and Hub-Gene Selection**
6. **Public Validation in GEPIA / TCGA / HPA**
7. **TF-Gene / TF-miRNA Network Analysis**
8. **Immune Infiltration and Drug-Gene Interaction Follow-Up**
9. **qRT-PCR / Experimental Validation**
10. **Integrated Evidence, Limitations, and Claim-Boundary Summary**
