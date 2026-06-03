# Validation and Evidence Hierarchy
# comparative-network-toxicology-shared-mechanism-reference-grounded-research-planner-aligned

---

## Evidence Tiers

### Target-Overlap Discovery Evidence (supportive — label explicitly as discovery)

| Evidence | Source | What It Establishes |
|---|---|---|
| Exposure-target overlap with toxicity targets | exposure-target and disease-target intersection | toxicity-linked candidate set |
| Shared-vs-specific decomposition | overlap logic | common vs divergent mechanism candidates |
| GO / KEGG enrichment | enrichment analysis | pathway-level relevance |

### Hub-Target Prioritization Evidence (stronger — label explicitly as network evidence)

| Evidence | Source | What It Establishes |
|---|---|---|
| PPI network | interaction analysis | interaction-supported target structure |
| Multi-algorithm hub ranking | CytoHubba or equivalent | stronger hub-target prioritization |
| Shared-vs-specific hub comparison | comparative ranking framework | higher-confidence comparative candidates |

### Docking and Cross-Check Evidence (supportive — label explicitly as plausibility support)

| Evidence | Source | What It Establishes |
|---|---|---|
| Molecular docking | receptor-ligand analysis | binding plausibility |
| Transcriptomic cross-check | public omics support | orthogonal support for pathway or target direction |
| AOP framing | structured mechanistic resource | coherent toxic-mechanism interpretation |

### Public-Validation Evidence (stronger — label explicitly as validation support)

| Evidence | Source | What It Establishes |
|---|---|---|
| Multi-layer agreement | overlap + PPI + docking + cross-check alignment | more credible target prioritization |
| Conservative evidence synthesis | shared-vs-specific logic preserved across layers | stronger comparative interpretation |
| Reviewer-facing downgrade logic | unstable target or docking triage | better claim discipline |

---

## Language Rules

- Discovery findings: "shared candidate targets", "exposure-specific candidate targets", "toxicity-linked overlap"
- Network findings: "interaction-supported hub target", "comparatively prioritized hub"
- Docking findings: "supports binding plausibility", "consistent with docking-based support"
- Validation findings: "orthogonal support", "comparative evidence coherence"

- **NEVER use:** "proves toxicity mechanism", "confirms target toxicity", "establishes safety ranking" from network toxicology and docking alone
