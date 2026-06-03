# Analysis Module Library
# non-tumor-mechanism-guided-diagnostic-ml-research-planner-aligned

---

## Dataset, Mechanism, and Model Architecture Modules

| Module | Purpose | When Required |
|---|---|---|
| Discovery dataset declaration | Define primary bulk expression datasets | Always |
| Multi-dataset merge and batch correction | Improve cross-dataset integration when >1 dataset is used | Standard+ |
| Mechanism-gene-family declaration | Make pyroptosis / oxidative stress / custom biology theme explicit when used | Optional but mandatory if mechanism-guided |
| Validation-support declaration | Define external validation or within-study support resources | Standard+ |
| Immune-analysis resource declaration | Define ssGSEA / immune-signature estimation plan | Pattern D / Standard+ |
| Regulatory-resource declaration | Define TF / miRNA network sources | Pattern D / Advanced+ |

### Dataset Declaration and Reference Block

| Item | Required Content |
|---|---|
| Discovery datasets | source, sample groups, platform, case/control counts |
| Batch-correction plan | whether multiple datasets are merged and how |
| Mechanism-gene source | GeneCards / PubMed / MSigDB / curated source, if used |
| Validation resources | external cohort, hold-out logic, or orthogonal support |
| Immune / regulatory resources | ssGSEA / TF / miRNA tools used |

> **Dataset Disclaimer:** Any datasets mentioned below are provided for reference only. Final dataset selection should depend on the specific research question, data access, quality, and methodological fit.

---

## Core Discovery and Modeling Modules

| Module | Purpose | When Required |
|---|---|---|
| DEG analysis | Identify disease-associated differential expression | Always |
| Mechanism-gene intersection | Focus on mechanism-relevant candidate genes | Pattern A |
| Candidate shortlist construction | Reduce noise before modeling | Lite+ |
| Feature selection | Shrink candidate set into model-ready features | Always |
| Diagnostic model construction | Build the predictive signature | Always |
| ROC / AUC evaluation | Assess classification support conservatively | Pattern C / Lite+ |
| Calibration / DCA review | Evaluate agreement and decision utility | Pattern C / Standard+ |

## Interpretation and Validation Modules

| Module | Purpose | When Required |
|---|---|---|
| GO / KEGG / GSEA interpretation | Describe biological context around shortlisted genes | Standard+ |
| mRNA-TF regulatory network | Explore transcriptional regulatory context | Pattern D / Advanced+ |
| mRNA-miRNA regulatory network | Add post-transcriptional interpretation layer | Pattern D / Advanced+ |
| ssGSEA immune infiltration | Estimate immune-cell abundance differences | Pattern D / Standard+ |
| External expression / model validation | Confirm direction and model coherence | Pattern E / Standard+ |
| Claim-boundary summary | Separate model support from clinical deployment | Always |
