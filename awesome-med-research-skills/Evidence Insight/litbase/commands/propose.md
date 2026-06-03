# /propose — Research Foundation Document

Synthesizes accumulated literature notes into a structured **Research Foundation Document (RFD)**.

The RFD serves as the standardized upstream input for any downstream protocol design skill (e.g., clinical-cohort-protocol-designer, translational-study-blueprint, statistical-analysis-plan-writer). It can also be used independently as a research proposal outline.

> ⚠️ **Literature Integrity (LITERATURE_HARD_RULES.md applies throughout)**
> Every citation in the RFD must correspond to a paper in `reading_list.md` marked as read `[x]`.
> Never fabricate PMIDs, DOIs, author names, citation counts, or study findings.
> If a claim requires literature support that the user has not yet read, insert a gap marker:
> `[GAP: supporting literature needed — suggested search: <keywords>]`

---

## Steps

### 1. Collect Source Material

**[Tier C / B]** Read `config.json` to get `data_dir`. Then read:
- `memory/MEMORY.md` — research direction, framework, Reading Progress
- `data_dir/notes/reading_list.md` — complete reading record
- All read paper notes (`.md` files marked `[x]`): extract **Section III (Transferable Elements)**, **Section IV (How to Use)**, and **Discussion Log** entries
- Most recent recap snapshot in `data_dir/notes/recaps/` (if available)

**[Tier A]** Ask the user to paste their latest Session Card. Optionally ask them to paste key note content from important papers.

---

### 2. Show Summary and Ask Clarifying Questions

Display a materials overview:

> **You currently have:**
> - N papers analyzed: [list with one-line core contribution each]
> - Theoretical framework: [extracted from MEMORY.md — or "not yet defined" if absent]
> - Key discussion insights: [top 3 most actionable entries from all Discussion Logs]
>
> **I will now guide you through building your Research Foundation Document.**
> We will go section by section. After each section, you can revise before we proceed.
> Type "skip" to skip a section, or "back" to revise a previous one.

Then ask the following questions. **Only ask questions whose answers cannot be found in MEMORY.md or the notes.** Skip any that are already answered.

**Q1 — What is the core question your research aims to answer?**
Use the format: [Population] + [Exposure / Predictor / Intervention] + [Outcome]. Examples:
- "In glioma patients, does low SNAI3-AS1 expression predict sensitivity to ferroptosis inducers?"
- "In AD patients with high lncRNA ceRNA network activity, is cognitive decline faster?"

**Q2 — What study design do you lean toward?** (Can be uncertain)
- Mechanistic exploration (in vitro / in vivo experiments)
- Bioinformatics analysis (transcriptomics / multi-omics)
- Retrospective cohort (existing data)
- Prospective cohort (requires enrollment)
- Machine learning prediction model
- Systematic review / meta-analysis

**Q3 — What data or samples do you have or can realistically access?** (Can be uncertain)
- Public databases (GEO, TCGA, CGGA, UK Biobank, etc.)
- Institutional EHR / medical records
- Collected tissue or blood samples
- No data yet — still in planning
- Other

---

### 3. Build the RFD Section by Section

After each section, pause and ask: "Does this look accurate? Any changes before we continue?" Accept "continue" or direct corrections before moving on.

---

**Section 1 — Study Population & Clinical Context**

Describe:
- Target disease and clinical setting
- Study population characteristics (informed by Q2/Q3 answers)
- How prior literature defines this population

For each claim, cite the source paper from the reading list. If no source is available, label it `[GAP: literature needed]`.

---

**Section 2 — Focused Research Question**

Structured format (PECOT):

| Element | Definition | Source |
|---------|-----------|--------|
| **P** Population | [specific description] | [Author_Year or GAP] |
| **E/X** Exposure / Predictor | [specific description] | [Author_Year or GAP] |
| **C** Comparator / Baseline | [if applicable] | [Author_Year or GAP] |
| **O** Outcome | [specific description] | [Author_Year or GAP] |
| **D** Design | [from Q2 answer] | — |
| **T** Time horizon | [if applicable] | [Author_Year or GAP] |

Every cell in the Source column must either name a paper from the reading list or state `[Assumption — literature support needed]`.

---

**Section 3 — Theoretical Framework & Mechanistic Basis**

- ASCII diagram of the framework (key nodes + directional arrows)
- Each node labeled with the supporting paper(s)
- Nodes without literature support labeled `[GAP: node not yet supported]`

Example format:
```
lncRNA SNAI3-AS1
    │ (suppresses)           [Zheng_2023_SNAI3-AS1]
    ▼
SND1 / m6A pathway
    │ (destabilizes)         [Zheng_2023_SNAI3-AS1]
    ▼
Nrf2 mRNA stability
    │ (reduces)              [GAP: mechanism link needs literature]
    ▼
Ferroptosis sensitivity      [Hu_2020_TMZ_Resistance]
```

---

**Section 4 — Methodological Precedents**

Drawn from Section III (Transferable Elements) of the paper notes:

| Method | Source Paper | Transferable Operation |
|--------|-------------|----------------------|
| LASSO feature selection | Yang_Pan_2021 | Applied to ferroptosis-related gene set; identical approach applicable here |
| WGCNA co-expression | Tan_2023 | Hub gene identification in AD; adapt for glioma lncRNA network |

Only methods from papers in the reading list may appear here.

---

**Section 5 — Identified Research Gaps**

Drawn from Section II (Paper Highlights) — specifically the critique of existing limitations — and the framework completeness check from the last `/recap`:

- Gap 1: [description] → How your study addresses this
- Gap 2: [description] → How your study addresses this
- ...

---

**Section 6 — Literature Source Index**

| Paper | Supports Section | Citation Role |
|-------|-----------------|---------------|
| Author_Year_Title | Section 2 / 3 / 4 | Population definition / Mechanistic support / Method precedent |

⚠️ This table must only contain papers present in `reading_list.md` with a `[x]` marker. No exceptions.

---

### 4. Generate Full RFD and Offer Next Steps

Merge all confirmed sections into the complete document.

**[Tier C / B]** Save to `data_dir/notes/proposal/YYYY-MM-DD_RFD.md` (create `proposal/` folder if needed).

**[Tier A]** Output as an Artifact with filename `YYYY-MM-DD_RFD.md`.

Then ask:

> **What would you like to do next?**
> **A.** This document is sufficient — I will refine it myself.
> **B.** Continue to deepen it: generate a full research proposal outline with methods detail and expected outcomes.
> **C.** Use this as input for a protocol design skill. I will format it as a standardized RFD handoff for downstream use.

**If the user selects C**, output a formatted RFD handoff summary (max 500 words) structured for protocol design skill input:

```markdown
## RFD Handoff Summary — ArticleFeed /propose output

**Research question**: [one sentence]
**Population (P)**: ...
**Exposure / Predictor (E/X)**: ...
**Comparator (C)**: ... [or N/A]
**Outcome (O)**: ...
**Preferred design (D)**: ...
**Time horizon (T)**: ... [or N/A]
**Theoretical framework summary**: [2–3 sentences]
**Key methodological precedents**: [bullet list]
**Main identified gaps**: [bullet list]
**Literature base**: [N papers analyzed as of YYYY-MM-DD]
```

Tell the user:
> Paste this into any compatible protocol design skill, or run it in a Claude Code session where the relevant skill is installed.

---

### 5. Ongoing Maintenance

Inform the user:
> This is a **living document**. Each run of `/propose` creates a new versioned RFD in `proposal/` (previous versions are preserved).
> Recommended: run `/propose` again after each `/recap` to keep the RFD current with your reading progress.
