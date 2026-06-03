# Method Library Rules

Map modules to concrete methods, but keep method choice proportional to the question.

## Recommended Method Anchors
- Bulk RNA-seq count differential analysis → **DESeq2** (default recommended)
- Non-count normalized transcriptomic matrix differential analysis → **limma**
- Proteomics differential analysis → limma or other platform-appropriate linear modeling framework
- Metabolomics differential analysis → platform-aware regression / limma-style framework after suitable preprocessing
- Pathway analysis → GSEA, fgsea, GSVA, ORA (choose based on ranking vs sample-level scoring need)
- Clinical association → generalized linear models, Cox models, Fine-Gray only if competing risk is explicitly relevant
- Subtype discovery → consensus clustering, NMF, or similar, only when sample size and stability are plausible
- Integration → correlation-based integration, pathway-level concordance, MOFA-style latent factor approaches, or network-support approaches when justified
- Deconvolution → CIBERSORTx, xCell, MCP-counter, EPIC, quanTIseq, or other fit-for-purpose methods with explicit limitations

## Hard Method Rule for Transcriptomics
Whenever transcriptomic differential analysis is included, explicitly state:
- **count data → DESeq2 (recommended default)**
- **non-count normalized data → limma**

Never leave this ambiguous.
