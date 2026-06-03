split_colors <- function(color_text) {
  colors <- trimws(strsplit(as.character(color_text), ",", fixed = TRUE)[[1]])
  colors <- colors[nzchar(colors)]
  if (length(colors) == 0) colors <- c("#2E889D")
  colors
}

safe_rescale <- function(values, to = c(0.2, 1)) {
  values <- as.numeric(values)
  if (length(values) == 0) return(numeric(0))
  if (all(is.na(values))) return(rep(mean(to), length(values)))
  range_values <- range(values, na.rm = TRUE)
  if (!all(is.finite(range_values)) || range_values[1] == range_values[2]) return(rep(mean(to), length(values)))
  (values - range_values[1]) / (range_values[2] - range_values[1]) * (to[2] - to[1]) + to[1]
}

resolve_layout <- function(graph_obj, layout_name) {
  name <- tolower(trimws(as.character(layout_name)))
  if (name == "kk") return(igraph::layout_with_kk(graph_obj))
  if (name == "fr") return(igraph::layout_with_fr(graph_obj))
  if (name == "nicely") return(igraph::layout_nicely(graph_obj))
  if (name == "circle") return(igraph::layout_in_circle(graph_obj))
  if (name == "star") return(igraph::layout_as_star(graph_obj))
  if (name == "grid") return(igraph::layout_on_grid(graph_obj))
  if (name == "randomly") return(igraph::layout_randomly(graph_obj))
  igraph::layout_nicely(graph_obj)
}

resolve_pdf_family <- function(family_name) {
  normalized <- tolower(trimws(as.character(family_name)))
  if (normalized %in% c("sans", "serif", "mono")) normalized else "sans"
}

resolve_vertex_shape <- function(shape_name) {
  normalized <- tolower(trimws(as.character(shape_name)))
  if (normalized == "square") "square" else "circle"
}

resolve_line_type <- function(line_type) {
  normalized <- tolower(trimws(as.character(line_type)))
  if (normalized %in% c("solid", "dashed", "dotted")) normalized else "solid"
}

apply_alpha <- function(color_value, alpha_value) grDevices::adjustcolor(color_value, alpha.f = max(0, min(1, alpha_value)))

generate_network_plot <- function(bundle, options, save_path) {
  if (is.null(bundle$interactions) || nrow(bundle$interactions) == 0) fail("SKILL_EMPTY_DATA", "Interaction table is empty and cannot be plotted.")
  graph_obj <- igraph::graph_from_data_frame(bundle$interactions, directed = FALSE)
  degree_values <- igraph::degree(graph_obj)
  edge_scores <- igraph::E(graph_obj)$combined_score

  line_colors <- split_colors(options$line_color)
  point_colors <- split_colors(options$point_color)
  point_fills <- split_colors(options$point_fill)
  map_link_alpha <- identical(options$mapping_link_alpha, "value")
  map_link_color <- identical(options$mapping_link_color, "value")
  map_link_size <- identical(options$mapping_link_size, "value")
  map_node_alpha <- identical(options$mapping_node_alpha, "value")
  map_node_color <- identical(options$mapping_node_color, "value")
  map_node_size <- identical(options$mapping_node_size, "value")

  edge_width <- if (map_link_size) safe_rescale(edge_scores, to = c(max(0.5, options$line_size * 0.8), options$line_size * 3)) else rep(options$line_size, igraph::ecount(graph_obj))
  edge_alpha <- if (map_link_alpha) safe_rescale(edge_scores, to = c(0.25, options$line_alpha)) else rep(options$line_alpha, igraph::ecount(graph_obj))
  if (map_link_color) {
    palette_fun <- grDevices::colorRampPalette(c(line_colors[1], line_colors[min(2, length(line_colors))]))
    palette_values <- palette_fun(100)
    index <- ceiling(safe_rescale(edge_scores, to = c(1, 100)))
    index[!is.finite(index)] <- 50
    edge_color <- mapply(apply_alpha, palette_values[index], edge_alpha, USE.NAMES = FALSE)
  } else {
    edge_color <- mapply(apply_alpha, rep(line_colors[1], igraph::ecount(graph_obj)), edge_alpha, USE.NAMES = FALSE)
  }

  vertex_size <- if (map_node_size) safe_rescale(degree_values, to = c(max(8, options$point_size * 0.9), options$point_size * 2.2)) else rep(options$point_size, igraph::vcount(graph_obj))
  vertex_alpha <- if (map_node_alpha) safe_rescale(degree_values, to = c(0.4, options$point_alpha)) else rep(options$point_alpha, igraph::vcount(graph_obj))
  if (map_node_color) {
    palette_fun_node <- grDevices::colorRampPalette(c(point_fills[1], point_fills[min(2, length(point_fills))]))
    palette_values_node <- palette_fun_node(100)
    index_node <- ceiling(safe_rescale(degree_values, to = c(1, 100)))
    index_node[!is.finite(index_node)] <- 50
    vertex_color <- mapply(apply_alpha, palette_values_node[index_node], vertex_alpha, USE.NAMES = FALSE)
  } else {
    vertex_color <- mapply(apply_alpha, rep(point_fills[1], igraph::vcount(graph_obj)), vertex_alpha, USE.NAMES = FALSE)
  }

  grDevices::pdf(save_path, width = options$figure_width, height = options$figure_height, family = resolve_pdf_family(options$figure_family))
  on.exit(grDevices::dev.off(), add = TRUE)
  graphics::par(mar = c(1, 1, 3, 1), family = resolve_pdf_family(options$figure_family))
  set.seed(options$seed)
  graphics::plot(
    graph_obj,
    layout = resolve_layout(graph_obj, options$style_layout),
    vertex.label = if (tolower(options$label) == "none") NA else igraph::V(graph_obj)$name,
    vertex.label.cex = options$label_size,
    vertex.label.family = resolve_pdf_family(options$figure_family),
    vertex.label.color = options$label_color,
    vertex.label.dist = options$label_dist,
    vertex.label.degree = 0,
    vertex.size = vertex_size,
    vertex.color = vertex_color,
    vertex.frame.color = rep(point_colors[1], igraph::vcount(graph_obj)),
    vertex.shape = resolve_vertex_shape(options$point_shape),
    edge.width = edge_width,
    edge.color = edge_color,
    edge.lty = resolve_line_type(options$line_type),
    edge.curved = if (tolower(options$style_line) == "curve") 0.2 else 0,
    main = if (nzchar(options$title)) options$title else ""
  )
}
