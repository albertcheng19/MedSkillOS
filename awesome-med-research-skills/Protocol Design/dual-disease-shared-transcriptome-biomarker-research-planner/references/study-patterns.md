# Study Patterns
# dual-disease-shared-transcriptome-biomarker-research-planner

---

## Pattern A — Shared-DEG-First Workflow

**Best for:** discovery-style dual-disease papers where the central claim is that two diseases share a transcriptomic signal.

**Core logic:**
Disease A DEG + Disease B DEG → same-direction overlap → enrichment → candidate shortlist

**Strengths:**
- clean and interpretable
- easy to execute with public data
- strong fit for proof-of-concept shared-biology papers

**Weaknesses:**
- may not compress naturally to one final biomarker
- overlap instability can weaken the paper if cohorts are noisy

---

## Pattern B — Shared Hub-Gene-First Biomarker Workflow

**Best for:** papers that want a compact shared hub set with stronger network-based prioritization.

**Core logic:**
Same-direction overlap → STRING PPI → cytoHubba ranking → compact shared hub set

**Strengths:**
- stronger endpoint compression
- familiar reviewer-facing structure

**Weaknesses:**
- network centrality is not causality
- can overstate hub importance if validation is weak

---

## Pattern C — Hybrid Shared-Biomarker Workflow

**Best for:** papers that want one preferred final lead gene with both overlap and utility support.

**Core logic:**
Same-direction overlap → PPI hub shortlist → ROC in both diseases → one preferred lead gene → pathway / immune interpretation

**Strengths:**
- balanced and publication-friendly
- gives a clear endpoint

**Weaknesses:**
- lead-gene choice can become assumption-heavy
- requires stronger claim control

---

## Pattern D — Immune-Context Shared-Biomarker Workflow

**Best for:** disease pairs where inflammation or immune remodeling is central to the biological story.

**Core logic:**
Shared endpoint fixed → immune deconvolution in both diseases → lead-gene immune correlation → pathway interpretation

**Strengths:**
- adds biological depth
- can improve narrative cohesion

**Weaknesses:**
- still inference from bulk transcriptome
- vulnerable to overinterpretation if immune evidence is treated as direct cell measurement

---

## Pattern E — Orthogonal Validation Workflow

**Best for:** higher-rigor papers that want stronger reviewer-facing support.

**Core logic:**
Hybrid shared biomarker plan → independent dual-cohort validation → optional protein / tissue support → integrated evidence summary

**Strengths:**
- strongest defensibility in this family
- best fit for publication-oriented outputs

**Weaknesses:**
- highest workload
- requires careful boundary-setting if support is asymmetric across the two diseases
