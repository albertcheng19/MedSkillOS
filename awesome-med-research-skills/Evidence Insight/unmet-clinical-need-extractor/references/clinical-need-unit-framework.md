# Clinical Need Unit Framework

Use this module to define the exact clinical need unit under review.

The need unit should be specific enough that the extracted unmet need can be tied to a real decision point, care failure, or workflow limitation.
A unit that is too broad will produce generic and inflated unmet-need statements.

## Recommended Clinical-Need Unit Components

Define the need unit using as many of the following as needed:
- disease / condition
- disease stage, line of therapy, or care phase
- population or subgroup
- workflow stage: screening, diagnosis, stratification, treatment selection, monitoring, relapse management, survivorship, implementation
- clinical decision point
- current tool / standard / pathway limitation
- intended research-value layer: biomarker, diagnostic, prognostic, response-prediction, monitoring, target/pathway, implementation

## Common Clinical-Need Unit Types

### Disease-stage need unit
Examples:
- early pancreatic cancer detection
- recurrence monitoring after resection in colorectal cancer

### Treatment-context need unit
Examples:
- immunotherapy selection in metastatic urothelial carcinoma
- treatment-response heterogeneity in first-line HCC therapy

### Workflow-gap need unit
Examples:
- sepsis risk stratification in early emergency presentation
- relapse detection after curative-intent therapy

## Important Rules

- Do not assess unmet need at the disease-only level unless the user explicitly requests a broad scan.
- Do not merge stage-specific and treatment-specific problems into one need unit.
- Distinguish care burden, workflow failure, and evidence-generation gaps when they behave as different problem classes.
- If the initial request is too broad, narrow it before formal extraction.
