save_tables <- function(bundle, output_dir) {
  openxlsx::write.xlsx(bundle$interactions, file.path(output_dir, "table", "ppi_network_edges.xlsx"))
  openxlsx::write.xlsx(bundle$nodes, file.path(output_dir, "table", "ppi_network_nodes.xlsx"))
  utils::write.csv(bundle$summary, file.path(output_dir, "table", "ppi_summary.csv"), row.names = FALSE)
}

run_analysis <- function(options) {
  bundle_path <- file.path(options$output_dir, "data", "ppi_result.rds")
  if (isTRUE(options$plot_only)) {
    if (!file.exists(bundle_path)) fail("SKILL_FILE_NOT_FOUND", sprintf("Plot-only mode requires an existing bundle: %s", bundle_path))
    bundle <- readRDS(bundle_path)
  } else {
    log_info("Reading gene list.")
    genes <- read_gene_list(options$genelist_file)
    species_meta <- resolve_species_meta(options$species)
    if (options$threshold < 700) log_warn("Threshold is below 700. Consider >=700 for higher-confidence STRING interactions.")
    cache_files <- resolve_string_cache_files(species_meta, options$string_cache_dir, options$string_version)
    log_info(sprintf("Using STRING cache version: %s", cache_files$version))
    log_info("Building PPI network from local STRING cache.")
    bundle <- run_ppi_analysis(genes, species_meta, options$threshold, cache_files)
    ensure_dir(options$output_dir)
    ensure_dir(file.path(options$output_dir, "data"))
    ensure_dir(file.path(options$output_dir, "table"))
    ensure_dir(file.path(options$output_dir, "plot"))
    saveRDS(bundle, bundle_path)
    save_tables(bundle, options$output_dir)
  }

  ensure_dir(file.path(options$output_dir, "plot"))
  log_info("Generating network plot.")
  generate_network_plot(bundle, options, file.path(options$output_dir, "plot", "ppi_network_plot.pdf"))
  invisible(bundle)
}
