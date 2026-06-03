build_network_tables <- function(interactions) {
  graph_obj <- igraph::graph_from_data_frame(interactions, directed = FALSE)
  nodes <- data.frame(
    gene = igraph::V(graph_obj)$name,
    degree = igraph::degree(graph_obj),
    betweenness = igraph::betweenness(graph_obj, directed = FALSE, normalized = TRUE),
    closeness = igraph::closeness(graph_obj, normalized = TRUE),
    stringsAsFactors = FALSE
  )
  list(graph = graph_obj, nodes = nodes)
}

build_summary_table <- function(input_genes, mapped_data, nodes, interactions, threshold) {
  data.frame(
    metric = c("input_genes", "mapped_genes", "unmapped_genes", "nodes_in_network", "edges_in_network", "threshold"),
    value = c(length(input_genes), nrow(mapped_data), length(setdiff(input_genes, mapped_data$gene)), nrow(nodes), nrow(interactions), threshold),
    stringsAsFactors = FALSE
  )
}

run_ppi_analysis <- function(genes, species_meta, threshold, cache_files) {
  mapped_data <- map_genes_to_string_local(genes, cache_files$aliases, cache_files$info)
  if (is.null(mapped_data) || nrow(mapped_data) == 0) fail("SKILL_EMPTY_DATA", "No input genes were mapped to STRING from the local cache.")
  mapped_data <- dplyr::distinct(mapped_data, gene, STRING_id, .keep_all = TRUE)
  string_ids <- unique(mapped_data$STRING_id)
  if (length(string_ids) < 2) fail("SKILL_EMPTY_DATA", "Fewer than two mapped STRING IDs remained; a network cannot be constructed.")

  interactions_raw <- get_interactions_local(string_ids, cache_files$links, threshold)
  if (is.null(interactions_raw) || nrow(interactions_raw) == 0) fail("SKILL_EMPTY_DATA", "No STRING interactions were found under the selected threshold.")
  interactions <- dplyr::mutate(interactions_raw, from_symbol = mapped_data$gene[match(from, mapped_data$STRING_id)], to_symbol = mapped_data$gene[match(to, mapped_data$STRING_id)])
  interactions <- dplyr::filter(interactions, !is.na(from_symbol), !is.na(to_symbol), from_symbol != to_symbol)
  interactions <- dplyr::distinct(dplyr::transmute(interactions, from = from_symbol, to = to_symbol, combined_score = combined_score))
  if (nrow(interactions) == 0) fail("SKILL_EMPTY_DATA", "No valid gene-symbol interactions remained after mapping STRING IDs.")

  network_tables <- build_network_tables(interactions)
  summary_df <- build_summary_table(genes, mapped_data, network_tables$nodes, interactions, threshold)
  list(
    genes = genes,
    species = species_meta$species,
    species_id = species_meta$species_id,
    species_latin = species_meta$species_latin,
    threshold = threshold,
    string_cache_version = cache_files$version,
    mapped_data = mapped_data,
    interactions = interactions,
    nodes = network_tables$nodes,
    summary = summary_df
  )
}
