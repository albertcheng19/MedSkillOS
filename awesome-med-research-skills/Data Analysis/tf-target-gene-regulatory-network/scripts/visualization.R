# Network visualization functions for TF Regulatory Network Analysis

# Main network visualization function
run_network_visualization <- function(output_dir, vis_params, script_dir = ".") {
  log_info("Starting network visualization...")
  
  # Check visualization dependencies
  check_pkg("tidyverse")
  check_pkg("tidygraph")
  check_pkg("ggraph")
  check_pkg("openxlsx")
  check_pkg("showtext")
  
  # Load network data
  network_files <- validate_network_data(output_dir)
  
  # Parse visualization parameters
  params <- parse_visualization_params(vis_params)
  
  # Set working directory for visualization
  original_wd <- getwd()
  setwd(output_dir)
  showtext_auto()
  
  # Create graph object
  log_info("Creating network graph...")
  graph <- create_network_graph(network_files$edges, network_files$nodes)
  
  # Generate network plot
  p <- generate_network_plot(graph, params, vis_params)
  
  # Save plot
  log_info("Saving plot...")
  suppressWarnings({
    ggsave("plot/TF_Network_Plot.pdf", p, width = vis_params$width, height = vis_params$height)
  })
  
  # Restore original working directory
  setwd(original_wd)
  
  log_info(paste("Network plot saved to:", file.path(output_dir, "plot/TF_Network_Plot.pdf")))
  log_info("TF-target network visualization completed successfully")
  
  invisible(p)
}

# Create network graph from edges and nodes
create_network_graph <- function(edges_df, nodes_df) {
  as_tbl_graph(edges_df, directed = TRUE) %>%
    activate(nodes) %>%
    left_join(nodes_df, by = c("name" = "node")) %>%
    mutate(type = factor(type, levels = c("TF", "Target")))  # Convert to factor for consistent mapping
}

# Generate network plot with specified parameters
generate_network_plot <- function(graph, params, vis_params) {
  # Create edge aesthetics
  edge_aes <- create_edge_aesthetics(vis_params)
  
  # Generate plot
  p <- suppressWarnings({
    ggraph(graph, layout = params$layout) +
      (if (vis_params$style_line == "curve") {
        geom_edge_diagonal(
          edge_aes,
          color = if (vis_params$mapping_link_color == "none") vis_params$line_color else NULL,
          linetype = params$line_type,
          arrow = arrow(length = unit(2, 'mm')), end_cap = circle(5, 'mm'),
          show.legend = (vis_params$mapping_link_color != "none")
        )
      } else {
        geom_edge_link(
          edge_aes,
          color = if (vis_params$mapping_link_color == "none") vis_params$line_color else NULL,
          linetype = params$line_type,
          arrow = arrow(length = unit(2, 'mm')), end_cap = circle(5, 'mm'),
          show.legend = (vis_params$mapping_link_color != "none")
        )
      }) +
      # Node layer
      geom_node_point(
        aes(fill = type, shape = type),
        color = vis_params$point_color, size = 8, stroke = 1.2
      ) +
      scale_fill_manual(values = c("TF" = "#E64B35", "Target" = "#4DBBD5")) +
      scale_shape_manual(values = c("TF" = params$shapes[2], "Target" = params$shapes[1]))
  })
  
  # Add labels if requested
  if (vis_params$label == "node") {
    p <- p + geom_node_text(
      aes(label = name),
      repel = TRUE,
      size = params$label_size,
      family = vis_params$family,
      bg.color = "white", bg.r = 0.1
    )
  }
  
  # Customize theme
  p <- p + labs(title = vis_params$title, x = vis_params$title_x) +
    theme_graph(base_family = vis_params$family, base_size = params$base_size) +
    theme(
      legend.position = params$legend_position,
      plot.title = element_text(size = params$base_size * 2, face = "bold")
    )
  
  p
}

# Create edge aesthetics based on mapping parameters
create_edge_aesthetics <- function(vis_params) {
  edge_aes <- aes()
  
  if (vis_params$mapping_link_alpha != "none") {
    edge_aes <- modifyList(edge_aes, aes(edge_alpha = Value))
  }
  if (vis_params$mapping_link_color != "none") {
    edge_aes <- modifyList(edge_aes, aes(edge_colour = Value))
  }
  if (vis_params$mapping_link_size != "none") {
    edge_aes <- modifyList(edge_aes, aes(edge_width = Value))
  }
  if (vis_params$mapping_link_type != "none") {
    edge_aes <- modifyList(edge_aes, aes(edge_linetype = Value))
  }
  
  edge_aes
}