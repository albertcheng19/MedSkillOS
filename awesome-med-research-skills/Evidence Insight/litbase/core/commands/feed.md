# /feed — Paper Recommendations

Execute all steps without asking for user confirmation at intermediate stages. Report results at the end.

---

## Environment Detection

Read `mode` from `config.json`. If `"auto"`:
- If `config.json` is readable → Tier B/C
- If bash is available → Tier C
- Otherwise → Tier A

---

## Steps

### 1. Read Current Reading State

**[Tier C / B]** Read `config.json` to get `data_dir` (`notes_dir` = `data_dir/notes`). Read `data_dir/notes/reading_list.md` to understand:
- Papers already read (`[x]`) and their topics
- Papers downloaded but not yet read

**[Tier A]** Ask the user to paste their Session Card if not already present in this conversation.

---

### 2. Update `search_config.json`

Based on already-read paper topics and the research framework in `MEMORY.md`, update `search_config.json`:
- `tiers.tier1/2/3.terms` — refresh search terms
- `last_updated` — today's date
- `based_on_notes` — read paper note filenames, sliding window max 25 (drop oldest when full)
- `update_reason` — brief note on what drove this update

Search term principles (reference `MEMORY.md` for research direction):
- **Tier 1**: directly addresses the core research question
- **Tier 2**: same mechanism or method in a different disease context
- **Tier 3**: wild-card cross-domain inspiration, method-heavy

**[Tier A]** Update search terms in session memory; include updated terms in the session card output at the end.

---

### 3. Search Semantic Scholar

Read `tiers.tier1/2/3.terms` from `search_config.json`. For each search term, call:

```
GET https://api.semanticscholar.org/graph/v1/paper/search
  ?query={url-encoded term}
  &fields=title,year,citationCount,journal,authors,externalIds,openAccessPdf,publicationVenue
  &limit=5
  Headers: x-api-key: {s2_api_key from config.json, if set}
```

Wait 8 seconds between queries. On a 429 response, wait 10 seconds × attempt number and retry (up to 3 times).

**[Tier C optimization]** If Python is available, run `python scripts/recommend.py` instead of the WebFetch calls above.

---

### 4. Filter Recommendations

From the results, select 1–2 papers per tier based on:
- Direct relevance to the research question
- Citation count and journal weight
- Fills a gap in the existing reading list

---

### 5. Handle Open-Access Papers

For each selected paper where the result includes an `openAccessPdf.url`, mark it as `📥 Open access available` and include the PDF URL.

Tell the user:
> "The following papers have open-access PDFs. Run `/read [DOI or PDF URL]` to analyze any of them."

Do **not** auto-analyze during `/feed`. Recommendation and reading are separate steps.

For paywalled papers, note the access path:
- DOI link (`https://doi.org/...`)
- Institutional database (Web of Science, Scopus, PubMed)
- arXiv ID if a preprint exists

---

### 6. Write Recommendations File

**[Tier C / B]** Write results to `data_dir/notes/YYYY-MM-DD/recommendations.md` (create the dated folder if needed).

```markdown
# Paper Recommendations YYYY-MM-DD

## Tier 1 · Core
**[Paper Title]**
Authors (Year) | Journal | Citations: N
Recommendation rationale: ...
Status: 📥 Open access — [PDF URL] / 🔒 Access via: [DOI link](...)

## Tier 2 · Adjacent
...

## Tier 3 · Wild Card
...
```

**[Tier A]** Display the list in the conversation. Output an updated Session Card at the end.

---

### 7. Report to User

State which papers have open-access PDFs ready to read and which require manual retrieval (include links).
