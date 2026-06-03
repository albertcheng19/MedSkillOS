build_layout <- function(graph, layout_type) {
  layout_map <- list(
    kk = igraph::layout_with_kk,
    fr = igraph::layout_with_fr,
    nicely = igraph::layout_nicely,
    circle = igraph::layout_in_circle,
    grid = igraph::layout_on_grid,
    randomly = igraph::layout_randomly
  )
  layout_fun <- layout_map[[layout_type]]
  if (is.null(layout_fun)) {
    skill_stop("SKILL_INVALID_PARAMETER", "--layout_type must be one of kk, fr, nicely, circle, grid, randomly")
  }
  if (layout_type %in% c("circle", "grid", "randomly")) layout_fun(graph) else layout_fun(graph, dim = 2)
}

build_plot_graph <- function(edges_df, nodes_df, colors, node_size_base) {
  graph <- igraph::graph_from_data_frame(edges_df[, c("node1", "node2")], directed = FALSE)
  igraph::V(graph)$type <- nodes_df$type[match(igraph::V(graph)$name, nodes_df$node)]
  igraph::V(graph)$degree <- nodes_df$degree[match(igraph::V(graph)$name, nodes_df$node)]
  if (anyNA(igraph::V(graph)$type) || anyNA(igraph::V(graph)$degree)) {
    skill_stop("SKILL_INVALID_DATA", "Node metadata does not match the graph vertices")
  }
  min_degree <- min(igraph::V(graph)$degree)
  max_degree <- max(igraph::V(graph)$degree)
  igraph::V(graph)$size <- if (max_degree > min_degree) {
    node_size_base * (0.5 + 1.5 * (igraph::V(graph)$degree - min_degree) / (max_degree - min_degree))
  } else {
    rep(node_size_base, igraph::gorder(graph))
  }
  igraph::V(graph)$color <- colors[igraph::V(graph)$type]
  igraph::V(graph)$shape <- c(mRNA = "circle", lncRNA = "square", miRNA = "csquare")[igraph::V(graph)$type]
  graph
}

write_plot_pdf <- function(graph, output_file, width, height, label_size, layout_type, show_legend, colors, title_text) {
  grDevices::pdf(output_file, width = width, height = height)
  on.exit(grDevices::dev.off(), add = TRUE)
  graphics::par(bg = "white", mar = c(0.5, 0.5, 1.5, 0.5), family = "sans")
  plot(
    graph,
    layout = build_layout(graph, layout_type),
    vertex.color = grDevices::adjustcolor(igraph::V(graph)$color, alpha.f = 0.95),
    vertex.size = igraph::V(graph)$size,
    vertex.shape = igraph::V(graph)$shape,
    vertex.frame.color = NA,
    vertex.label = igraph::V(graph)$name,
    vertex.label.cex = label_size,
    vertex.label.color = "black",
    edge.color = grDevices::adjustcolor("#CCCCCC", alpha.f = 0.8),
    edge.width = 1,
    main = title_text
  )
  if (isTRUE(show_legend)) {
    graphics::legend("topright", legend = c("mRNA", "lncRNA", "miRNA"), col = unname(colors), pch = c(16, 15, 17), pt.cex = 1.5, bty = "n", title = "Node Type")
  }
}

generate_ceRNA_plot <- function(edges_df, nodes_df, output_file, width, height, layout_type,
                                mrna_color, lncrna_color, mirna_color, node_size_base,
                                label_size, show_legend, title_text) {
  colors <- c(mRNA = mrna_color, lncRNA = lncrna_color, miRNA = mirna_color)
  graph <- build_plot_graph(edges_df, nodes_df, colors, node_size_base)
  write_plot_pdf(graph, output_file, width, height, label_size, layout_type, show_legend, colors, title_text)
}
