run_cerna_analysis <- function(opt) {
  validate_reference_files(opt$reference_dir, opt$mirna_dataset, opt$lncrna_strictness)
  log_info("Step 1/5: Reading key genes")
  key_genes <- parse_key_genes_input(opt$key_genes)
  log_info(sprintf("Loaded %d key genes", length(key_genes)))

  log_info("Step 2/5: Loading miRNA-mRNA interactions")
  mirna_dataset <- load_mirna_mrna_dataset(opt$mirna_dataset, opt$reference_dir)
  filtered_mirna_mrna <- filter_mirna_mrna_pairs(mirna_dataset$data, key_genes)
  log_info(sprintf("Matched %d miRNA-mRNA pairs", nrow(filtered_mirna_mrna)))

  log_info("Step 3/5: Loading miRNA-lncRNA interactions")
  mirna_lncrna <- load_mirna_lncrna_dataset(opt$reference_dir, opt$lncrna_strictness)
  filtered_mirna_lncrna <- filter_mirna_lncrna_pairs(mirna_lncrna, unique(filtered_mirna_mrna$miRNA), opt$lncrna_freq_thresh)
  log_info(sprintf("Matched %d miRNA-lncRNA pairs", nrow(filtered_mirna_lncrna)))
  if (nrow(filtered_mirna_lncrna) == 0) {
    skill_stop(
      "SKILL_INVALID_DATA",
      "No miRNA-lncRNA interactions remained after filtering; the ceRNA layer collapsed. Lower --lncrna_freq_thresh or choose a different dataset/strictness."
    )
  }

  log_info("Step 4/5: Building the ceRNA network")
  network <- build_network_tables(filtered_mirna_mrna, filtered_mirna_lncrna)
  outputs <- save_network_outputs(network, opt$output_dir)

  log_info("Step 5/5: Writing the network plot")
  generate_ceRNA_plot(network$edges, network$nodes, outputs$plot_file, opt$plot_width, opt$plot_height, opt$layout_type, opt$mrna_color, opt$lncrna_color, opt$mirna_color, opt$node_size_base, opt$label_size, opt$show_legend, sprintf("ceRNA network (%s)", opt$mirna_dataset))
  outputs
}
