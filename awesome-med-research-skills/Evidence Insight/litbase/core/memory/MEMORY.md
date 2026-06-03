# Project Memory

## Research

**Topic**: [Your research topic — populated by /setup]

**Key variables / framework**: [Key concepts, mechanisms, and methods — populated by /setup]

**Status**: [Current stage — populated by /setup]

## Project Structure
Paths are managed in `config.json`. Update that file if folders are renamed.
- LitBase dir: `recommend.py`, `lookup_paper.py`, `rename_pdfs.py`, `search_config.json`, `config.json`
- `config.json["data_dir"]` — data root; PDFs here, notes in `data_dir/notes/`

## Key Decisions
- Paper feed: Semantic Scholar API; search terms in search_config.json, updated by Claude each session
- Three-tier reading diet: Tier 1 core / Tier 2 adjacent field / Tier 3 wild card (tech-heavy)
- Note folder structure: all analyzed papers → notes/YYYY-MM-DD/PaperName/ (PDF + MD together); recommendations list → notes/YYYY-MM-DD/recommendations.md
- PDF naming convention: Author_Year_Keywords.pdf; automated via rename_pdfs.py (no Claude needed)
- Paper analysis: interactive via Claude Code (4 sections: Paper Weight / Highlights / Transferable Elements / How to Use in Your Paper)

## Standing Coding Rules (apply to all future work)
1. **No hardcoded paths/keywords**: always read from config.json or derive paths relative to script location (`os.path.dirname(__file__)`). Never write absolute paths as string literals in scripts.
2. **Keep folder clean**: when adding a new script, check if any existing script is superseded and delete it. When changing workflow, immediately sync all related files (WORKFLOW.md, MEMORY.md, reading_list.md, config.json).

## Auto-sync Rules (execute automatically, no reminder needed)
After analyzing any paper:
1. Add [x] entry to reading_list.md with correct relative link (YYYY-MM-DD/PaperName/PaperName.md, relative to notes/ dir)
2. Add paper note filename to search_config.json `based_on_notes` — keep max 25 entries (sliding window, drop oldest)
3. Add to Reading Progress below — keep max 20 entries (sliding window, drop oldest)
4. Create the dated folder, copy PDF in, save MD — all in one step

## Reading Progress
<!-- Maintained by Claude automatically; max 20 entries; drop oldest when full -->

## Relevant Journals
<!-- Populated by /setup based on your research domain -->
