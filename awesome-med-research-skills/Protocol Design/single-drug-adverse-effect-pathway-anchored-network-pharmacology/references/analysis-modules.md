# Analysis Module Library
# single-drug-adverse-effect-pathway-anchored-network-pharmacology-research-planner

---

## Core Evidence Modules

| Module | Purpose | When Required |
|---|---|---|
| Drug-target collection and harmonization | Define the candidate molecular target space for the fixed drug | Always |
| Adverse-effect / disease target collection | Define the endpoint-related biological target space | Always |
| Overlap target definition | Identify the shared candidate mechanism space | Always |
| Enrichment-guided pathway anchoring | Identify the most biologically interpretable pathways before fixing core targets | Lite+ |
| Pathway-constrained core-target nomination | Select core targets from anchored pathways rather than topology alone | Standard+ |

## Context Modules

| Module | Purpose | When Required |
|---|---|---|
| PPI support after pathway anchoring | Check whether nominated pathway targets also occupy coherent network positions | Standard+ |
| GO / KEGG / Reactome enrichment refinement | Clarify pathway hierarchy and filter generic pathway noise | Lite+ |
| Literature mechanism triangulation | Check whether anchored pathways are biologically plausible in the endpoint context | Standard+ |
| Multi-database target consensus | Reduce single-resource bias in target collection | Advanced+ |

## Docking and Orthogonal Modules

| Module | Purpose | When Required |
|---|---|---|
| Structure-quality screening | Ensure selected receptor structures are biologically interpretable and technically usable | Advanced+ |
| Molecular docking | Evaluate binding-plausibility support for pathway-anchored core targets | Standard+ |
| Docking interaction annotation | Make docking outputs interpretable rather than only reporting scores | Standard+ |
| Public transcriptomic cross-check | Test whether anchored pathways / targets are coherent with public perturbation or disease expression context | Advanced+ |
| Pharmacovigilance coherence | Add real-world signal consistency when relevant and available | Publication+ |
| Wet-lab or direct validation | Add stronger functional support after the computational story is fixed | Publication+ or user-requested |
