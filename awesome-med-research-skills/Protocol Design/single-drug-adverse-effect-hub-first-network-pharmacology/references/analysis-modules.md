# Analysis Module Library
# single-drug-adverse-effect-hub-first-network-pharmacology-research-planner

---

## Core Evidence Modules

| Module | Purpose | When Required |
|---|---|---|
| Drug-target collection and harmonization | Define the candidate molecular target space for the fixed drug | Always |
| Adverse-effect / disease target collection | Define the endpoint-related biological target space | Always |
| Overlap target definition | Identify the shared candidate mechanism space | Always |
| PPI network construction | Place overlap targets into a network context | Lite+ |
| Topological hub ranking | Prioritize core targets using degree / betweenness / closeness / MCC or similar rules | Standard+ |

## Functional Context Modules

| Module | Purpose | When Required |
|---|---|---|
| GO / KEGG / Reactome enrichment | Summarize candidate biological processes and pathways linked to overlap or hub targets | Lite+ |
| GSEA / transcriptomic context | Add directionality support when public expression data are available | Advanced+ |
| Literature mechanism triangulation | Check whether prioritized hubs and pathways are biologically plausible in the endpoint context | Standard+ |
| Multi-database target consensus | Reduce single-resource bias in target collection | Advanced+ |

## Docking and Orthogonal Modules

| Module | Purpose | When Required |
|---|---|---|
| Structure-quality screening | Ensure selected receptor structures are biologically interpretable and technically usable | Advanced+ |
| Molecular docking | Evaluate binding-plausibility support for prioritized targets | Standard+ |
| Docking interaction annotation | Make docking outputs interpretable rather than only reporting scores | Standard+ |
| Public transcriptomic cross-check | Test whether nominated hubs/pathways are coherent with public perturbation or disease expression context | Advanced+ |
| Pharmacovigilance coherence | Add real-world signal consistency when relevant and available | Publication+ |
| Wet-lab or direct validation | Add stronger functional support after the computational story is fixed | Publication+ or user-requested |
