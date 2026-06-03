# Literature Integrity Hard Rules

These rules apply to all LitBase commands at all times. No command output may violate them.

---

## 1. Never Fabricate Literature

- Never invent PMIDs, DOIs, paper titles, author names, or journal names.
- Never invent citation counts, impact factors, or publication years.
- Never invent clinical trial registration numbers (NCT, ChiCTR, ISRCTN, etc.).
- Never invent cohort names, registry names, or database names.
- Never invent sample sizes, follow-up durations, event rates, or any quantitative study findings.

## 2. Always Label Uncertainty

- If any piece of bibliographic information comes from model training memory rather than the user's notes or a live Semantic Scholar query, label it:
  `[Unverified: sourced from model knowledge, not confirmed in user notes]`
- If a Semantic Scholar query fails (404, network error, timeout), mark affected fields as:
  `[Query failed — please verify manually]`
- If an author's h-index cannot be retrieved, write `[h-index: unavailable]`. Do not estimate.
- If a journal's impact factor is not returned by the API, write `[IF: unavailable]`. Do not estimate.

## 3. Citation Scope in Notes and Proposals

In `/read` notes, `/discuss` discussion logs, and `/propose` RFD output:
- Only cite papers the user has actually provided (PDF, abstract, or DOI) or papers verified via Semantic Scholar with a returned paperId.
- Do not present training-data knowledge as a specific citation.
- If citing field background without a user-provided source, use the form:
  *(Field context — user should confirm with a primary source.)*

## 4. Additional Rules for `/propose`

- Every literature reference appearing in the Research Foundation Document (RFD) must correspond to an entry in `reading_list.md` that is marked as read `[x]`.
- The Reference Index table in Section 6 must not include papers not in the reading list.
- If a claim requires a literature source that the user has not yet read, insert a gap marker instead:
  `[GAP: supporting literature needed — suggested search: <keywords>]`
- Do not use vague attribution phrases such as "studies show", "it is well established", or "previous research demonstrates" without a verifiable source from the user's reading list.

## 5. Integrity Check in `/sync`

When `/sync` runs, it must:
- Scan all paper note `.md` files for citation references.
- Cross-check each reference against `reading_list.md`.
- Flag (not delete) any reference that does not match a confirmed entry, using:
  `⚠️ UNVERIFIED CITATION: [reference text] — not found in reading_list.md`
