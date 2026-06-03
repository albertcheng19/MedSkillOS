# Core functions for TF Regulatory Network Analysis

#' Filter TF-target relationships from Dorothea database
#'
#' Filters Dorothea database for target genes in the input list,
#' keeps only confidence levels A/B/C, and computes TF frequencies.
#'
#' @param dt_data Dorothea database tibble
#' @param gene_list List of target genes to filter (character vector)
#' 
#' @return Filtered tibble with TF-target relationships
#' @throws SKILL_EMPTY_RESULTS if no TF-target relationships found
#' 
#' @examples
#' \dontrun{
#' data(dorothea_hs)
#' filter_tf_targets(dorothea_hs, c("TP53", "MYC", "EGFR"))
#' }
filter_tf_targets <- function(dt_data, gene_list) {
  log_info("Filtering targets and computing TF frequencies...")
  
  filtered_table <- dt_data %>%
    rename_with(~tolower(.), everything()) %>%
    filter(target %in% gene_list) %>%
    filter(confidence %in% c("A", "B", "C")) %>%
    group_by(tf) %>%
    mutate(target_count = n()) %>%
    ungroup() %>%
    arrange(desc(target_count), tf) %>%
    rename(TF = tf, Target = target, Confidence = confidence, Target_Count = target_count)
  
  if (nrow(filtered_table) == 0) {
    log_error("No TF-target relationships found in Dorothea database (confidence levels A/B/C)")
    log_error("Possible reasons:")
    log_error("1. Gene symbols not official (use TP53 not p53)")
    log_error("2. Wrong species selected")
    log_error("3. Genes not in Dorothea database coverage")
    stop("SKILL_EMPTY_RESULTS: No TF-target relationships found")
  }
  
  log_info(paste("Found", nrow(filtered_table), "TF-target relationships"))
  filtered_table
}

#' Prepare network data (edges and nodes)
#'
#' Converts filtered TF-target table into network data structure
#' with edge list (TF → Target) and node attributes.
#'
#' @param filtered_table Filtered TF-target relationships from filter_tf_targets()
#' 
#' @return List with three components:
#'   - edges: Edge data (node1, node2, Value)
#'   - nodes: Node data (node, type: TF/Target)
#'   - filtered_table: Original filtered table
#' 
#' @examples
#' \dontrun{
#' filtered <- filter_tf_targets(dorothea_data, genes)
#' network <- prepare_network_data(filtered)
#' }
prepare_network_data <- function(filtered_table) {
  # Create edge data
  edge_data <- filtered_table %>%
    select(node1 = TF, node2 = Target, Value = Target_Count) %>%
    distinct()
  
  # Create node data
  node_list <- rbind(
    data.frame(node = unique(filtered_table$TF), type = "TF"),
    data.frame(node = unique(filtered_table$Target), type = "Target")
  ) %>% distinct(node, .keep_all = TRUE)
  
  list(edges = edge_data, nodes = node_list, filtered_table = filtered_table)
}

#' Save network results to Excel
#'
#' Saves network data to Excel files with standardized structure.
#'
#' @param network_data Network data from prepare_network_data()
#' @param output_dir Output directory path
#' @param species_choice Species identifier ("human" or "mouse")
#' 
#' @return Invisibly returns list of saved file paths
#' 
#' @examples
#' \dontrun{
#' save_network_results(network_data, "./results", "human")
#' }
save_network_results <- function(network_data, output_dir, species_choice) {
  log_info("Saving results...")
  
  # Save network structure (edges and nodes)
  wb <- createWorkbook()
  addWorksheet(wb, "edges")
  writeData(wb, "edges", network_data$edges)
  addWorksheet(wb, "nodes")
  writeData(wb, "nodes", network_data$nodes)
  saveWorkbook(wb, file.path(output_dir, "table/tf_network.xlsx"), overwrite = TRUE)
  
  # Save full filtered table
  write.xlsx(network_data$filtered_table, 
            file.path(output_dir, paste0("table/TF_Target_Filtered_Core_", species_choice, ".xlsx")))
  
  # Save R environment for reproducibility
  save.image(file.path(output_dir, 'data/tf.Rdata'))
  
  log_info(paste("Results saved to:", output_dir))
}

# Convert species parameter to database key
get_species_key <- function(species_choice) {
  if (species_choice %in% c("human", "hs")) "hs" else "mm"
}

# Normalize CLI aliases to canonical visualization values.
normalize_choice <- function(value, alias_map, field_name, supported_values = unique(unname(alias_map))) {
  value <- trimws(value)
  normalized <- unname(alias_map[value])

  if (length(normalized) == 0 || is.na(normalized)) {
    stop(paste0(
      "SKILL_INVALID_PARAMETER: Unsupported ", field_name, " value '", value,
      "'. Supported values: ", paste(supported_values, collapse = ", ")
    ))
  }

  normalized
}

