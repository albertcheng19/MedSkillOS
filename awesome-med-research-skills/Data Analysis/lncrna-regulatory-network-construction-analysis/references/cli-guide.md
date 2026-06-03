# CLI Guide

## Install Dependencies

```r
install.packages(c("optparse", "igraph"))
```

## Reference Data Notes

- The analysis script does not perform network requests.
- The `analyze` and `full` workflows expect the local tables under `references/database`.
- If you replace the reference tables, preserve the required column names.

## Example 1: Full Workflow

```bash
Rscript scripts/main.R \
  --mode full \
  --target_genes tests/data/target_genes.txt \
  --target_lncrna tests/data/target_lncrna.txt \
  --mirna_dataset combined \
  --lncrna_strictness High \
  --reference_dir references/database \
  --output_dir tests/output \
  --seed 42
```

## Example 2: Gene-Only Network

```bash
Rscript scripts/main.R \
  --mode analyze \
  --target_genes TP53,BRCA1,MYC \
  --mirna_dataset mirtarbase \
  --lncrna_strictness High \
  --min_shared_mirna 2 \
  --reference_dir references/database \
  --output_dir ./gene_only_output
```

## Example 3: Visualization Reuse

```bash
Rscript scripts/main.R \
  --mode visualize \
  --output_dir ./gene_only_output \
  --plot_file reused_network.pdf \
  --layout_type fr
```

Note:

- `visualize` reuses `output_dir/data/lncrna_network.rda`.
- A valid saved `.rda` object is required.
- `visualize` does not need to re-read the reference tables if the saved object already exists.

## Baseline Real-Data Execution Record

This section records the current delivery baseline that uses the bundled local reference databases from `references/database`.

### Environment

- Execution context: target container used for acceptance testing
- Command family: `Rscript scripts/main.R`, `Rscript tests/run_tests.R`, `Rscript tests/test_skill.R`
- Seed: `42`

### Input Files

- Target genes: `tests/data/target_genes.txt`
- Target lncRNAs: `tests/data/target_lncrna.txt`
- miRNA-mRNA reference dataset: `references/database/miRNA_mRNA.csv`
- miRNA-lncRNA reference dataset: `references/database/starbase_miRNA_lncRNA_High.csv`

### Input Summary

- Target gene count: `3`
- Target lncRNA count: `3`
- miRNA-mRNA dataset mode: `combined`
- lncRNA strictness: `High`

### Baseline Command

```bash
Rscript scripts/main.R \
  --mode full \
  --target_genes tests/data/target_genes.txt \
  --target_lncrna tests/data/target_lncrna.txt \
  --mirna_dataset combined \
  --lncrna_strictness High \
  --min_shared_mirna 1 \
  --reference_dir references/database \
  --output_dir tests/output \
  --seed 42
```

### Output Files

| File | Description | Content |
|------|-------------|---------|
| `tests/output/table/lncrna_mrna_edges.csv` | Projected lncRNA-mRNA edge table | Includes `shared_miRNA_count`, `shared_miRNAs`, and `evidence` |
| `tests/output/table/lncrna_mirna_mrna_evidence.csv` | Tripartite evidence table | One lncRNA-miRNA-mRNA row per evidence chain |
| `tests/output/table/lncrna_mrna_nodes.csv` | Node table | Contains node type and degree |
| `tests/output/table/network_stats.txt` | Text summary | Edge totals, evidence totals, and node counts |
| `tests/output/data/lncrna_network.rda` | Serialized result object | Saved for visualization reuse |
| `tests/output/plot/lncrna_mrna_network.pdf` | Network figure | Projected lncRNA-mRNA graph |
| `tests/output/session_info.txt` | Session record | `sessionInfo()` output |
| `tests/output/output_manifest.txt` | Auto-generated manifest | One section per invocation |
| `tests/output/run_record.txt` | Auto-generated run record | Parameters, runtime, and output summary |

### Runtime And Resource Usage

| Metric | Value |
|--------|-------|
| Start time | `2026-04-20 08:34:46` |
| End time | `2026-04-20 08:34:46` |
| Elapsed time | `0.486 s` |
| User CPU time | `0.169 s` |
| System CPU time | `0.009 s` |
| Timeout setting | `0` |
| GC snapshot (Ncells) | `used 552,163 (29.5 Mb)` |
| GC snapshot (Vcells) | `used 968,711 (7.4 Mb)` |

### Recorded Result Summary

- The baseline uses the real local ceRNA reference tables bundled inside this skill.
- The projected network is database-driven and does not use expression matrices.
- The full baseline run completed successfully in the target container.
- The target lists contained `3` genes and `3` lncRNAs.
- After filtering the bundled reference tables, the run retained `5` miRNA-mRNA rows and `281` miRNA-lncRNA rows.
- The joined tripartite evidence table contained `5` lncRNA-miRNA-mRNA evidence rows.
- The projected lncRNA-mRNA network contained `4` edges across `5` nodes (`3` lncRNAs and `2` mRNAs).
- `tests/test_skill.R` confirmed that all expected output files were present.
- Re-running `visualize` in the same `output_dir` appended a second section to both `run_record.txt` and `output_manifest.txt` and generated `plot/reused_network.pdf`.
