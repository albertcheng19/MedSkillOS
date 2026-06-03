# Method Library
# single-drug-adverse-effect-hub-first-network-pharmacology-research-planner

---

## Recommended Method Families

### Target Collection
- DrugBank, SwissTargetPrediction, PharmMapper, STITCH, ChEMBL, BindingDB, or comparable curated / predictive sources
- Endpoint target resources such as GeneCards, DisGeNET, CTD, OMIM, TTD, MalaCards, or literature-curated lists
- Identifier harmonization via official gene symbol / UniProt mapping

### Network Prioritization
- STRING or equivalent PPI resource
- Cytoscape + cytoHubba / NetworkAnalyzer for degree, betweenness, closeness, EPC, MCC, or related scores
- Use at least one explicit hub-selection rule and document why it was chosen

### Functional Interpretation
- clusterProfiler, g:Profiler, DAVID, Metascape, Enrichr, or equivalent tools
- Use pathway resources appropriate to the endpoint biology and keep enrichment claims conservative

### Docking
- PubChem / DrugBank / ChEMBL ligand structures
- PDB / AlphaFold / UniProt structure sources where appropriate
- AutoDock Vina, Schrödinger, Discovery Studio, MOE, or equivalent docking frameworks
- Document receptor choice, preparation steps, and score interpretation limits
