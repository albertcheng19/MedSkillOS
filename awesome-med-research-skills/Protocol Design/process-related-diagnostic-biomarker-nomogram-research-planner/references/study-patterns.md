# Study Patterns — Detailed Logic
# process-related-diagnostic-biomarker-nomogram-research-planner

---

## Pattern A — Process-DEG Discovery Workflow

**Use when:** User wants disease DEGs intersected with a process-related gene family.

## Pattern B — Co-Expression Module Integration Workflow

**Use when:** User wants WGCNA or other module-level disease association added to candidate screening.

## Pattern C — Machine-Learning Biomarker Selection Workflow

**Use when:** User wants LASSO / RF / RFE or similar feature-selection logic.

## Pattern D — Diagnostic Model and Nomogram Workflow

**Use when:** User wants ROC, nomogram, calibration, and decision-curve analysis.

## Pattern E — Immune-Regulatory Interpretation and Validation Workflow

**Use when:** User wants immune infiltration, regulatory networks, and orthogonal validation.

---

## Pattern Combination Rules

| Combination | When Appropriate |
|---|---|
| A + B | process-DEG discovery plus module integration |
| B + C | module-supported candidates plus machine-learning selection |
| C + D | feature-selected biomarkers plus diagnostic-model workflow |
| C + E | biomarker selection plus immune / regulatory interpretation |
| A + B + E | process discovery plus module support plus immune-focused interpretation |
