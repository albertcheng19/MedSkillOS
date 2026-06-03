# Workflow Step Template

Each workflow step must include all fields below.

## Dataset Disclaimer Rule
Whenever datasets, cohorts, repositories, disease databases, public resources, or structure sources are mentioned, the following disclaimer must appear immediately before the workflow steps:

> **Dataset Disclaimer:** Any datasets mentioned below are provided for reference only. Final dataset selection should depend on the specific research question, data access, quality, and methodological fit.

## Required fields for every step
1. **Step name**
2. **Objective**
3. **Inputs required**
4. **Methods / tools**
5. **Output produced**
6. **Dependency formula**
7. **Evidence tier reached**
8. **Critical interpretation constraint**

## Example dependency formulas
- compound identifier + structure source + synonym harmonization
- compound targets + disease / phenotype targets + overlap logic
- overlap genes + STRING/Cytoscape + hub metric selection
- overlap genes or hubs + enrichment engine + pathway database
- core hubs + protein structures + docking engine
- core hubs + public disease transcriptome + cross-check rule
- integrated evidence + literature synthesis + claim downgrade
