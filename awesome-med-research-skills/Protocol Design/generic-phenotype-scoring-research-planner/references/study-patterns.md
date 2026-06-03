# Study Patterns — Detailed Logic
# generic-phenotype-scoring-research-planner

---

## Pattern A — Signature Discovery Workflow

**Use when:** User wants disease DEGs intersected with a pathway / process / signature-related gene set.

## Pattern B — Phenotype-Scoring Workflow

**Use when:** User wants z-score / GSVA-like phenotype scores and high/low group comparisons.

## Pattern C — Feature-Selection Workflow

**Use when:** User wants machine-learning feature selection and diagnostic or stratification value evaluation.

## Pattern D — Immune and Cellular-Resolution Workflow

**Use when:** User wants immune infiltration plus scRNA-seq or cell-level pathway interpretation.

## Pattern E — Multi-Layer Validation Workflow

**Use when:** User wants PPI, TF/miRNA networks, orthogonal validation, and experimental support.

---

## Pattern Combination Rules

| Combination | When Appropriate |
|---|---|
| A + B | signature discovery plus phenotype scoring |
| A + C | signature discovery plus feature selection and classifier logic |
| B + D | phenotype scoring plus immune and cell-level interpretation |
| C + E | diagnostic features plus multi-layer validation |
| A + B + D | signature discovery plus scoring plus cellular-resolution follow-up |
