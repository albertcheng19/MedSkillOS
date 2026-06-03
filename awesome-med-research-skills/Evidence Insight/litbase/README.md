# LitBase

An academic paper reading and research development system for **biomedical researchers**. Find papers, build structured reading notes, track discussion insights, and synthesize everything into a research proposal — all inside Claude.

Paper source: [Semantic Scholar](https://www.semanticscholar.org) — free, no login, 200M+ papers.

---

## What it does

| You want to… | You type… | What happens |
|---|---|---|
| Get paper recommendations | `/feed` | Claude searches Semantic Scholar, filters by your research direction, lists the best matches |
| Analyze a paper | `/read` | Submit a PDF or DOI → Claude generates a 4-section structured note saved to your research folder |
| Discuss a paper deeply | `/discuss` | Claude locates the note, reviews it, and records insights as you talk |
| See your progress | `/recap` | Framework completeness map, gaps, next steps |
| Build a research proposal | `/propose` | Claude synthesizes all your notes into a Research Foundation Document |

---

## Three-minute setup

**Step 1 — Edit `config.json`**

Open `config.json` in any text editor and fill in the path to your research folder:

```json
{
  "data_dir": "/Users/yourname/Documents/my-research",
  "s2_api_key": "",
  "mode": "auto"
}
```

`s2_api_key` is optional. Leave it empty — the free tier works fine.

**Step 2 — Open this folder in Claude Code**

In Claude Code: File → Open Folder → select the `articlefeed` folder.

**Step 3 — Type `/setup`**

Claude will configure everything automatically and ask you 5 questions about your research. No terminal commands needed.

---

## Using it on Web Claude (claude.ai)

ArticleFeed also works on Web Claude without any installation:

1. Open `SESSION_CARD_TEMPLATE.md`, fill in your research profile, and save it.
2. At the start of each conversation, paste the card.
3. Type commands the same way (`/feed`, `/read`, etc.).
4. Notes appear as downloadable Artifacts. An updated Session Card is generated at the end of each session — save it and use it next time.

---

## Commands

| Command | When | What it does |
|---------|------|-------------|
| `/setup` | First use | Research profile setup + auto environment config |
| `/feed` | Daily | Paper recommendations from Semantic Scholar |
| `/read` | Per paper | 4-section structured paper note |
| `/discuss [keyword]` | Deep dive | Paper discussion with auto-recorded insights |
| `/recap` | Weekly | Progress overview + framework completeness + gaps |
| `/update` | Direction shift | Sync research changes to memory and search terms |
| `/sync` | Maintenance | Consistency check + literature integrity audit |
| `/propose` | Proposal stage | Research Foundation Document (RFD) for protocol design |

---

## How paper notes are structured

Each analyzed paper gets a note with four sections:

1. **Paper Weight** — journal rank, impact factor, database indexing; each author's institution and h-index; citation count and yearly average
2. **Paper Highlights** — methodological innovation, critiques of existing limitations, significance of the research object
3. **Transferable Elements** — frameworks, methods, and concepts you can borrow, each tagged to where in your own paper they apply
4. **How to Use in Your Paper** — literature review positioning, suggested citation phrases (English), methodological precedent

---

## Research Foundation Document (RFD)

After reading and discussing enough papers, `/propose` synthesizes your notes into an RFD:

- Study Population & Clinical Context
- Focused Research Question (P/E/C/O/D/T format)
- Theoretical Framework & Mechanistic Basis (with ASCII diagram)
- Methodological Precedents
- Identified Research Gaps
- Literature Source Index

The RFD can be used directly as input to any downstream protocol design skill (e.g., clinical-cohort-protocol-designer).

**Literature integrity guarantee**: every citation in the RFD comes from your confirmed reading list. ArticleFeed never fabricates references, PMIDs, DOIs, or study findings.

---

## Optional: API key and Python acceleration

| Feature | Benefit | How to enable |
|---------|---------|--------------|
| Semantic Scholar API key | Higher rate limits for paper search | [Free to request](https://www.semanticscholar.org/product/api) → paste in `config.json` `s2_api_key` |
| Python scripts | Faster bulk search | Install Python (usually pre-installed) — Claude uses it automatically if available |
| pdftotext | Alternative PDF extraction for large documents | `brew install poppler` (Mac) or `apt install poppler-utils` (Linux) — optional |

---

## Environments supported

| Environment | How to use |
|------------|-----------|
| **Claude Code / OpenClaw** | Open folder → `/setup` → done |
| **Manus** | Clone folder into workspace → `/setup` → done |
| **Web Claude (claude.ai)** | Use `SESSION_CARD_TEMPLATE.md` — no install needed |
