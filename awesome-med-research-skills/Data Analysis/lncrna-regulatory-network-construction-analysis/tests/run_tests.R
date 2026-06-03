#!/usr/bin/env Rscript

args <- commandArgs(trailingOnly = TRUE)
output_dir <- if (length(args) >= 1) args[[1]] else "tests/output"

if (dir.exists(output_dir)) {
  unlink(output_dir, recursive = TRUE, force = TRUE)
}

full_args <- c(
  "scripts/main.R",
  "--mode", "full",
  "--target_genes", "tests/data/target_genes.txt",
  "--target_lncrna", "tests/data/target_lncrna.txt",
  "--mirna_dataset", "combined",
  "--lncrna_strictness", "High",
  "--min_shared_mirna", "1",
  "--reference_dir", "references/database",
  "--output_dir", output_dir,
  "--seed", "42"
)

status <- system2("Rscript", args = full_args)
if (!identical(status, 0L)) {
  stop("Full-workflow test failed.", call. = FALSE)
}

check_status <- system2("Rscript", args = c("tests/test_skill.R", output_dir))
if (!identical(check_status, 0L)) {
  stop("Output validation failed.", call. = FALSE)
}

visualize_args <- c(
  "scripts/main.R",
  "--mode", "visualize",
  "--reference_dir", "references/database",
  "--output_dir", output_dir,
  "--plot_file", "reused_network.pdf"
)

visualize_status <- system2("Rscript", args = visualize_args)
if (!identical(visualize_status, 0L)) {
  stop("Visualization reuse test failed.", call. = FALSE)
}

visualize_without_ref_status <- system2(
  "Rscript",
  args = c(
    "scripts/main.R",
    "--mode", "visualize",
    "--reference_dir", "missing_reference_dir",
    "--output_dir", output_dir,
    "--plot_file", "reused_network_without_refs.pdf"
  )
)
if (!identical(visualize_without_ref_status, 0L)) {
  stop("Visualization reuse without reference tables failed.", call. = FALSE)
}

bad_ref_dir <- file.path(tempdir(), "bad_reference")
if (dir.exists(bad_ref_dir)) {
  unlink(bad_ref_dir, recursive = TRUE, force = TRUE)
}
dir.create(bad_ref_dir, recursive = TRUE, showWarnings = FALSE)
utils::write.csv(
  data.frame(bad_col = "hsa-miR-1", stringsAsFactors = FALSE),
  file.path(bad_ref_dir, "miRNA_mRNA.csv"),
  row.names = FALSE
)
utils::write.csv(
  data.frame(miRNA = "hsa-miR-1", lncRNA = "XIST", stringsAsFactors = FALSE),
  file.path(bad_ref_dir, "starbase_miRNA_lncRNA_High.csv"),
  row.names = FALSE
)

bad_run <- suppressWarnings(system2(
  "Rscript",
  args = c(
    "scripts/main.R",
    "--mode", "analyze",
    "--target_genes", "TP53",
    "--reference_dir", bad_ref_dir,
    "--output_dir", "tests/output_bad_columns"
  ),
  stdout = TRUE,
  stderr = TRUE
))
bad_status <- attr(bad_run, "status")
if (is.null(bad_status)) {
  bad_status <- 0L
}
if (identical(bad_status, 0L)) {
  stop("Malformed reference table test unexpectedly succeeded.", call. = FALSE)
}
if (!any(grepl("SKILL_MISSING_COLUMNS", bad_run, fixed = TRUE))) {
  stop("Malformed reference table test did not report SKILL_MISSING_COLUMNS.", call. = FALSE)
}

manifest_lines <- readLines(file.path(output_dir, "output_manifest.txt"), warn = FALSE)
record_lines <- readLines(file.path(output_dir, "run_record.txt"), warn = FALSE)
if (!file.exists(file.path(output_dir, "plot", "reused_network.pdf"))) {
  stop("Visualization reuse did not produce reused_network.pdf.", call. = FALSE)
}
if (!file.exists(file.path(output_dir, "plot", "reused_network_without_refs.pdf"))) {
  stop("Visualization reuse without reference tables did not produce reused_network_without_refs.pdf.", call. = FALSE)
}
if (sum(grepl("Run Mode: full$", manifest_lines)) < 1 || sum(grepl("Run Mode: visualize$", manifest_lines)) < 1) {
  stop("Output manifest did not preserve both full and visualize run sections.", call. = FALSE)
}
if (sum(grepl("^- mode: full$", record_lines)) < 1 || sum(grepl("^- mode: visualize$", record_lines)) < 1) {
  stop("Run record did not preserve both full and visualize invocations.", call. = FALSE)
}

cat(sprintf("Database-driven lncRNA-mRNA network tests completed successfully: %s\n", output_dir))
