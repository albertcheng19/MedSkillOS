#!/usr/bin/env Rscript

append_report_block <- function(path, lines) {
  existing <- file.exists(path)
  con <- file(path, open = if (existing) "at" else "wt")
  on.exit(close(con), add = TRUE)
  if (existing) {
    writeLines(c("", strrep("=", 72), "", lines), con = con, sep = "\n", useBytes = TRUE)
  } else {
    writeLines(lines, con = con, sep = "\n", useBytes = TRUE)
  }
  path
}

write_output_manifest <- function(output_dir, output_items, opt, runtime_info) {
  lines <- c("Output Files", "============", "", sprintf("Run Mode: %s", opt$mode), sprintf("Generated At: %s", runtime_info$end_time), "")
  for (item in output_items) {
    lines <- c(lines, sprintf("- %s", item$path), sprintf("  Description: %s", item$description), sprintf("  Content: %s", item$content), "")
  }
  append_report_block(file.path(output_dir, "output_manifest.txt"), lines)
}

write_run_record <- function(output_dir, opt, runtime_info, input_info, output_items) {
  lines <- c(
    "Run Record", "==========", "",
    "Input Parameters", "----------------",
    sprintf("- mode: %s", opt$mode),
    sprintf("- target_genes: %s", opt$target_genes %||% "N/A"),
    sprintf("- target_lncrna: %s", opt$target_lncrna %||% "N/A"),
    sprintf("- mirna_dataset: %s", opt$mirna_dataset),
    sprintf("- lncrna_strictness: %s", opt$lncrna_strictness),
    sprintf("- lncrna_freq_thresh: %s", opt$lncrna_freq_thresh),
    sprintf("- min_shared_mirna: %s", opt$min_shared_mirna),
    sprintf("- reference_dir: %s", opt$reference_dir),
    sprintf("- seed: %s", opt$seed),
    sprintf("- output_dir: %s", opt$output_dir),
    "",
    "Input Summary", "-------------",
    sprintf("- target_genes_count: %s", input_info$target_genes %||% "N/A"),
    sprintf("- target_lncrna_count: %s", input_info$target_lncrna %||% "N/A"),
    sprintf("- filtered_mirna_mrna_rows: %s", input_info$filtered_mirna_mrna_rows %||% "N/A"),
    sprintf("- filtered_mirna_lncrna_rows: %s", input_info$filtered_mirna_lncrna_rows %||% "N/A"),
    sprintf("- evidence_rows: %s", input_info$evidence_rows %||% "N/A"),
    sprintf("- lncrna_mrna_edges: %s", input_info$lncrna_mrna_edges %||% "N/A"),
    "",
    "Runtime And Resource Notes", "--------------------------",
    sprintf("- start_time: %s", runtime_info$start_time),
    sprintf("- end_time: %s", runtime_info$end_time),
    sprintf("- elapsed_seconds: %.3f", runtime_info$elapsed_seconds),
    sprintf("- user_cpu_seconds: %.3f", runtime_info$user_cpu_seconds),
    sprintf("- system_cpu_seconds: %.3f", runtime_info$system_cpu_seconds),
    sprintf("- timeout_seconds: %s", opt$timeout_seconds),
    "- gc_snapshot:"
  )
  lines <- c(lines, paste0("  ", runtime_info$gc_snapshot), "", "Output Summary", "--------------")
  for (item in output_items) lines <- c(lines, sprintf("- %s", item$path), sprintf("  Description: %s", item$description))
  append_report_block(file.path(output_dir, "run_record.txt"), lines)
}
