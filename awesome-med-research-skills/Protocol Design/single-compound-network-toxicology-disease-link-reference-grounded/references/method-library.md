# Method Library

## Compound standardization and identifier options
- PubChem CID / Canonical SMILES / InChI / CAS when available
- manual synonym harmonization when the compound has multiple names
- explicit structure source declaration for docking workflows

## Compound target retrieval options
- SwissTargetPrediction
- PharmMapper
- TargetNet
- CTD or equivalent toxicogenomics resource
- STITCH or equivalent interaction resource when justified

## Disease / phenotype target resources
- GeneCards
- DisGeNET
- OMIM
- CTD disease links
- DrugBank / Therapeutic Target Database when disease target context is relevant

## Network analysis options
- STRING with declared confidence threshold
- Cytoscape visualization
- cytoHubba or equivalent ranking module
- Degree / BC / MCC / closeness as explicitly stated
- source-sensitivity comparison if multiple hub metrics are used

## Enrichment options
- GO-BP / CC / MF
- KEGG
- Reactome
- clusterProfiler / enrichplot / ConsensusPathDB / g:Profiler

## Docking options
- CB-Dock2 for cavity-guided screening
- AutoDock Vina or equivalent for custom docking
- Discovery Studio / PyMOL / Chimera for structure visualization
- PDB or AlphaFold structure sourcing with explicit structure-quality note

## Validation upgrade options
- GEO or comparable public transcriptomic dataset
- disease-case vs control expression comparison for nominated hubs
- toxicogenomic signature comparison
- literature coherence review
- AOP alignment if the endpoint has an accepted mechanistic framework

## Not equivalent modules
- Target prediction ≠ validated target engagement
- Overlap genes ≠ true disease mediators
- PPI centrality ≠ biological importance in vivo
- Docking score ≠ confirmed binding
- Disease expression mismatch ≠ refutation unless endpoint, tissue, and design are compatible
