#!/usr/bin/env Rscript

filter_network_inputs <- function(target_genes, target_lncrna, mirna_mrna, mirna_lncrna) {
  if (length(target_genes)) {
    mirna_mrna <- mirna_mrna[mirna_mrna$mRNA %in% target_genes, , drop = FALSE]
  }
  if (length(target_lncrna)) {
    mirna_lncrna <- mirna_lncrna[mirna_lncrna$lncRNA %in% target_lncrna, , drop = FALSE]
  }
  list(mirna_mrna = mirna_mrna, mirna_lncrna = mirna_lncrna)
}

build_evidence_table <- function(mirna_mrna, mirna_lncrna) {
  common_mirna <- intersect(unique(mirna_mrna$miRNA), unique(mirna_lncrna$miRNA))
  if (!length(common_mirna)) {
    return(data.frame(
      lncRNA = character(),
      miRNA = character(),
      mRNA = character(),
      stringsAsFactors = FALSE
    ))
  }
  left <- mirna_lncrna[mirna_lncrna$miRNA %in% common_mirna, , drop = FALSE]
  right <- mirna_mrna[mirna_mrna$miRNA %in% common_mirna, , drop = FALSE]
  merged <- merge(left, right, by = "miRNA", all = FALSE)
  merged[, c("lncRNA", "miRNA", "mRNA")]
}

summarize_lncrna_mrna_edges <- function(evidence_tbl, min_shared_mirna, lncrna_freq_thresh) {
  if (!nrow(evidence_tbl)) {
    return(data.frame(
      lncRNA = character(),
      mRNA = character(),
      shared_miRNA_count = integer(),
      shared_miRNAs = character(),
      evidence = character(),
      stringsAsFactors = FALSE
    ))
  }
  keys <- paste(evidence_tbl$lncRNA, evidence_tbl$mRNA, sep = "|")
  split_tbl <- split(evidence_tbl$miRNA, keys)
  rows <- lapply(names(split_tbl), function(key) {
    parts <- strsplit(key, "|", fixed = TRUE)[[1]]
    shared <- sort(unique(split_tbl[[key]]))
    data.frame(
      lncRNA = parts[[1]],
      mRNA = parts[[2]],
      shared_miRNA_count = length(shared),
      shared_miRNAs = paste(shared, collapse = ";"),
      evidence = "database_supported_cerna",
      stringsAsFactors = FALSE
    )
  })
  edges <- do.call(rbind, rows)
  lnc_freq <- table(edges$lncRNA)
  keep <- edges$shared_miRNA_count >= min_shared_mirna & lnc_freq[edges$lncRNA] > lncrna_freq_thresh
  edges[keep, , drop = FALSE]
}

build_node_table <- function(edge_tbl, evidence_tbl) {
  if (!nrow(edge_tbl)) {
    return(data.frame(node = character(), type = character(), degree = integer(), stringsAsFactors = FALSE))
  }
  graph_edges <- data.frame(from = edge_tbl$lncRNA, to = edge_tbl$mRNA, stringsAsFactors = FALSE)
  graph <- igraph::graph_from_data_frame(graph_edges, directed = FALSE)
  degree_values <- igraph::degree(graph)
  nodes <- data.frame(node = names(degree_values), degree = as.integer(degree_values), stringsAsFactors = FALSE)
  nodes$type <- ifelse(nodes$node %in% edge_tbl$lncRNA, "lncRNA", "mRNA")
  nodes <- nodes[, c("node", "type", "degree")]
  nodes[order(nodes$type, nodes$node), , drop = FALSE]
}

build_input_summary <- function(target_genes, target_lncrna, filtered_mrna_rows, filtered_lncrna_rows, evidence_tbl, edge_tbl) {
  list(
    target_genes = length(target_genes),
    target_lncrna = length(target_lncrna),
    filtered_mirna_mrna_rows = filtered_mrna_rows,
    filtered_mirna_lncrna_rows = filtered_lncrna_rows,
    evidence_rows = nrow(evidence_tbl),
    lncrna_mrna_edges = nrow(edge_tbl)
  )
}
