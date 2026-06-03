# Biomarker Type Taxonomy

Use this module to classify biomarker modality/type.

Primary classes:
- Genomic: mutation, CNV, methylation, structural variant, TMB-like genomic burden
- Transcriptomic: mRNA, lncRNA, miRNA, gene-set score, expression signature
- Proteomic: tissue protein, serum protein, cytokine panel, phosphoprotein
- Metabolomic / lipidomic
- Cellular / immunologic: cell subset abundance, immune phenotype, flow/cytometry-derived marker
- Liquid biopsy: ctDNA, cfDNA methylation, CTC, exosome cargo
- Pathology / histomorphology / digital pathology
- Imaging / radiomic
- Clinical / composite score
- Multi-omics / multimodal integrated model

Important rules:
- Distinguish **single analyte** from **signature/panel/model**.
- Distinguish **biological target** from **assay output** when needed.
- Do not merge biomarkers that share a pathway but differ in assay, specimen, or construction.
