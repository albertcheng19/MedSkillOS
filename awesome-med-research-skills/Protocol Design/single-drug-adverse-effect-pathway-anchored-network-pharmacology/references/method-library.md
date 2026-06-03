# Method Library
# single-drug-adverse-effect-pathway-anchored-network-pharmacology-research-planner

---

## Recommended Method Families

### Target Collection
- DrugBank, SwissTargetPrediction, PharmMapper, STITCH, ChEMBL, BindingDB, or comparable curated / predictive sources
- Endpoint target resources such as GeneCards, DisGeNET, CTD, OMIM, TTD, MalaCards, or literature-curated lists
- Identifier harmonization via official gene symbol / UniProt mapping

### Pathway Anchoring
- clusterProfiler, g:Profiler, DAVID, Metascape, Enrichr, Reactome, or equivalent tools
- Use pathway selection rules that favor biological interpretability over raw p-value ranking alone
- Document why the anchored pathway set was chosen and how core targets were nominated from it

### PPI and Supportive Prioritization
- STRING or equivalent PPI resource
- Cytoscape + cytoHubba / NetworkAnalyzer may be used after pathway anchoring as supportive rather than primary evidence

### Docking
- PubChem / DrugBank / ChEMBL ligand structures
- PDB / AlphaFold / UniProt structure sources where appropriate
- AutoDock Vina, Schrödinger, Discovery Studio, MOE, or equivalent docking frameworks
- Document receptor choice, preparation steps, and score interpretation limits
