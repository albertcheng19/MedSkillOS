# Figure and Deliverable Plan
# dual-disease-shared-transcriptome-biomarker-research-planner

---

## Standard Figure Set (7–8 figures)

| Figure | Content | Required From |
|---|---|---|
| **Fig 1** | Overall study workflow schematic | All configs |
| **Fig 2** | Cohort overview + per-disease expression landscape (two volcano plots, two heatmaps, overlap summary) | All configs |
| **Fig 3** | Shared-candidate reduction funnel or concordance-screening logic | All configs |
| **Fig 4** | PPI network, centrality ranking, and shared hub-gene prioritization | Standard+ |
| **Fig 5** | Diagnostic utility across both diseases: ROC comparison and candidate compression | All configs |
| **Fig 6** | Expression validation in discovery and external cohorts for each disease | Standard+ |
| **Fig 7** | Functional interpretation: GO / KEGG / GSEA summary | Standard+ |
| **Fig 8** | Immune context or orthogonal support panel | Standard+ |

---

## Advanced / Publication+ Extensions

| Figure | Content | Required From |
|---|---|---|
| **Fig 9** | Multi-tool immune robustness comparison or richer dual-disease orthogonal validation detail | Advanced+ |
| **Fig 10** | External validation — additional GEO / portal / protein support | Standard+ (can be supplementary) |
| **Fig 11** | Tissue / functional validation panel and integrated endpoint summary | Publication+ |
| **Fig 12** | Reviewer-facing integrated shared-mechanism schematic | Publication+ |

---

## Supplementary Figure Expectations

| Supplementary Content | Notes |
|---|---|
| Full DEG tables for both diseases | Prevent selective reporting |
| Overlap or concordance candidate tables | Needed when shared-biomarker claims are strong |
| Full PPI / centrality ranking tables | Required when hub-gene claims are emphasized |
| Full ROC output tables for both diseases | Supports dual-disease utility claims |
| Complete immune output tables | Avoids cherry-picking one immune result |
| Validation cohort QC and preprocessing notes | Critical for reviewer confidence |
| Assay QC and replicate details | Required if tissue or functional validation is used |

---

## Intermediate Deliverable Checklist

Use as a gate before moving to the next analysis phase.

**Phase 1 — Cohort Setup**
- [ ] Disease A discovery cohort selected and loaded
- [ ] Disease B discovery cohort selected and loaded
- [ ] Case-control logic harmonized across both diseases
- [ ] Shared-candidate generation route fixed

**Phase 2 — Computational Prioritization**
- [ ] Per-disease DEG tables complete
- [ ] Same-direction overlap or concordance rule documented
- [ ] PPI / prioritization logic documented (if used)
- [ ] Final endpoint fixed (hub set or one preferred lead gene)

**Phase 3 — Interpretation**
- [ ] Functional enrichment complete
- [ ] Immune module complete (if included)
- [ ] Single-gene pathway interpretation complete (if included)
- [ ] Evidence labels drafted for each result type

**Phase 4 — Validation**
- [ ] External cohort or orthogonal support complete for disease A
- [ ] External cohort or orthogonal support complete for disease B
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
