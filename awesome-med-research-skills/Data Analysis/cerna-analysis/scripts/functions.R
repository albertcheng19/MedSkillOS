clean_key_genes <- function(gene_lines) {
  cleaned <- trimws(gene_lines)
  cleaned <- cleaned[nzchar(cleaned) & !grepl("^#", cleaned)]
  duplicate_count <- length(cleaned) - length(unique(cleaned))
  if (duplicate_count > 0) {
    log_warn(sprintf("Removed %d duplicate key genes", duplicate_count))
  }
  cleaned <- unique(cleaned)
  if (length(cleaned) == 0) {
    skill_stop("SKILL_INVALID_DATA", "No valid key genes were provided")
  }
  cleaned
}

combine_pair_tables <- function(table_list) {
  pair_lists <- lapply(table_list, function(tbl) paste(tbl$miRNA, tbl$mRNA, sep = "\r"))
  common_pairs <- Reduce(intersect, pair_lists)
  if (length(common_pairs) == 0) {
    return(data.frame(miRNA = character(), mRNA = character(), stringsAsFactors = FALSE))
  }
  split_pairs <- strsplit(common_pairs, "\r", fixed = TRUE)
  data.frame(
    miRNA = vapply(split_pairs, `[`, character(1), 1),
    mRNA = vapply(split_pairs, `[`, character(1), 2),
    stringsAsFactors = FALSE
  )
}

filter_mirna_mrna_pairs <- function(mirna_mrna, key_genes) {
  filtered <- unique(mirna_mrna[mirna_mrna$mRNA %in% key_genes, c("miRNA", "mRNA"), drop = FALSE])
  if (nrow(filtered) == 0) {
    skill_stop("SKILL_INVALID_DATA", "No miRNA-mRNA interactions matched the provided key genes")
  }
  filtered
}

filter_mirna_lncrna_pairs <- function(mirna_lncrna, mirnas, freq_threshold) {
  filtered <- unique(mirna_lncrna[mirna_lncrna$miRNA %in% mirnas, c("miRNA", "lncRNA"), drop = FALSE])
  if (nrow(filtered) == 0) {
    return(filtered)
  }
  lnc_frequency <- table(filtered$lncRNA)
  keep_lncrna <- names(lnc_frequency)[lnc_frequency >= freq_threshold]
  unique(filtered[filtered$lncRNA %in% keep_lncrna, , drop = FALSE])
}

build_network_tables <- function(mirna_mrna, mirna_lncrna) {
  if (nrow(mirna_mrna) == 0) {
    skill_stop("SKILL_INVALID_DATA", "At least one miRNA-mRNA interaction is required")
  }
  edges_df <- unique(rbind(
    setNames(mirna_mrna, c("node1", "node2")),
    if (nrow(mirna_lncrna) > 0) setNames(mirna_lncrna, c("node1", "node2")) else NULL
  ))
  nodes_df <- data.frame(node = unique(c(edges_df$node1, edges_df$node2)), stringsAsFactors = FALSE)
  nodes_df$type <- ifelse(
    nodes_df$node %in% unique(edges_df$node1),
    "miRNA",
    ifelse(nodes_df$node %in% unique(mirna_mrna$mRNA), "mRNA", "lncRNA")
  )
  graph <- igraph::graph_from_data_frame(edges_df, directed = FALSE)
  nodes_df$degree <- unname(igraph::degree(graph)[nodes_df$node])
  list(edges = edges_df, nodes = nodes_df)
}
