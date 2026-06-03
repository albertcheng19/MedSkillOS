# Study Patterns — Detailed Logic
# comorbidity-common-immune-biomarker-research-planner

---

## Pattern A — Shared-DEG Discovery Workflow

**Use when:** User wants the common differentially expressed genes across two related diseases.

## Pattern B — Hub-Gene Prioritization Workflow

**Use when:** User wants PPI-based key genes or central biomarkers.

## Pattern C — Machine-Learning Biomarker Selection Workflow

**Use when:** User wants LASSO / RF / feature-selection logic and biomarker ranking.

## Pattern D — Immune and Regulatory Interpretation Workflow

**Use when:** User wants immune infiltration plus gene-gene / TF-gene interpretation.

## Pattern E — Multi-Layer Validation Workflow

**Use when:** User wants external validation, ROC support, and orthogonal support layers.

---

## Pattern Combination Rules

| Combination | When Appropriate |
|---|---|
| A + B | shared-DEG discovery plus hub-gene prioritization |
| B + C | hub-gene study plus machine-learning biomarker selection |
| C + D | biomarker selection plus immune / regulatory interpretation |
| B + E | hub-gene study plus external biomarker validation |
| A + B + D | shared biomarkers plus immune-focused comorbidity interpretation |
