# Method Library
# comparative-network-toxicology-shared-mechanism-reference-grounded-research-planner-aligned

---

## Core Network-Toxicology Tooling

### Primary Analysis Environments
| Tool / Resource | Use Case |
|---|---|
| CTD / STITCH / SwissTargetPrediction / comparable databases | exposure-target collection |
| GeneCards / CTD / disease-target resources | toxic-phenotype target collection |
| clusterProfiler / enrichment tools | GO / KEGG interpretation |
| STRING | PPI network construction |
| Cytoscape / CytoHubba | hub-target prioritization |
| AutoDock Vina / Discovery Studio / comparable docking tools | docking support |

### Cross-Check and Synthesis Tools
| Tool / Resource | Use Case |
|---|---|
| GEO or comparable transcriptomic resource | orthogonal expression / pathway support |
| AOP-Wiki or structured toxic-mechanism resources | AOP framing |
| visualization tools | overlap, hub, docking, and evidence-summary figures |

---

## Data Resources

### Common Public Resources
| Resource | Coverage |
|---|---|
| CTD / STITCH / SwissTargetPrediction | exposure-target resources |
| GeneCards / CTD / OMIM-style resources | toxicity or disease target resources |
| STRING | PPI network |
| PDB / PubChem | receptor structures and ligands |
| GEO / transcriptomic repositories | orthogonal cross-check |

### Dataset Planning Requirement

| Item | What to Declare |
|---|---|
| Exposure A / B target sources | exact databases and retrieval rules |
| Toxic phenotype source | source and keyword logic |
| Docking resources | receptor structures, ligands, scoring rules |
| Validation resources | transcriptomic or AOP support source |
| PPI / enrichment resources | exact databases used |

> **Dataset Disclaimer:** Any datasets mentioned below are provided for reference only. Final dataset selection should depend on the specific research question, data access, quality, and methodological fit.

---

## Parameter Defaults and Decision Rules

| Parameter | Default | Notes |
|---|---|---|
| Target retrieval | use at least two credible resources when possible | declare union / intersection rule |
| Overlap logic | shared and specific sets handled separately | avoid silently merging them |
| PPI confidence | medium confidence or stricter | declare exact cutoff |
| Hub selection | multi-algorithm ranking preferred | avoid arbitrary single-metric hubs |
| Docking threshold | declare scoring and pose-selection rules | docking is plausibility support only |
| Cross-check interpretation | orthogonal support only | not mechanistic proof |
| Final synthesis | shared-vs-specific claims only | avoid definitive toxicity conclusions |
