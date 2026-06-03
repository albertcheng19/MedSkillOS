# Topic Unit Framework

Use this module to define the exact biomedical topic unit under review.

The topic unit should be specific enough that saturation can be judged meaningfully.
A topic that is too broad will produce false crowding and false whitespace at the same time.

## Recommended Topic-Unit Components

Define the topic using as many of the following as needed:
- disease / condition / biological context
- population / stage / treatment setting
- biomarker / target / pathway / mechanism / method angle
- specimen / platform / modality when relevant
- endpoint / claim type / translational use case
- intended research layer: exploratory, validation, mechanistic, translational, implementation-oriented

## Common Topic-Unit Types

### Disease-angle topic
Examples:
- immunotherapy response biomarkers in NSCLC
- spatial transcriptomics in IBD

### Disease + method-template topic
Examples:
- prognostic gene signatures in ccRCC
- machine-learning survival models in sepsis cohorts

### Disease + mechanism / pathway topic
Examples:
- STING-pathway resistance in melanoma
- ferroptosis-associated progression mechanisms in HCC

### Disease + translational subspace topic
Examples:
- blood-based MRD in colorectal cancer
- liquid-biopsy early detection in pancreatic cancer

## Important Rules

- Do not assess saturation at the disease-only level unless the user explicitly asks for a very broad scan.
- Do not merge adjacent but non-equivalent subtopics into one topic unit.
- Distinguish mechanism space, biomarker space, model-template space, and translation space when they behave as different competitive arenas.
- If the initial request is too broad, narrow it before formal saturation judgment.
