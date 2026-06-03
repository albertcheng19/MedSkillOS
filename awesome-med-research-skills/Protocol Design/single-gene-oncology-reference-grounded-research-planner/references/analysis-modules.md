# Analysis Module Library
# single-gene-oncology-reference-grounded-research-planner-aligned

---

## Cancer and Target-Gene Architecture Modules

| Module | Purpose | When Required |
|---|---|---|
| Cancer-cohort declaration | Define primary tumor cohorts or portal sources | Always |
| Target-gene declaration | Fix the single-gene anchor and prevent silent feature expansion | Always |
| Validation-support declaration | Define external cohort, portal, or protein-level support resources | Standard+ |
| Immune-analysis resource declaration | Define immune estimation or checkpoint context source | Pattern C / Standard+ |
| Genomic / epigenetic resource declaration | Define CNV, mutation, methylation, or proteomic source | Pattern D / Standard+ |
| Drug-context resource declaration | Define drug-sensitivity hypothesis resource if requested | Pattern D / Advanced+ |

### Cohort Declaration and Reference Block

| Item | Required Content |
|---|---|
| Primary cancer cohorts | source, tumor vs normal availability, sample counts |
| Survival endpoints | OS, DSS, PFI, RFS, or equivalent |
| Validation resources | independent cohort, portal, HPA/CPTAC/TMA, or equivalent |
| Immune resources | TIMER, ssGSEA, checkpoint panel, or equivalent |
| Genomic / epigenetic resources | cBioPortal, methylation portal, CPTAC, or equivalent |

> **Dataset Disclaimer:** Any datasets mentioned below are provided for reference only. Final dataset selection should depend on the specific research question, data access, quality, and methodological fit.

---

## Core Discovery Modules

| Module | Purpose | When Required |
|---|---|---|
| Tumor-vs-normal expression analysis | Establish baseline expression direction | Always |
| Clinical subgroup expression review | Compare by stage, grade, nodal status, subtype, or relevant strata | Lite+ |
| Survival association | Assess prognostic support conservatively | Standard+ |
| Functional interpretation | Link the target gene to pathways or co-expression context | Lite+ |
| Co-expression / pathway shortlist | Support downstream interpretation without drifting into genome-wide discovery | Standard+ |

## Immune, Genomic, and Validation Modules

| Module | Purpose | When Required |
|---|---|---|
| Immune infiltration association | Estimate immune-context linkage | Pattern C / Standard+ |
| Immune-checkpoint correlation | Add clinically relevant immune context | Pattern C / Standard+ |
| CNV / mutation context | Explore genomic alteration support | Pattern D / Standard+ |
| Methylation / protein context | Add epigenetic or orthogonal abundance support | Pattern D / Advanced+ |
| Drug-sensitivity hypothesis branch | Generate conservative therapy-response hypotheses | Pattern D / Advanced+ |
| Claim-boundary summary | Separate biomarker support from mechanistic proof | Always |
