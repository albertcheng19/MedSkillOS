# /read — Deep Paper Analysis

Accepts: local PDF path, DOI, journal URL, or a pasted abstract with basic metadata.

---

## Environment Detection

Read `mode` from `config.json`. If `"auto"`: file-readable → Tier B/C; bash available → Tier C; otherwise → Tier A.

---

## Steps

### 1. Determine Today's Dated Folder

**[Tier C / B]** Read `config.json` to get `data_dir` (`notes_dir` = `data_dir/notes`). Today's folder: `data_dir/notes/YYYY-MM-DD/`. Create it if it does not exist.

**[Tier A]** No folder needed. Notes will be output as an Artifact.

---

### 2. Retrieve Paper Metadata

Use WebFetch to query Semantic Scholar.

If DOI is available:
```
GET https://api.semanticscholar.org/graph/v1/paper/DOI:{doi}
  ?fields=title,year,citationCount,journal,authors,externalIds,abstract,publicationVenue
  Headers: x-api-key: {s2_api_key if set}
```

If no DOI, use title search:
```
GET https://api.semanticscholar.org/graph/v1/paper/search
  ?query={title keywords}&fields=title,year,citationCount,journal,authors,externalIds,abstract,publicationVenue&limit=1
```

For the top 5 authors, query each individually:
```
GET https://api.semanticscholar.org/graph/v1/author/{authorId}
  ?fields=name,hIndex,citationCount,affiliations
```

If any query fails (404, network error, timeout), mark affected fields as `[Query failed — please verify manually]` and continue. Do not abort the analysis.

**[Tier C optimization]** If Python is available, run `python scripts/lookup_paper.py --doi "DOI"` or `python scripts/lookup_paper.py --title "keywords"` instead of the WebFetch calls above.

---

### 3. Read Paper Content

- **PDF path provided**: Use the Read tool to read the PDF directly. Claude reads PDFs natively — no pdftotext required.
- **PDF uploaded (Tier A)**: Read the uploaded file content directly.
- **DOI / URL provided**: Attempt to fetch open-access content via WebFetch. If unavailable, ask the user to provide the PDF.
- **Abstract pasted**: Proceed with the abstract. Mark the note as `[Abstract only — full text not available]`.

**[Tier C optimization]** If `pdftotext` is available and the file is large (>50 pages), it may be used as an alternative for more complete text extraction.

---

### 4. Generate Paper Note

Produce a structured analysis in four sections. **Language: English primary.** Chinese is acceptable in the body text if that is the researcher's working language.

> ⚠️ **Literature Integrity Rule (see `LITERATURE_HARD_RULES.md`)**
> All bibliographic data (journal name, IF, citation count, h-index, DOI) must come from the Semantic Scholar query or the user-provided PDF. Never invent or estimate these values. If a field cannot be retrieved, write `[unavailable]`.

---

**Section I — Paper Weight**

Choose the branch matching the publication type. Fill in **all** fields. Do not leave fields blank without a label.

*Journal article:*
- Journal name (publisher)
- Database indexing (SSCI / AHCI / ESCI / Scopus — as returned by query)
- Impact Factor (if retrievable; otherwise `[IF: unavailable]`)
- Domain ranking (Q1/Q2 or percentile — if retrievable; otherwise `[ranking: unavailable]`)
- Journal h-index (if retrievable; otherwise `[h-index: unavailable]`)
- Each author: institution, position, research focus, representative journals, h-index (from author query, or `[unavailable]`)
- Citation count & yearly average (citations ÷ years since publication)
- Overall assessment

*Conference paper:*
- Full conference name
- CORE ranking (A* / A / B — if known; otherwise `[CORE rank: unverified]`)
- Acceptance rate (if known; otherwise `[acceptance rate: unavailable]`)
- Domain standing
- Author details as above
- Citation count & yearly average
- Overall assessment

*Preprint (arXiv, bioRxiv, etc.):*
- Platform & category
- Submission / journal version status (if known)
- Author details as above
- Citation count
- Overall assessment

---

**Section II — Paper Highlights**

- Methodological innovation
- Critique of systemic problems in the field
- Significance of the research object

---

**Section III — Transferable Elements**

Theory frameworks, method details, and conceptual tools. For each, tag which part of the user's own paper it can support (e.g., "→ applicable to: Introduction / Methods / Discussion").

---

**Section IV — How to Use in Your Paper**

- Literature review positioning
- Suggested citation phrases (in English)
- Methodological precedent
- Research motivation

---

### 5. Determine File Name

Follow the `Author_Year_Keywords` convention: max two author surnames + year + up to 4 keywords. Example: `Tan_Zhang_2023_lncRNA_Ferroptosis_Alzheimer.md`

---

### 6. Save Files

**[Tier C / B]** In `data_dir/notes/YYYY-MM-DD/PaperName/`:
- Copy / rename the PDF to `PaperName.pdf` (if the original is not already in the notes directory)
- Save the note as `PaperName.md`

**[Tier A]** Output the note as an Artifact with filename `PaperName.md`.

---

### 7. Auto-Sync (execute silently, no user prompt)

**[Tier C / B]**
1. **`reading_list.md`**: Add a `[x]` entry under the appropriate category with a relative link: `YYYY-MM-DD/PaperName/PaperName.md` (relative to `notes/`)
2. **`search_config.json`** `based_on_notes`: Add the note filename; sliding window max 25; update `last_updated` and `update_reason`
3. **`MEMORY.md`** `Reading Progress`: Append one line (note filename + one-sentence topic summary); sliding window max 20

**[Tier A]** Output an updated Session Card at the end of the conversation with the new paper added to Reading Progress.

---

### 8. Report to User

Confirm where the note was saved. Briefly state the single most actionable transferable element from this paper.
