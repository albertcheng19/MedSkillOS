# /discuss — Paper Discussion

Deep Q&A on a paper already analyzed. Actively records valuable insights to the note file during the discussion, without waiting for the user to prompt it.

---

## Steps

### 1. Locate the Note File

**[Tier C / B]** Read `config.json` to get `data_dir` (`notes_dir` = `data_dir/notes`).

The user can specify the paper by:
- Filename keyword (e.g., `Dong_2023`)
- Author surname (e.g., `Dong 2023`)
- Title keywords

Recursively search `notes_dir/` for matching `.md` files. Read the matching note in full. If a same-named PDF exists, read it as well for supplementary detail.

If no match is found, inform the user and ask whether they want to provide the path directly or run `/read` first.

**[Tier A]** Ask the user to paste the note content from a previous session, or describe which paper they want to discuss.

---

### 2. Enter Discussion

Briefly recap the paper's core content in 2–3 sentences. Ask what the user wants to discuss.

In the note file, create a discussion log section (or use the existing one for today if it already exists):

```markdown
## Discussion Log

### YYYY-MM-DD
```

---

### 3. Auto-Recording Rules During Discussion

**Record immediately when any of the following occurs — no user prompt needed:**
- The user asks a substantive question and receives a meaningful answer
- The discussion yields a new analytical angle or insight relevant to the user's own research
- A concept's scope or applicability is clarified in a way that matters for the research direction
- The user provides affirmative feedback ("that's useful", "this is exactly what I needed", etc.)

**Do not record:**
- Short clarification exchanges ("You mean...?" / "Yes")
- Off-topic chat unrelated to the paper or research

**Quantity limit:** If a single session generates more than 5 records, consolidate related entries rather than appending indefinitely.

**Format:**
```markdown
### YYYY-MM-DD

**Q: [core of user's question, one sentence]**
[Answer in 3–5 sentences, preserving key terms and conclusions. If there is a specific implication for the user's own paper, add a separate line:]
→ Implication for your paper: ...
```

Multiple records are appended in sequence. Never overwrite existing content.

---

### 4. After Discussion

Confirm the note has been updated. Tell the user how many new records were added in this session.

If the session produced no recordable content, do not create an empty discussion section.

---

### 5. Proposal Readiness Check (automatic, no user action required)

Count the number of valid records in the "Discussion Log" section of the **current** paper note.

Also read `MEMORY.md` Reading Progress to count how many papers in the reading list have discussion log entries.

If **either** condition is met:
- This paper has 5 or more discussion records (indicates deep engagement)
- 3 or more papers across the reading list have discussion records, **and** `MEMORY.md` contains a non-empty theoretical framework description

Then append to the end of the conversation:

> 💡 **You have accumulated substantial discussion on your literature.**
> This is a good time to synthesize your research proposal. Type `/propose` to start building your Research Foundation Document.
> (No need to do it now — you can run it at any time.)

Show this prompt only once per `/discuss` session. Do not repeat it on subsequent turns within the same session.