normalize_choice_list <- function(value, alias_map, field_name, supported_values = unique(unname(alias_map))) {
  items <- trimws(unlist(strsplit(value, ",")))
  items <- items[items != ""]

  if (length(items) == 0) {
    stop(paste0(
      "SKILL_INVALID_PARAMETER: ", field_name,
      " requires at least one value. Supported values: ", paste(supported_values, collapse = ", ")
    ))
  }

  normalized <- unname(alias_map[items])
  invalid <- unique(items[is.na(normalized)])

  if (length(invalid) > 0) {
    stop(paste0(
      "SKILL_INVALID_PARAMETER: Unsupported ", field_name, " value(s): ",
      paste(invalid, collapse = ", "), ". Supported values: ",
      paste(supported_values, collapse = ", ")
    ))
  }

  normalized
}

normalize_visualization_options <- function(opt) {
  layout_aliases <- c(
    "kk" = "kk",
    "fr" = "fr",
    "nicely" = "nicely",
    "circle" = "circle",
    "sphere" = "sphere",
    "star" = "star",
    "grid" = "grid",
    "randomly" = "randomly",
    "发散(kk)" = "kk",
    "发散(fr)" = "fr",
    "发散(nicely)" = "nicely",
    "环形(circle)" = "circle",
    "球体(sphere)" = "sphere",
    "环绕(star)" = "star",
    "点阵(grid)" = "grid",
    "随机(randomly)" = "randomly"
  )
  line_shape_aliases <- c(
    "straight" = "straight",
    "curve" = "curve",
    "直线" = "straight",
    "曲线" = "curve"
  )
  line_type_aliases <- c(
    "solid" = "solid",
    "dashed" = "dashed",
    "实线" = "solid",
    "虚线" = "dashed"
  )
  label_aliases <- c(
    "node" = "node",
    "none" = "none",
    "节点" = "node",
    "无" = "none"
  )
  legend_aliases <- c(
    "bottom" = "bottom",
    "right" = "right",
    "底部" = "bottom",
    "右侧" = "right"
  )
  shape_aliases <- c(
    "circle" = "circle",
    "square" = "square",
    "diamond" = "diamond",
    "triangle" = "triangle",
    "triangle_down" = "triangle_down",
    "圆形" = "circle",
    "方形" = "square",
    "菱形" = "diamond",
    "三角形" = "triangle",
    "倒三角" = "triangle_down"
  )

  opt$style_layout <- normalize_choice(opt$style_layout, layout_aliases, "--style_layout")
  opt$style_line <- normalize_choice(opt$style_line, line_shape_aliases, "--style_line")
  opt$line_type <- normalize_choice(opt$line_type, line_type_aliases, "--line_type")
  opt$label <- normalize_choice(opt$label, label_aliases, "--label")
  opt$legend_position <- normalize_choice(opt$legend_position, legend_aliases, "--legend_position")
  opt$point_shape <- paste(normalize_choice_list(opt$point_shape, shape_aliases, "--point_shape"), collapse = ",")

  opt
}

# Validate that network data exists for visualization
validate_network_data <- function(output_dir) {
  network_file <- file.path(output_dir, "table/tf_network.xlsx")
  if (!file.exists(network_file))
    stop(paste("SKILL_FILE_NOT_FOUND: Network data file not found at", network_file))
  
  edges_df <- read.xlsx(network_file, sheet = "edges")
  nodes_df <- read.xlsx(network_file, sheet = "nodes")
  
  if (nrow(edges_df) == 0 || nrow(nodes_df) == 0)
    stop("SKILL_EMPTY_RESULTS: Network data is empty")
  
  list(edges = edges_df, nodes = nodes_df)
}

# Parse visualization parameters
parse_visualization_params <- function(opt) {
  # Options are normalized during CLI parsing; this table converts them to ggraph names.
  layout_dict <- c(
    "kk" = "kk", "fr" = "fr", "nicely" = "nicely",
    "circle" = "circle", "sphere" = "sphere",
    "star" = "star", "grid" = "grid", "randomly" = "randomly"
  )

  current_layout <- unname(layout_dict[opt$style_layout])
  if (length(current_layout) == 0 || is.na(current_layout)) {
    stop("SKILL_INVALID_PARAMETER: Unsupported --style_layout after normalization")
  }

  # Parse point sizes
  parse_pt <- function(x, field_name) {
    parsed <- as.numeric(gsub("pt", "", x))
    if (is.na(parsed)) {
      stop(paste0("SKILL_INVALID_PARAMETER: ", field_name, " must be numeric, optionally ending with 'pt'"))
    }
    parsed
  }
  lab_size <- parse_pt(opt$label_size, "--label_size") / .pt
  base_size <- parse_pt(opt$theme_size, "--theme_size")

  # Shape mapping uses canonical English values after normalization.
  shape_map <- c("circle" = 21, "square" = 22, "diamond" = 23, "triangle" = 24, "triangle_down" = 25)
  shapes_raw <- unlist(strsplit(opt$point_shape, ",")) %>% trimws()
  final_shapes <- as.numeric(shape_map[shapes_raw])
  if (any(is.na(final_shapes))) {
    stop("SKILL_INVALID_PARAMETER: Unsupported --point_shape after normalization")
  }
  if (length(final_shapes) == 1) {
    final_shapes <- rep(final_shapes, 2)
  }

  list(
    layout = current_layout,
    label_size = lab_size,
    base_size = base_size,
    shapes = final_shapes,
    line_type = opt$line_type,
    legend_position = opt$legend_position
  )
}
