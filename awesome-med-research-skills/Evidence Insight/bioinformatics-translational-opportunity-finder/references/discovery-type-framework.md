# Discovery Type Framework

Use this module to classify what kind of bioinformatics finding is being positioned for translation.

Primary classes:
- Single marker: one gene, protein-linked transcript, mutation, methylation locus, or comparable isolated feature
- Multi-feature signature: multi-gene score, classifier, risk model, or panel
- Pathway / activity score: pathway enrichment pattern, program score, functional module score
- Cell state / cell population finding: immune state, malignant subclone state, stromal program, cell abundance signal
- Molecular subtype: clustering-based subtype, latent class, molecular taxonomy group
- Genomic alteration pattern: mutation set, CNV profile, structural-variant pattern, mutational signature
- Regulatory or network-level finding: hub gene, regulatory axis, network module, master regulator inference
- Integrated multi-omics model: combined transcriptomic, epigenomic, proteomic, imaging, or clinicomolecular construct

Important rules:
- Distinguish the discovery type from the assay platform.
- Distinguish the discovery type from the proposed translational use case.
- Do not merge pathway-level findings with single-marker findings unless the paper truly treats them as the same unit.
