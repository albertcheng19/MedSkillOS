# Analysis Module Selection Rules

Choose only the modules that materially answer the user's question.

## Common Modules
- quality control and sample filtering
- normalization and batch handling
- primary contrast / differential analysis
- pathway and gene-set interpretation
- sample clustering or subtype discovery
- signature construction or score derivation
- clinical association or survival modeling
- treatment-response association or resistance-context comparison
- deconvolution or composition inference from bulk transcriptome
- multi-omics integration (correlation, concordance, latent factor, network, or pathway-level integration)
- external validation or replication analysis

## Selection Rules
- Do not include deconvolution unless the cell-composition question is relevant and the data are suitable.
- Do not include survival or response modeling without endpoint support.
- Do not include multi-omics integration unless at least two layers plausibly contribute distinct value.
- Prefer a connected narrative: differential signal → pathway logic → clinical or translational interpretation → validation.
