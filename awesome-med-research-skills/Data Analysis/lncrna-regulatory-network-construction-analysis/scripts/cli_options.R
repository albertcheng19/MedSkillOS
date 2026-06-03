#!/usr/bin/env Rscript

build_option_parser <- function() {
  options <- list(
    optparse::make_option("--mode", type = "character", default = "full", help = "Run mode: analyze, visualize, or full [default: %default]"),
    optparse::make_option("--target_genes", type = "character", default = "", help = "Target mRNA/gene list file or comma-separated list"),
    optparse::make_option("--target_lncrna", type = "character", default = "", help = "Target lncRNA list file or comma-separated list"),
    optparse::make_option("--mirna_dataset", type = "character", default = "combined", help = "miRNA-mRNA dataset: combined, starbase, mirdb, mirtarbase, starbase+mirdb, starbase+mirtarbase, or mirdb+mirtarbase [default: %default]"),
    optparse::make_option("--lncrna_strictness", type = "character", default = "High", help = "miRNA-lncRNA strictness: Low, Median, or High [default: %default]"),
    optparse::make_option("--lncrna_freq_thresh", type = "integer", default = 0, help = "Minimum lncRNA degree threshold applied after edge aggregation [default: %default]"),
    optparse::make_option("--min_shared_mirna", type = "integer", default = 1, help = "Minimum shared miRNA count for keeping an lncRNA-mRNA edge [default: %default]"),
    optparse::make_option("--reference_dir", type = "character", default = "references/database", help = "Reference directory containing miRNA-mRNA and miRNA-lncRNA tables [default: %default]"),
    optparse::make_option("--output_dir", type = "character", default = "tests/output", help = "Output directory inside the skill root [default: %default]"),
    optparse::make_option("--plot_file", type = "character", default = "lncrna_mrna_network.pdf", help = "PDF file name under plot/ [default: %default]"),
    optparse::make_option("--plot_title", type = "character", default = "lncRNA-mRNA Regulatory Network", help = "Network plot title [default: %default]"),
    optparse::make_option("--layout_type", type = "character", default = "kk", help = "Plot layout: kk, fr, circle, or nicely [default: %default]"),
    optparse::make_option("--width", type = "double", default = 14, help = "Plot width in inches [default: %default]"),
    optparse::make_option("--height", type = "double", default = 9, help = "Plot height in inches [default: %default]"),
    optparse::make_option("--node_size_base", type = "double", default = 6, help = "Base node size [default: %default]"),
    optparse::make_option("--node_size_scale", type = "double", default = 1.5, help = "Per-degree node size increment [default: %default]"),
    optparse::make_option("--lncrna_color", type = "character", default = "#1f77b4", help = "lncRNA node color [default: %default]"),
    optparse::make_option("--mrna_color", type = "character", default = "#d62728", help = "mRNA node color [default: %default]"),
    optparse::make_option("--seed", type = "integer", default = 42, help = "Random seed [default: %default]"),
    optparse::make_option("--timeout_seconds", type = "integer", default = 0, help = "Optional timeout in seconds; 0 disables it [default: %default]")
  )
  optparse::OptionParser(option_list = options)
}

validate_cli_options <- function(opt, skill_root) {
  valid_mode <- c("analyze", "visualize", "full")
  valid_mirna_dataset <- c("combined", "starbase", "mirdb", "mirtarbase", "starbase+mirdb", "starbase+mirtarbase", "mirdb+mirtarbase")
  valid_strictness <- c("Low", "Median", "High")
  if (!opt$mode %in% valid_mode) stop_skill("SKILL_INVALID_PARAMETER", "--mode must be analyze, visualize, or full.")
  if (!opt$mirna_dataset %in% valid_mirna_dataset) stop_skill("SKILL_INVALID_PARAMETER", "--mirna_dataset is invalid.")
  if (!opt$lncrna_strictness %in% valid_strictness) stop_skill("SKILL_INVALID_PARAMETER", "--lncrna_strictness must be Low, Median, or High.")
  if (opt$min_shared_mirna < 1) stop_skill("SKILL_INVALID_PARAMETER", "--min_shared_mirna must be >= 1.")
  if (opt$lncrna_freq_thresh < 0) stop_skill("SKILL_INVALID_PARAMETER", "--lncrna_freq_thresh must be >= 0.")
  if (opt$mode %in% c("analyze", "full") && !nzchar(opt$target_genes) && !nzchar(opt$target_lncrna)) {
    stop_skill("SKILL_INVALID_PARAMETER", "Provide --target_genes, --target_lncrna, or both.")
  }
  opt$output_dir <- resolve_output_dir(opt$output_dir, skill_root)
  opt$plot_file <- validate_plot_file_name(opt$plot_file)
  ref_candidate <- if (grepl("^[A-Za-z]:[/\\\\]|^/", opt$reference_dir)) opt$reference_dir else file.path(skill_root, opt$reference_dir)
  opt$reference_dir <- normalizePath(ref_candidate, winslash = "/", mustWork = FALSE)
  if (opt$mode %in% c("analyze", "full") && !dir.exists(opt$reference_dir)) {
    stop_skill("SKILL_FILE_NOT_FOUND", sprintf("Reference directory not found: %s", opt$reference_dir))
  }
  opt
}
