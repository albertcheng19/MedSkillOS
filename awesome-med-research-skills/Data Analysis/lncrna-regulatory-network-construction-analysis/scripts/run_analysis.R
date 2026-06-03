#!/usr/bin/env Rscript

run_analysis_mode <- function(opt) {
  target_genes <- read_id_list(opt$target_genes, "target_genes")
  target_lncrna <- read_id_list(opt$target_lncrna, "target_lncrna")
  mirna_mrna <- load_mirna_mrna_db(opt$reference_dir, opt$mirna_dataset)
  mirna_lncrna <- load_mirna_lncrna_db(opt$reference_dir, opt$lncrna_strictness)
  filtered <- filter_network_inputs(target_genes, target_lncrna, mirna_mrna, mirna_lncrna)
  evidence_tbl <- build_evidence_table(filtered$mirna_mrna, filtered$mirna_lncrna)
  edge_tbl <- summarize_lncrna_mrna_edges(evidence_tbl, opt$min_shared_mirna, opt$lncrna_freq_thresh)
  if (!nrow(edge_tbl)) {
    stop_skill("SKILL_EMPTY_DATA", "No lncRNA-mRNA edges remained after shared-miRNA filtering.")
  }
  node_tbl <- build_node_table(edge_tbl, evidence_tbl)

  edge_file <- file.path(opt$output_dir, "table", "lncrna_mrna_edges.csv")
  evidence_file <- file.path(opt$output_dir, "table", "lncrna_mirna_mrna_evidence.csv")
  node_file <- file.path(opt$output_dir, "table", "lncrna_mrna_nodes.csv")
  stats_file <- file.path(opt$output_dir, "table", "network_stats.txt")
  rda_file <- file.path(opt$output_dir, "data", "lncrna_network.rda")

  utils::write.csv(edge_tbl, edge_file, row.names = FALSE)
  utils::write.csv(evidence_tbl, evidence_file, row.names = FALSE)
  utils::write.csv(node_tbl, node_file, row.names = FALSE)
  writeLines(
    c(
      "lncRNA-mRNA Database Network Statistics",
      sprintf("Total lncRNA-mRNA edges: %s", nrow(edge_tbl)),
      sprintf("Total evidence rows: %s", nrow(evidence_tbl)),
      sprintf("Total nodes: %s", nrow(node_tbl)),
      sprintf("lncRNA nodes: %s", sum(node_tbl$type == "lncRNA")),
      sprintf("mRNA nodes: %s", sum(node_tbl$type == "mRNA")),
      sprintf("Minimum shared miRNA threshold: %s", opt$min_shared_mirna)
    ),
    stats_file
  )
  network_result <- list(edges = edge_tbl, evidence = evidence_tbl, nodes = node_tbl, options = opt)
  save(network_result, file = rda_file)
  write_session_info(opt$output_dir)

  list(
    edge_tbl = edge_tbl,
    evidence_tbl = evidence_tbl,
    node_tbl = node_tbl,
    edge_file = edge_file,
    evidence_file = evidence_file,
    node_file = node_file,
    stats_file = stats_file,
    rda_file = rda_file,
    input_info = build_input_summary(target_genes, target_lncrna, nrow(filtered$mirna_mrna), nrow(filtered$mirna_lncrna), evidence_tbl, edge_tbl)
  )
}

run_visualization_mode <- function(opt) {
  rda_file <- file.path(opt$output_dir, "data", "lncrna_network.rda")
  if (!file.exists(rda_file)) {
    stop_skill("SKILL_FILE_NOT_FOUND", sprintf("Saved network object not found: %s", rda_file))
  }
  load(rda_file)
  list(plot_file = generate_network_plot(network_result$edges, network_result$nodes, opt))
}
