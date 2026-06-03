read_interaction_table <- function(file_path, required_cols) {
  validate_file_exists(file_path, "Reference file")
  interaction_table <- read.csv(file_path, check.names = FALSE, stringsAsFactors = FALSE)
  missing_cols <- setdiff(required_cols, colnames(interaction_table))
  if (nrow(interaction_table) == 0) {
    skill_stop("SKILL_EMPTY_DATA", sprintf("Reference file has no rows: %s", basename(file_path)))
  }
  if (length(missing_cols) > 0) {
    skill_stop("SKILL_MISSING_COLUMNS", sprintf("Missing columns in %s: %s", basename(file_path), paste(missing_cols, collapse = ", ")))
  }
  unique(interaction_table[, required_cols, drop = FALSE])
}

parse_key_genes_input <- function(key_genes_input) {
  if (!nzchar(trimws(key_genes_input))) {
    skill_stop("SKILL_INVALID_PARAMETER", "--key_genes cannot be empty")
  }
  looks_like_path <- grepl("[/\\]", key_genes_input) || grepl("\\.[[:alnum:]]+$", key_genes_input)
  gene_lines <- if (file.exists(key_genes_input)) {
    validate_file_exists(key_genes_input, "Key gene file")
    readLines(key_genes_input, warn = FALSE)
  } else if (looks_like_path && !grepl(",", key_genes_input, fixed = TRUE)) {
    skill_stop("SKILL_FILE_NOT_FOUND", sprintf("Key gene file does not exist: %s", key_genes_input))
  } else {
    unlist(strsplit(key_genes_input, ",", fixed = TRUE), use.names = FALSE)
  }
  clean_key_genes(gene_lines)
}

load_mirna_mrna_dataset <- function(mirna_dataset, reference_dir) {
  dataset_map <- list(
    combined = list(file = "miRNA_mRNA.csv", description = "Intersection of three databases (combined)"),
    starbase = list(file = "starbase_miRNA_mRNA.csv", description = "Single database: starbase"),
    mirdb = list(file = "miRDB_miRNA_mRNA.csv", description = "Single database: mirdb"),
    mirtarbase = list(file = "miRTarbase_miRNA_mRNA.csv", description = "Single database: mirtarbase")
  )
  pair_map <- list("starbase+mirdb" = c("starbase", "miRDB"), "starbase+mirtarbase" = c("starbase", "miRTarbase"), "mirdb+mirtarbase" = c("miRDB", "miRTarbase"))
  if (mirna_dataset %in% names(dataset_map)) {
    file_name <- dataset_map[[mirna_dataset]]$file
    return(list(data = read_interaction_table(file.path(reference_dir, file_name), c("miRNA", "mRNA")), description = dataset_map[[mirna_dataset]]$description))
  }
  table_list <- lapply(pair_map[[mirna_dataset]], function(db_name) {
    read_interaction_table(file.path(reference_dir, paste0(db_name, "_miRNA_mRNA.csv")), c("miRNA", "mRNA"))
  })
  list(data = combine_pair_tables(table_list), description = paste("Intersection of", gsub("\\+", " and ", mirna_dataset)))
}

load_mirna_lncrna_dataset <- function(reference_dir, strictness) {
  read_interaction_table(file.path(reference_dir, paste0("starbase_miRNA_lncRNA_", strictness, ".csv")), c("miRNA", "lncRNA"))
}

save_network_outputs <- function(network, output_dir) {
  ensure_dir(output_dir)
  write.csv(network$edges, file.path(output_dir, "ceRNA_network_edges.csv"), row.names = FALSE)
  write.csv(network$nodes, file.path(output_dir, "ceRNA_network_nodes.csv"), row.names = FALSE)
  list(plot_file = file.path(output_dir, "ceRNA_network.pdf"))
}
