# Study Patterns — Detailed Logic
# conventional-oncology-hub-gene-research-planner

---

## Pattern A — Signature-First Prognostic Workflow

**Use when:** User starts from prognosis, risk stratification, or model-building needs.

**Canonical examples:** prognostic gene signature in LUAD, survival-prediction model in HCC,
risk score for gastric cancer.

**Logic chain:**
1. Select discovery cohort and survival endpoint
2. Perform tumor-normal DEG and/or survival candidate screening
3. Run univariate Cox
4. Apply LASSO / multivariable Cox to derive risk score
5. Validate KM and time-dependent ROC
6. Extend to nomogram, external validation, and limited biology interpretation

**Key design decision:** This pattern should stay model-centered unless an explicit compression step later narrows the story to one lead gene.

---

## Pattern B — Hub-Gene-First Biomarker Workflow

**Use when:** User wants one or a few clinically relevant biomarker genes.

**Canonical examples:** identify hub genes in colorectal cancer, screen lead biomarkers in HCC,
PPI-based lead-gene study in LUAD.

**Logic chain:**
1. Tumor-normal DEG analysis
2. Optional survival-associated gene filtering
3. PPI network construction
4. Centrality / overlap prioritization
5. Diagnostic and prognostic evaluation
6. Clinical association and pathway interpretation
7. Optional protein / portal support

**Key design decision:** A final lead gene should not be selected from a large candidate pool without a declared prioritization formula.

---

## Pattern C — Hybrid Signature-to-Hub Workflow

**Use when:** User wants a conventional paper with both prognostic rigor and one preferred final lead gene.

**Canonical examples:** risk-model-derived biomarker compression, signature plus one translational anchor gene,
prognostic narrowing followed by PPI and lead-gene selection.

**Logic chain:**
1. Candidate generation from DEG and/or survival analysis
2. Build or narrow through prognostic route
3. Use PPI / enrichment / clinical signal to compress candidates
4. Select one preferred lead gene
5. Add immune / methylation / portal context
6. Validate externally and optionally translationally

**Key design decision:** Compression from signature-scale candidates to one final gene must be justified explicitly, not narratively.

---

## Pattern D — Immune-Context Biomarker Workflow

**Use when:** User explicitly wants immune infiltration / checkpoint context around a lead endpoint.

**Canonical examples:** immune-associated hub gene in LUAD, checkpoint-related biomarker in gastric cancer,
bulk biomarker with TME interpretation.

**Logic chain:**
1. Fix the lead endpoint first (risk score, hub set, or one lead gene)
2. Perform immune infiltration scoring / deconvolution
3. Compare checkpoint expression and immune signatures
4. Optionally cross-check with multiple immune tools
5. Keep conclusions at immune-context association level

**Key design decision:** Immune analysis should be downstream of a defined endpoint and must not be written as proof of immunotherapy response.

---

## Pattern E — Translational Validation Workflow

**Use when:** User wants tissue or cell validation after computational prioritization.

**Canonical examples:** one final lead gene with qPCR and WB, hub gene plus cell assays,
publication-oriented translational follow-up.

**Logic chain:**
1. Complete one coherent computational prioritization path
2. Select one final lead gene
3. Confirm directionality in protein / tissue resources or local samples
4. Design minimal wet-lab validation
5. Integrate phenotype results with conservative biological interpretation

**Key design decision:** This pattern requires a single fixed lead endpoint first; it cannot replace upstream prioritization.

---

## Pattern Combination Rules

| Combination | When Appropriate |
|---|---|
| A + C | Risk-model logic plus one final translational anchor gene |
| B + D | Lead biomarker plus immune-context interpretation |
| B + E | Hub-gene biomarker plus tissue / cell validation |
| C + D | Hybrid signature-to-hub plus immune-context support |
| C + E | Hybrid signature-to-hub plus translational follow-up |

Combining > 2 patterns typically requires Advanced or Publication+ workload.
