# /update — Update Research Direction

Run when the research direction, methodology, or theoretical framework has changed. Collects the change through conversation and syncs all relevant configuration.

---

## When to Use

- A new research method has been decided (e.g., shifting from qualitative to mixed methods)
- The research question has been narrowed to a more specific focus
- A new theoretical framework has been added
- The research scope has expanded or contracted
- The disease focus or clinical setting has shifted

---

## Steps

### 1. Show Current Configuration

**[Tier C / B]** Read `memory/MEMORY.md`. Show the user a summary of the currently recorded research direction, and confirm this is the baseline they want to modify.

**[Tier A]** Ask the user to paste their Session Card if not already provided.

---

### 2. Understand the Change

Ask:
> What aspects have changed? Describe it directly — no formal language needed. For example: "I have now confirmed I am using a retrospective cohort design" or "I am narrowing the focus to only ferroptosis-related lncRNAs in glioblastoma" or "I am adding survival prediction modeling as a second aim."

If the description is vague, ask **one** follow-up question to clarify. Do not ask multiple questions at once.

---

### 3. Update `memory/MEMORY.md`

Make precise edits to the changed fields only. Do not rewrite the entire document.
- If a new theoretical framework was added, incorporate it into the Key Variables / Framework section or Key Decisions
- If Relevant Journals need adjustment, update them accordingly
- Keep all unchanged sections intact

---

### 4. Regenerate `search_config.json` Search Terms

Based on the updated research direction, regenerate Tier 1 / 2 / 3 search terms:
- Keep terms that are still relevant
- Replace terms that no longer apply
- Add terms reflecting the new direction
- Update `last_updated` and `update_reason` (note that this update was triggered by a research direction change)
- Leave `based_on_notes` unchanged

Show the updated search terms to the user for confirmation.

---

### 5. Check `reading_list.md` Categories

If the direction change is significant (e.g., a new methodological framework was added), ask the user:
> Would you like to add a new category to the reading list? (I will not modify existing entries automatically.)

Do not auto-modify existing reading list entries.

---

### 6. Report to User

- List what was changed
- Show the updated search terms
- Remind the user: the next `/feed` will recommend papers based on the new direction
