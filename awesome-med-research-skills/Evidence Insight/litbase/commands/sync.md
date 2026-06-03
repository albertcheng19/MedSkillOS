# /sync — Consistency and Integrity Check

Full audit of all skill documents and note files. Run manually after bulk changes. Fixes format/reference issues automatically; flags logic conflicts for user review.

---

## Steps

### 1. Read All Documents

Read the following files in full:
- `commands/*.md` — all 8 command files
- `README.md`
- `CLAUDE.md`
- `SKILL.md`
- `LITERATURE_HARD_RULES.md`
- `notes/WORKFLOW.md`
- `memory/MEMORY.md`

---

### 2. Execute Six Checks

**① Command Coverage**
For each file in `commands/`, confirm it is listed in:
- `README.md` command table ✓/✗
- `CLAUDE.md` command table ✓/✗
- `SKILL.md` command table ✓/✗
- `notes/WORKFLOW.md` quick-reference table ✓/✗

**② Path Convention Consistency**
Check that all commands consistently:
- Read `data_dir` from `config.json`
- Derive `notes_dir` as `data_dir/notes`
- Use the note path format `notes/YYYY-MM-DD/PaperName/PaperName.md`

**③ Auto-Sync Rule Consistency**
After `/read`, three locations must be synced: `reading_list.md`, `search_config.json` `based_on_notes`, `MEMORY.md` Reading Progress. Verify that `read.md`, `MEMORY.md` Auto-sync Rules, and `CLAUDE.md` all describe the same rule.

**④ Logic Conflict Check**
Check for contradictions between commands — field naming, file write format, path conventions, etc.

**⑤ `/propose` Completeness Check**
- Confirm `commands/propose.md` exists
- Confirm `commands/discuss.md` contains the Proposal Readiness Check (Step 5)
- Confirm `commands/recap.md` contains the Proposal Readiness Assessment (Step 3)
- Confirm `notes/WORKFLOW.md` includes a `/propose` entry

**⑥ Literature Integrity Audit**
Scan all paper note `.md` files in `data_dir/notes/` for citation references. Cross-check each against `reading_list.md`. For any reference not traceable to a `[x]` entry, add a flag (do not delete):
```
⚠️ UNVERIFIED CITATION: [reference] — not found in reading_list.md
```

---

### 3. Repair Scope

**Auto-repair without user confirmation** (format and reference issues only):
- `README.md`, `CLAUDE.md`, `SKILL.md`, `notes/WORKFLOW.md`: fix command name spelling, file path format, missing table rows

**Require user confirmation before modifying** (logic-level issues):
- Any change to `commands/*.md` content beyond formatting
- Any change to `memory/MEMORY.md`

If logic conflicts are found in `commands/` or `MEMORY.md`, report them and wait for the user to decide — do not auto-fix.

---

### 4. Report

```
✓ No issues / Fixed N issues:
  - [filename]: [what was fixed]
  ...

⚠️ Issues requiring your review:
  - [filename]: [description of conflict]
  ...
```
