# Method Library

Select methods according to data structure and the biological question.

## Core Frameworks
| Need | Preferred Options | Notes |
|---|---|---|
| scRNA processing / analysis | Seurat, Scanpy | Use one coherent framework unless there is a clear reason to mix |
| Annotation | marker-based curation, SingleR, CellTypist, reference mapping | Automated labels need manual biological review |
| DEG (cell-level, exploratory) | Wilcoxon, MAST | Match method to sparsity and model needs |
| Pseudobulk DEG with counts | DESeq2 | Preferred when replicate-aware count matrices are available |
| Pseudobulk DEG with non-count normalized data | limma | Preferred when the matrix is not raw counts |
| Pathway / enrichment | fgsea, GSVA, AUCell, UCell | Match gene-set and single-cell use case |
| Batch integration | Harmony, Seurat integration, BBKNN, scVI | Use only if necessary for the biological question |
| Trajectory | Monocle3, Slingshot | Choose based on topology and interpretability |
| RNA velocity | scVelo, velocyto-based workflows | Only for suitable data |
| Communication | CellChat, CellPhoneDB, LIANA, NicheNet | Interpret as inferred signaling |
| Regulon / TF activity | SCENIC, pySCENIC, DoRothEA/Viper-style approaches | Optional, not default |
| CNV inference | inferCNV, CopyKAT | Mostly context-specific for tumor studies |

## Method Selection Rule
Do not list multiple tools for every module unless comparison is necessary.
Prefer one default recommendation plus one reasonable alternative.
