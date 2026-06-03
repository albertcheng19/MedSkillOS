# Algorithm Notes

## Goal

This skill constructs an lncRNA-mRNA network from local ceRNA reference tables. It projects tripartite lncRNA-miRNA-mRNA evidence into a bipartite lncRNA-mRNA network.

## Core Logic

1. Read a target gene list, a target lncRNA list, or both.
2. Load one miRNA-mRNA table from the selected local dataset configuration.
3. Load one miRNA-lncRNA table from the selected local strictness level.
4. Filter the database rows by the provided target IDs.
5. Join both tables on shared miRNA identifiers.
6. Create a tripartite evidence table with columns `lncRNA`, `miRNA`, and `mRNA`.
7. Collapse the tripartite evidence into projected lncRNA-mRNA edges.
8. Keep only edges meeting the `min_shared_mirna` threshold.
9. Optionally drop low-frequency lncRNAs with `lncrna_freq_thresh`.
10. Build node degrees in the projected lncRNA-mRNA graph and generate the PDF plot.

## Statistical Logic

This workflow is database-driven. It does not estimate correlations or p-values from expression matrices.

The edge strength is represented by:

- `shared_miRNA_count`
- `shared_miRNAs`

An lncRNA-mRNA edge is kept when:

- `shared_miRNA_count >= min_shared_mirna`
- the lncRNA degree exceeds `lncrna_freq_thresh`

## Evidence Interpretation

- `lncrna_mirna_mrna_evidence.csv` is the auditable evidence layer.
- `lncrna_mrna_edges.csv` is the projected summary layer.
- Larger `shared_miRNA_count` values indicate stronger database support for the projected lncRNA-mRNA association.

## Assumptions

- The local reference tables are pre-downloaded and do not change during the run.
- The target IDs use the same symbol space as the local reference tables.
- The workflow is intended for candidate network retrieval, not mechanistic proof.

## Scope

This skill is appropriate for:

- Target-driven lncRNA-mRNA network lookup
- ceRNA-style candidate network retrieval from local tables
- Reproducible database-backed regulatory network reporting

This skill is not appropriate for:

- Expression-based inference
- Sample-level correlation modeling
- Differential expression analysis
- Clinical interpretation
