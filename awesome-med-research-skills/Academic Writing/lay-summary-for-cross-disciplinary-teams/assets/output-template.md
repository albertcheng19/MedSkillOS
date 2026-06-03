# Lay Summary — Output Template

Use this template for every lay summary. Adapt section depth to the complexity
of the input. Do not skip sections — if data is missing, say so briefly.

---

## Lay Summary — [Study / Project Title]

**🎯 What we were trying to find out**
[1–2 sentences. Plain language. No acronyms without definition. Frame as a
question the research set out to answer.]

**🔬 What we did**
[1–2 sentences on study design or data used. Skip methodological detail —
name the approach (e.g., "single-cell RNA sequencing", "randomized trial",
"retrospective cohort") and move on.]

**📊 What we found**
[2–4 sentences. Lead with the key result. Quantify where possible. Avoid
vague positives ("results were promising") — say what changed, by how much,
in whom.]

**⚠️ What this means — and what it doesn't**
[1–3 sentences. Explicitly state what the finding supports and where the
evidence stops. Acknowledge limitations: sample size, model type, lack of
replication, confounders.]

**👥 What this means for your team**
[Include only the audiences that apply. For mixed audiences, include all.]

- 🏥 **Clinical**: [Patient relevance, clinical implication, or trial
  rationale. Frame in terms clinicians use.]
- 🔬 **Wet-lab**: [Experimental follow-up, mechanistic validation, or
  model considerations.]
- 💻 **Bioinformatics**: [Data quality, analytical caveats, replication
  or validation needs.]
- 📦 **Product**: [Translational or commercial implication, biomarker
  or assay relevance.]
- 📊 **Management**: [Strategic relevance, funding rationale, partnership
  or publication opportunity.]

**➡️ What comes next**
[1–2 sentences on the most important next steps or open questions. Be
concrete — name the experiment, dataset, or decision, not just "further
research is needed".]

---

## Annotated Example

**Input fragment (technical):**
> "We performed scRNA-seq on PBMCs from 42 early-stage NSCLC patients and
> 20 healthy controls. UMAP clustering identified a CD8+ exhausted T cell
> subpopulation (Tex) significantly expanded in tumor-adjacent tissue
> (p < 0.001). Pseudotime trajectory analysis suggested progressive
> exhaustion correlating with PD-1 upregulation."

**Output (mixed audience):**

---

## Lay Summary — CD8+ T Cell Exhaustion in Early-Stage Lung Cancer

**🎯 What we were trying to find out**
We wanted to understand how immune cells behave in early-stage lung cancer
patients, and whether a specific type of immune dysfunction might be
contributing to the cancer's ability to evade the immune system.

**🔬 What we did**
We profiled individual immune cells from blood samples of 42 lung cancer
patients and 20 healthy donors using single-cell RNA sequencing — a technique
that reads the gene activity of thousands of cells one at a time.

**📊 What we found**
A subset of immune cells called exhausted T cells (Tex) was significantly
more abundant near tumor tissue in cancer patients compared to healthy donors
(p < 0.001). These cells showed progressive loss of function, associated with
rising levels of PD-1 — a protein already targeted by approved cancer therapies.

**⚠️ What this means — and what it doesn't**
This suggests T cell exhaustion is an early feature of immune suppression in
this cancer type, and may be targetable with existing PD-1 inhibitors. However,
this is a cross-sectional observation in blood — we cannot yet confirm whether
tumor-infiltrating T cells follow the same pattern, or whether reversing
exhaustion would improve outcomes.

**👥 What this means for your team**

- 🏥 **Clinical**: These findings may support a rationale for early PD-1
  checkpoint intervention. Worth discussing whether early-stage patients
  could be candidates for existing approved therapies.
- 🔬 **Wet-lab**: Functional validation (cytotoxicity assays, co-culture
  with tumor cells) would confirm whether these Tex cells are truly
  dysfunctional or merely phenotypically exhausted.
- 💻 **Bioinformatics**: Pseudotime inference is directional — validate
  with RNA velocity or an independent cohort before treating trajectory
  as established.
- 📦 **Product**: Supports a CD8+ exhaustion signature as a potential
  early-detection or patient stratification biomarker. Worth scoping
  assay feasibility.
- 📊 **Management**: Strong translational angle for a grant or pharma
  partnership pitch — early-stage immune profiling with a direct link
  to an approved drug class.

**➡️ What comes next**
We are planning functional T cell assays and will seek a validation cohort
from an independent institution before pursuing a clinical translation proposal.
