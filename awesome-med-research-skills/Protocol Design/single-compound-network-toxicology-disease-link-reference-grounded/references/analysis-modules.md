# Analysis Modules

## Core module stack

| Module | Purpose | Minimum Inputs | Output | Evidence role |
|---|---|---|---|---|
| Compound standardization | Harmonize compound name, identifier, and structure | compound name + CAS / CID / SMILES / InChI when available | standardized exposure definition | Tier 1 exposure identity |
| Compound target retrieval | Build candidate exposure-target library from multiple resources | standardized compound + target resources | compound target set | Tier 2 predictive target layer |
| Disease / phenotype target retrieval | Build disease-relevant or toxicity-relevant target universe | endpoint keywords + disease resources | disease / phenotype target set | Tier 2 endpoint layer |
| Overlap construction | Identify plausible bridge genes between the compound and endpoint | compound targets + endpoint targets | intersecting target set | Tier 3 bridge layer |
| PPI network construction | Build interaction backbone for bridge genes | overlap targets + STRING or equivalent | PPI network | Tier 4 network layer |
| Hub prioritization | Rank central or repeatedly selected proteins | PPI + explicit metric rules | hub-gene shortlist | Tier 4 prioritization layer |
| Functional enrichment | Identify candidate biological themes | overlap targets or hubs | GO / KEGG / Reactome themes | Tier 4 pathway-interpretation layer |
| Docking | Support direct-binding plausibility for top targets | ligand structure + prioritized proteins + receptor structures | docking-support table | Tier 5 binding-plausibility layer |
| Public expression cross-check | Test whether nominated hubs are altered in disease context | prioritized hubs + public disease dataset | orthogonal disease-context support | Tier 5 external-coherence layer |
| Conservative synthesis | Integrate all layers without overclaiming | all upstream outputs | mechanism-prioritization narrative | final interpretation layer |

## Interpretation modules

### 1. Exposure–disease bridge module
Use when the key question is whether the compound plausibly intersects the disease molecular network.

### 2. Toxicant-to-phenotype mechanism module
Use when the endpoint is organ injury, fibrosis, reproductive toxicity, endocrine disturbance, or another adverse phenotype rather than a narrowly named disease.

### 3. Endocrine / metabolic disruption module
Use only when endocrine or metabolic language is supported by enrichment plus literature coherence.

### 4. Cross-check module
Use only as supportive evidence, not as proof that the compound caused the disease-expression pattern.

### 5. Claim-downgrade module
Always state which outputs remain predictive only: target retrieval, overlap, network topology, pathway enrichment, docking, and orthogonal cross-check are different evidence tiers and must not be collapsed into one certainty claim.
