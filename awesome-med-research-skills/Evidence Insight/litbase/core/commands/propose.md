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

**If the user selects A** (self-refine):
No additional output needed. Proceed to Step 5.

**If the user selects B** (deepen):
Generate a full research proposal outline extending the RFD with:

> ⚠️ **Literature Integrity (LITERATURE_HARD_RULES.md applies throughout)**
> Every method, expected outcome, and limitation claim that draws on prior evidence must cite a paper from `reading_list.md` marked `[x]`. Use `[GAP: supporting literature needed]` for claims without a confirmed source. Never fabricate citations.

- **Methods detail**: specific assays, datasets, statistical approaches — each derived from and citing Section 4 (Methodological Precedents) source papers. Format: `[Method description] — precedent: Author_Year`
- **Expected outcomes**: primary and secondary endpoints, anticipated findings — each grounded in mechanistic or empirical evidence from the reading list. Format: `[Outcome] — supported by: Author_Year`
- **Limitations and mitigation strategies**: each limitation acknowledged in prior literature should cite its source. Format: `[Limitation] — noted in: Author_Year [or GAP if no source]`

**[Tier C / B]** Save the extended outline to `data_dir/notes/proposal/YYYY-MM-DD_proposal_outline.md`.
**[Tier A]** Output as an Artifact with filename `YYYY-MM-DD_proposal_outline.md`.

**If the user selects C** (downstream handoff):
Output a formatted RFD handoff summary (max 500 words) structured for protocol design skill input:

> ⚠️ **Literature Integrity (LITERATURE_HARD_RULES.md applies throughout)**
> Every claim in the handoff summary must be traceable to a paper in `reading_list.md` marked `[x]`. The Reference Index at the end must list only confirmed papers — no fabricated PMIDs, DOIs, or author names.

```markdown
## RFD Handoff Summary — LitBase /propose output

**Research question**: [one sentence in P/E/C/O format]
**Population (P)**: ... [cite: Author_Year]
**Exposure / Predictor (E/X)**: ... [cite: Author_Year]
**Comparator (C)**: ... [or N/A]
**Outcome (O)**: ... [cite: Author_Year]
**Preferred design (D)**: ...
**Time horizon (T)**: ... [or N/A]

**Theoretical framework summary**: [2–3 sentences with inline citations]
  Key mechanism: ... [Author_Year]
  Supporting evidence: ... [Author_Year]

**Key methodological precedents**:
- [Method] — precedent: Author_Year
- [Method] — precedent: Author_Year

**Main identified gaps**:
- [Gap description] — noted in: Author_Year [or GAP: no source]

**Reference Index** (confirmed papers only):
| Author_Year | Title (shortened) | Role in handoff |
|-------------|------------------|-----------------|
| Author_Year | ... | Population definition / Mechanism / Method precedent |

**Literature base**: [N papers analyzed as of YYYY-MM-DD]
```

**[Tier C / B]** Also save the handoff summary to `data_dir/notes/proposal/YYYY-MM-DD_RFD_handoff.md`.

Tell the user:
> Paste this into any compatible protocol design skill, or run it in a Claude Code session where the relevant skill is installed.

---

### 5. Update MEMORY.md

After the user selects an option, append to `memory/MEMORY.md` under a `## Proposal Log` section (create it if absent). Record different content depending on the path taken:

**Path A (self-refine):**
```
- YYYY-MM-DD: RFD vN — N papers — Status: generated, user refining independently
  File: proposal/YYYY-MM-DD_RFD.md
```

**Path B (deepen):**
```
- YYYY-MM-DD: RFD vN — N papers — Status: extended proposal outline generated
  Files: proposal/YYYY-MM-DD_RFD.md, proposal/YYYY-MM-DD_proposal_outline.md
```

**Path C (downstream handoff):**
```
- YYYY-MM-DD: RFD vN — N papers — Status: handoff formatted for downstream protocol design skill
  Files: proposal/YYYY-MM-DD_RFD.md, proposal/YYYY-MM-DD_RFD_handoff.md
```

The version number N is determined by counting existing entries in the Proposal Log.

**[Tier A]** Update the Session Card's Proposal Log section instead.

---

### 6. Ongoing Maintenance

Inform the user:
> This is a **living document**. Each run of `/propose` creates a new versioned RFD in `proposal/` (previous versions are preserved).
> Recommended: run `/propose` again after each `/recap` to keep the RFD current with your reading progress.
