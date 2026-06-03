# Figure and Deliverable Plan
# conventional-oncology-hub-gene-research-planner

---

## Standard Figure Set (7–8 figures)

| Figure | Content | Required From |
|---|---|---|
| **Fig 1** | Overall study workflow schematic | All configs |
| **Fig 2** | Cohort overview + tumor-normal expression landscape (volcano, heatmap, candidate summary) | All configs |
| **Fig 3** | Survival screening or risk-model construction / candidate reduction funnel | All configs |
| **Fig 4** | PPI network, centrality ranking, and hub-gene prioritization | Standard+ |
| **Fig 5** | Diagnostic and prognostic utility: ROC, KM, lead-gene comparison | All configs |
| **Fig 6** | Clinical correlation + independent prognostic value / nomogram | Standard+ |
| **Fig 7** | Functional interpretation: GO / KEGG / GSEA summary | Standard+ |
| **Fig 8** | Immune context or methylation / portal context | Standard+ |

---

## Advanced / Publication+ Extensions

| Figure | Content | Required From |
|---|---|---|
| **Fig 9** | Multi-tool immune robustness comparison or richer methylation detail | Advanced+ |
| **Fig 10** | External validation — GEO / HPA / portal support / protein plausibility | Standard+ (can be supplementary) |
| **Fig 11** | Tissue / cell validation panel and integrated endpoint summary | Publication+ |
| **Fig 12** | Reviewer-facing integrated evidence model / mechanism summary schematic | Publication+ |

---

## Supplementary Figure Expectations

| Supplementary Content | Notes |
|---|---|
| Full DEG tables and candidate screening results | Prevent selective reporting |
| Full survival screening / coefficient tables | Reviewer expectation for prognostic analyses |
| Full PPI / centrality ranking tables | Needed when hub-gene claims are strong |
| Additional subgroup and ROC outputs | Supports clinical utility claims |
| Complete immune output tables | Avoids cherry-picking one immune result |
| Complete methylation / CpG tables | Required if methylation layer is used |
| Assay QC and replicate details | Critical for tissue/cell validation outputs |

---

## Intermediate Deliverable Checklist

Use as a gate before moving to the next analysis phase.

**Phase 1 — Cohort Setup**
- [ ] Discovery cohort selected and loaded
- [ ] Clinical endpoint selected and harmonized
- [ ] Tumor / normal comparison logic declared
- [ ] Candidate-generation route fixed

**Phase 2 — Computational Prioritization**
- [ ] DEG table complete
- [ ] Survival screen or risk-model route complete
- [ ] PPI / prioritization logic documented (if used)
- [ ] Final endpoint fixed (signature / hub set / one preferred lead gene)

**Phase 3 — Interpretation**
- [ ] Functional enrichment complete
- [ ] Immune module complete (if included)
- [ ] Methylation / portal module complete (if included)
- [ ] Evidence labels drafted for each result type

**Phase 4 — Validation**
- [ ] External cohort or orthogonal support complete
- [ ] Protein / tissue / cell validation complete if selected
- [ ] Figure dependency order reviewed
- [ ] Limitation statements drafted

**Phase 5 — Manuscript**
- [ ] Full figure set finalized
- [ ] Supplementary tables compiled
- [ ] Methods section aligned with actual tool choices
- [ ] Results order aligned with figure order

---

## Dependency Map Deliverable (mandatory)

Every output must include a **Dependency Map / Evidence Map** as part of Section C.5. This is not a figure but a structured checklist that must appear before the step-by-step workflow.

### Required Format

```
Evidence Map — [Config Name]

PRESENT evidence layers:
- [list each declared data source and analysis method]

ABSENT evidence layers:
- [list what is NOT included in this configuration]

THEREFORE FORBIDDEN steps:
- [list downstream steps that cannot appear due to absent dependencies]

Endpoint formula used:
- [state the exact intersection formula]
```

This section must be generated for:
1. The recommended primary plan
2. The Minimal Executable Version (Section G)

If the two plans use different formulas, both must be stated separately.
