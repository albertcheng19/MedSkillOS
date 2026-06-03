# Audience Language Guide

When a single audience is specified, shift emphasis and language accordingly.
For mixed audiences, use a balanced register and include all relevant bullets.

---

## 🏥 Clinical

**What they care about**: Patient outcomes, treatment decisions, trial design,
safety signals, clinical feasibility.

**Language to use**: Disease name > molecular pathway, "patients" not
"subjects", clinical endpoints (OS, PFS, response rate), "approved therapy",
"standard of care", "contraindication".

**Framing**: Lead with patient relevance. If findings don't have an immediate
clinical implication, say what they might lead toward — don't force a
premature clinical conclusion.

**Avoid**: Raw p-values without clinical context, pathway jargon (e.g., "mTOR
signaling") without explanation, methodological detail.

---

## 🔬 Wet-Lab

**What they care about**: Biological mechanism, experimental model, assay
design, validation feasibility.

**Language to use**: Cell type and model specificity, assay names
(Western blot, flow cytometry, CRISPR), mechanistic verbs ("upregulates",
"induces", "inhibits"), "in vitro / in vivo / ex vivo".

**Framing**: Emphasize what was shown mechanistically and what functional
experiment would validate or extend it. Flag model limitations (e.g., cell
line vs. primary cells, mouse vs. human).

**Avoid**: Statistical methodology details, bioinformatics pipeline
specifics, commercial/strategic implications.

---

## 💻 Bioinformatics

**What they care about**: Data type and quality, analytical validity,
reproducibility, statistical rigor, pipeline choices.

**Language to use**: Sequencing modality (scRNA-seq, WGS, ChIP-seq),
tool names where relevant, statistical approach (DESeq2, limma, GSEA),
"FDR-corrected", "batch effect", "independent cohort".

**Framing**: Be honest about analytical limitations — overfitted models,
small cohorts, exploratory vs. confirmatory analyses. Flag where validation
is needed. Bioinformaticians spot overclaiming immediately.

**Avoid**: Clinical speculation, commercial framing, overly biological
narrative without grounding in data.

---

## 📦 Product

**What they care about**: Translational potential, biomarker feasibility,
assay development, regulatory pathway, competitive landscape.

**Language to use**: "Biomarker", "patient stratification", "assay",
"clinical utility", "regulatory", "IP", "companion diagnostic",
"addressable population".

**Framing**: Connect findings to a concrete product opportunity or decision
point. Be specific about what the finding enables — don't just say "this
could be useful". Flag what is still needed before a product move.

**Avoid**: Deep mechanistic biology, statistical methodology, wet-lab
validation language.

---

## 📊 Management / Leadership

**What they care about**: Strategic relevance, funding opportunity,
publication potential, partnership angle, risk/confidence level.

**Language to use**: Plain language throughout. "We discovered", "this
positions us to", "next milestone", "competitive differentiation",
"publication-ready", "grant application".

**Framing**: One clear headline finding. Why it matters for the program.
What it unlocks. What the next decision point is. Express confidence level
honestly — management makes better decisions with accurate uncertainty than
false precision.

**Avoid**: Technical methodology, statistical detail, jargon of any kind.

---

## Handling Missing Audience Clarity

If the user hasn't specified an audience and the input doesn't make it
obvious, default to **mixed** and include all five bullets.

If only 2–3 audiences are clearly relevant (e.g., a purely computational
paper), omit the inapplicable bullets and note why.
