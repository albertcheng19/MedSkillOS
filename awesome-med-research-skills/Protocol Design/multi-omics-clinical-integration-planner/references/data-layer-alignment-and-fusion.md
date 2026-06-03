# Data-Layer Alignment and Fusion Rules

## Alignment first
Define how subjects, samples, timepoints, and specimen types align across:
- clinical variables
- transcriptomics
- proteomics
- metabolomics
- other omics layers

## Feature-reduction rule
Feature reduction should be question-driven:
- pathway/module scores for mechanism-linked interpretation
- supervised or stability-aware selection for prediction
- dimensionality reduction only when it improves tractability without obscuring meaning

## Fusion logic
- **Early fusion**: concatenate carefully selected features only when scales and missingness are manageable.
- **Intermediate fusion**: use latent representations or pathway/module summaries when dimensionality is high.
- **Late fusion**: combine layer-specific models when interpretability or data heterogeneity makes direct fusion risky.

## Interpretability rule
If the clinical use case requires explanation, do not default to opaque multimodal architectures.

## Simpler-route rule
If one omics layer plus clinical variables can answer the main question credibly, say so explicitly instead of forcing full multi-omics integration.
