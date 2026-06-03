# /setup — Initial Configuration

Run this on first use. Configures the environment automatically and collects your research profile through a guided conversation.

---

## Steps

### 0. Auto Environment Initialization

Detect the current capability tier before doing anything else.

**If Tier C (bash available):**
- Check whether `.claude/commands` exists. If not, run:
  ```bash
  mkdir -p .claude && ln -s ../commands .claude/commands
  ```
- Check whether `.claude/settings.local.json` exists. If not, run:
  ```bash
  cp settings.local.json .claude/settings.local.json
  ```
- Inform the user: "Environment configured automatically — no manual steps needed."

**If Tier B (file system, no bash):**
- Inform the user of the minimum permissions needed: file read/write access to this directory and `data_dir`.
- Proceed to the questionnaire.

**If Tier A (Web Claude, no file system):**
- Skip file initialization.
- At the end of setup, generate a Session Card from `SESSION_CARD_TEMPLATE.md` filled with the user's answers.
- Explain: "Since there is no file system here, I will use a Session Card to maintain your research context across conversations. Save the card I generate at the end and paste it at the start of each new session."

---

### 1. Confirm `data_dir` is Configured

**Tier C / B:** Check whether `config.json` exists and `data_dir` is filled in (not a placeholder). If missing:
> Please edit `config.json` and set `data_dir` to the folder where you keep your research PDFs, then run `/setup` again.

**Tier A:** Ask the user directly:
> Where do you usually save your research papers? (Just describe it — folder name, cloud drive, etc. For context only.)

---

### 2. Research Profile Questionnaire

Ask one question at a time. Wait for each answer before proceeding.

---

**Q1 — What disease or clinical problem are you researching?**

Describe your core research focus. Examples:
- Disease name: glioma, type 2 diabetes, acute myocardial infarction, Alzheimer's disease
- Pathological mechanism: ferroptosis, immune evasion, drug resistance, metabolic reprogramming
- Clinical problem: post-surgical recurrence prediction, treatment response biomarkers, survival prognosis modeling

One sentence is enough. No formal language required.

---

**Q2 — What research level does your work involve? (Multiple answers OK)**

- **Molecular / cellular**: gene expression, protein interactions, signaling pathways, in vitro cell experiments
- **Animal model**: in vivo mouse/rat experiments, behavioral studies
- **Tissue / pathology**: histological sections, immunohistochemistry, pathology scoring
- **Clinical / cohort**: retrospective cohort, prospective study, clinical trial
- **Population / epidemiology**: large-scale databases, real-world data, meta-analysis

---

**Q3 — Wet lab, dry lab, or both?**

- **Wet lab**: cell culture, animal experiments, biochemical assays, gene editing
- **Dry lab / bioinformatics**: transcriptomics, genomics, multi-omics, machine learning modeling
- **Integrated (wet + dry)**: bioinformatics discovery followed by experimental validation, or reverse
- **Clinical data analysis**: EHR / medical records, imaging data, real-world data

---

**Q4 — What stage are you at?**

- Just starting — defining the research direction
- Have a preliminary direction — identifying key literature
- Have a core idea — looking for methodological support
- Have data or experimental results — refining the theoretical framework
- Writing stage — supplementing literature support

---

**Q5 — Any papers you have already read that significantly influenced your thinking?**

First author and year is enough. Skip if none.

---

### 3. Generate Configuration Files

Based on the user's answers, complete the following actions.

**Update `memory/MEMORY.md`:**
- Research topic: disease + mechanism + research level (from Q1 + Q2)
- Wet/dry orientation: from Q3
- Key variables / framework: extracted from Q1 answer
- Current status: from Q4
- Relevant journals: populated based on research domain:
  - Oncology / glioma → Neuro-Oncology, Cancer Research, Nature Cancer, Cell Death & Differentiation
  - Bioinformatics / multi-omics → Genome Research, Bioinformatics, Briefings in Bioinformatics
  - Clinical cohort → Journal of Clinical Oncology, Clinical Cancer Research, Lancet Oncology
  - Neurodegeneration → Alzheimer's & Dementia, Acta Neuropathologica, Brain
  - Adapt to the actual domain described in Q1

**Generate initial `search_config.json`:**

Tier assignment logic based on Q2 + Q3:
- **Tier 1 (core)**: 4–5 terms directly targeting the disease + mechanism from Q1
- **Tier 2 (adjacent)**: 4–5 terms — same mechanism in a different disease context, or same disease with a different method
- **Tier 3 (wild card)**: 4–5 terms for cross-domain methods or computational tools relevant to Q3

Specialization rules:
- If Q3 = integrated wet + dry → add a "mechanistic validation methods" cluster to Tier 2
- If Q2 includes clinical/cohort → Tier 1 includes clinical outcome terms; Tier 3 includes statistical modeling terms

Set `last_updated` to today's date. Set `based_on_notes` to an empty array.

**Generate `data_dir/notes/reading_list.md`:**
- Categories derived from Q2 (e.g., Molecular Mechanism / Animal Models / Clinical Cohort / Bioinformatics Methods / Systematic Reviews)
- If Q5 listed papers, add them to a "Previously Read" category marked `[x]`

**[Tier C / B only] Copy workflow reference:**
```bash
cp notes/WORKFLOW.md {data_dir}/notes/WORKFLOW.md
```

---

### 4. Report to User

Confirm setup is complete. Show the generated search terms for the user to review. Tell the user they can now:
- Type `/feed` to get the first batch of recommended papers
- Drop a PDF into the data folder and type `/read` to analyze a paper
- Type `/propose` whenever they are ready to start drafting a research proposal
