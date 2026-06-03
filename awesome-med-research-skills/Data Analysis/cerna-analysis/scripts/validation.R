get_required_reference_files <- function(mirna_dataset, strictness) {
  mirna_files <- switch(
    mirna_dataset,
    combined = "miRNA_mRNA.csv",
    starbase = "starbase_miRNA_mRNA.csv",
    mirdb = "miRDB_miRNA_mRNA.csv",
    mirtarbase = "miRTarbase_miRNA_mRNA.csv",
    "starbase+mirdb" = c("starbase_miRNA_mRNA.csv", "miRDB_miRNA_mRNA.csv"),
    "starbase+mirtarbase" = c("starbase_miRNA_mRNA.csv", "miRTarbase_miRNA_mRNA.csv"),
    "mirdb+mirtarbase" = c("miRDB_miRNA_mRNA.csv", "miRTarbase_miRNA_mRNA.csv"),
    skill_stop("SKILL_INVALID_PARAMETER", sprintf("--mirna_dataset must be one of %s", paste(c("combined", "starbase", "mirdb", "mirtarbase", "starbase+mirdb", "starbase+mirtarbase", "mirdb+mirtarbase"), collapse = ", ")))
  )

  unique(c(mirna_files, paste0("starbase_miRNA_lncRNA_", strictness, ".csv")))
}

validate_reference_files <- function(reference_dir, mirna_dataset, strictness) {
  if (!dir.exists(reference_dir)) {
    skill_stop("SKILL_FILE_NOT_FOUND", sprintf("Reference directory does not exist: %s", reference_dir))
  }
  required_files <- get_required_reference_files(mirna_dataset, strictness)
  missing_files <- required_files[!file.exists(file.path(reference_dir, required_files))]
  if (length(missing_files) > 0) {
    skill_stop("SKILL_FILE_NOT_FOUND", sprintf("Missing reference file(s): %s", paste(missing_files, collapse = ", ")))
  }
  invisible(TRUE)
}

validate_main_options <- function(opt) {
  if (is.null(opt$key_genes)) {
    skill_stop("SKILL_INVALID_PARAMETER", "--key_genes is required")
  }
  validate_choice(opt$mirna_dataset, c("combined", "starbase", "mirdb", "mirtarbase", "starbase+mirdb", "starbase+mirtarbase", "mirdb+mirtarbase"), "--mirna_dataset")
  validate_choice(opt$lncrna_strictness, c("Low", "Median", "High"), "--lncrna_strictness")
  validate_choice(opt$layout_type, c("kk", "fr", "nicely", "circle", "grid", "randomly"), "--layout_type")
  validate_non_negative_integer(opt$lncrna_freq_thresh, "--lncrna_freq_thresh")
  validate_non_negative_integer(opt$seed, "--seed")
  validate_positive_number(opt$plot_width, "--plot_width")
  validate_positive_number(opt$plot_height, "--plot_height")
  validate_positive_number(opt$node_size_base, "--node_size_base")
  validate_positive_number(opt$label_size, "--label_size")
  validate_positive_number(opt$timeout_seconds, "--timeout_seconds")
  validate_color(opt$mrna_color, "--mrna_color")
  validate_color(opt$lncrna_color, "--lncrna_color")
  validate_color(opt$mirna_color, "--mirna_color")
}
