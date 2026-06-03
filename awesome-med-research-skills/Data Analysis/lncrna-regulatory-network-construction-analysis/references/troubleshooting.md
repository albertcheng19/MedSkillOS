# Troubleshooting

## Error Codes

### `SKILL_FILE_NOT_FOUND`

- Meaning: A target list file, reference directory, reference table, or saved `.rda` object is missing.
- Typical trigger:
  - Wrong `--reference_dir`
  - Wrong target list path
  - Running `visualize` before `analyze` or `full`
- Fix:
  - Verify the file paths and rerun

### `SKILL_MISSING_COLUMNS`

- Meaning: A required reference-table column is missing.
- Typical trigger:
  - The miRNA-mRNA table lacks `miRNA` or `mRNA`
  - The miRNA-lncRNA table lacks `miRNA` or `lncRNA`
- Fix:
  - Restore the expected reference table format

### `SKILL_INVALID_DATA`

- Meaning: A reference CSV could not be parsed or read successfully.
- Typical trigger:
  - Malformed CSV structure
  - Wrong delimiter or broken quoting
  - Encoding or file-integrity problems
- Fix:
  - Validate the CSV format, encoding, and delimiter structure
  - Replace the malformed file and rerun

### `SKILL_EMPTY_DATA`

- Meaning: No usable targets, evidence rows, or final edges remained.
- Typical trigger:
  - Target IDs are absent from the reference tables
  - `min_shared_mirna` is too strict
  - `lncrna_freq_thresh` filters all nodes
- Fix:
  - Broaden the target list
  - Reduce the filtering thresholds

### `SKILL_INVALID_PARAMETER`

- Meaning: A CLI argument is missing, invalid, or unsafe.
- Typical trigger:
  - Neither `--target_genes` nor `--target_lncrna` is provided
  - Unsupported `--mirna_dataset`
  - Unsupported `--lncrna_strictness`
  - Output directory escapes the skill root
- Fix:
  - Review the parameter table and rerun
  - In `visualize` mode, focus on whether `data/lncrna_network.rda` exists; the saved object is the required input

### `SKILL_SAMPLE_MISMATCH`

- Meaning: Reserved for workflows that require matched entities.
- Typical trigger:
  - Not expected in the database-only workflow
- Fix:
  - None for normal use

### `SKILL_PACKAGE_NOT_FOUND`

- Meaning: Required R packages are missing.
- Typical trigger:
  - `optparse` or `igraph` is not installed
- Fix:
  - Install the packages listed in `references/cli-guide.md`

## Practical Debugging Order

1. Run `Rscript scripts/main.R --help`.
2. Verify the target list files.
3. Verify `--reference_dir`.
4. Start with `--mirna_dataset combined --lncrna_strictness High --min_shared_mirna 1`.
5. Add stricter filtering only after the baseline workflow succeeds.
