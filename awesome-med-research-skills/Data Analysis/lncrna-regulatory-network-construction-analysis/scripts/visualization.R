#!/usr/bin/env Rscript

generate_network_plot <- function(edge_tbl, node_tbl, opt) {
  plot_path <- file.path(opt$output_dir, "plot", opt$plot_file)
  if (!nrow(edge_tbl)) {
    stop_skill("SKILL_EMPTY_DATA", "No lncRNA-mRNA edges are available for plotting.")
  }
  graph <- igraph::graph_from_data_frame(
    data.frame(from = edge_tbl$lncRNA, to = edge_tbl$mRNA, stringsAsFactors = FALSE),
    vertices = node_tbl,
    directed = FALSE
  )
  igraph::V(graph)$color <- ifelse(igraph::V(graph)$type == "lncRNA", opt$lncrna_color, opt$mrna_color)
  igraph::V(graph)$size <- opt$node_size_base + igraph::V(graph)$degree * opt$node_size_scale
  layout_coords <- compute_layout(graph, opt$layout_type)

  grDevices::pdf(plot_path, width = opt$width, height = opt$height)
  on.exit({
    if (grDevices::dev.cur() > 1) grDevices::dev.off()
  }, add = TRUE)
  plot(
    graph,
    layout = layout_coords,
    vertex.label = igraph::V(graph)$name,
    vertex.label.cex = 0.75,
    vertex.label.color = "black",
    vertex.frame.color = NA,
    vertex.color = igraph::V(graph)$color,
    vertex.size = igraph::V(graph)$size,
    edge.color = "#B7B7B7",
    edge.width = pmax(1, edge_tbl$shared_miRNA_count),
    main = opt$plot_title
  )
  graphics::legend("topright", legend = c("lncRNA", "mRNA"), col = c(opt$lncrna_color, opt$mrna_color), pch = 16, bty = "n")
  plot_path
}
