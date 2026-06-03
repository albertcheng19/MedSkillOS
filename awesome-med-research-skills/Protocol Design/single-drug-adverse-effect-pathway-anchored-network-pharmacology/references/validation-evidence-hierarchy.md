# Validation and Evidence Hierarchy
# single-drug adverse-effect network pharmacology planners

---

## Evidence Tiers

| Tier | What It Includes | What It Can Support | What It Cannot Support |
|---|---|---|---|
| **Tier 1** | Drug-target prediction and adverse-effect target collection | Candidate target-space definition | Real biological mechanism or clinical causality |
| **Tier 2** | Overlap genes and PPI / pathway prioritization | Hypothesis-focused target nomination | In vivo centrality or patient risk |
| **Tier 3** | Enrichment / pathway interpretation | Mechanistic plausibility at pathway level | Proof that the pathway is truly activated by the drug in patients |
| **Tier 4** | Molecular docking | Plausibility of interaction geometry / binding support | Validation of mechanism or toxicity causality |
| **Tier 5** | Orthogonal transcriptomic, literature, pharmacovigilance, or tissue support | Cross-source coherence and stronger reviewer defensibility | Full translational proof unless truly direct evidence is present |
| **Tier 6** | Wet-lab perturbation or direct functional assays | Stronger functional support | Broad clinical recommendation without appropriate human evidence |

## Required Wording Discipline

- Use "predictive", "putative", "candidate", "plausibility support", and "hypothesis-generating" where appropriate.
- Never say docking validates the network result.
- Never say hub status proves biological centrality.
- Never convert mechanism mapping into prescribing or medication-management advice.
- Never treat orthogonal public data support as equivalent to direct causal validation.
