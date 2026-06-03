# /recap — Reading Progress Summary

Generates a global view of the current reading state: what has been read, what is missing, and how complete the theoretical framework is.

---

## Steps

### 1. Read Data

**[Tier C / B]** Read `config.json` to get `data_dir` (`notes_dir` = `data_dir/notes`). Read:
- `data_dir/notes/reading_list.md` — **authoritative** complete reading record (use this as the basis for the read-papers overview, not MEMORY.md)
- `memory/MEMORY.md` — research design, theoretical framework, recent Reading Progress
- The most recent 3 dated folders' paper notes — extract core concepts to supplement what MEMORY.md does not cover

**[Tier A]** Ask the user to paste their latest Session Card.

---

### 2. Generate Four-Part Summary

**① Papers Read (overview)**
List all papers marked `[x]` in `reading_list.md`, organized by theory layer (not by date). One sentence per paper stating its core contribution.

**② Framework Completeness**
Cross-reference the research design in `MEMORY.md` against the theory layers. For each layer:
- ✓ Supported by at least 2 papers
- ⚠ Only one paper — recommended to supplement
- ✗ No papers yet — gap

**③ Downloaded but Unread**
List papers in `reading_list.md` that have a PDF but are still marked `[ ]`. Sorted by priority: core literature > methods > other.

**④ Next-Step Recommendations**
2–3 specific suggestions based on framework gaps and the unread list:
- Which theory layer most needs more papers
- High-priority downloaded papers not yet read
- Whether running `/feed` in a particular direction would help

---

### 3. Proposal Readiness Assessment

After the next-step recommendations, evaluate the following conditions:
- Papers read: ≥ 5
- `MEMORY.md` theoretical framework is non-empty (has a specific description, not "exploring")
- At least 2 papers have discussion log entries

**If all three conditions are met**, add:
> ✅ Your literature base is ready for research proposal development. Run `/propose` to start building your Research Foundation Document.

Include this line in the recap snapshot file as well.

**If conditions are partially met**, state the specific gaps:
- How many more core papers are needed
- Which framework layer is still empty

---

### 4. Save Snapshot

**[Tier C / B]** Save to `data_dir/notes/recaps/YYYY-MM-DD_recap.md` (create the `recaps/` folder if needed).

```markdown
# Reading Progress Snapshot YYYY-MM-DD

## ① Papers Read
...

## ② Framework Completeness
...

## ③ Downloaded but Unread
...

## ④ Next-Step Recommendations
...
```

**[Tier A]** Output as an Artifact. Output an updated Session Card at the end.

---

### 5. Report to User

Display the full summary in the conversation. Confirm where the snapshot was saved.
