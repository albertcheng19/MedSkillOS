normalize_optional_mode <- function(value, label, allowed = c("value", "none")) {
  normalized <- tolower(trimws(as.character(value)))
  if (!normalized %in% allowed) fail("SKILL_INVALID_PARAMETER", sprintf("%s must be one of: %s", label, paste(allowed, collapse = ", ")))
  normalized
}

validate_options <- function(opt, skill_root, default_cache_dir) {
  if (!isTRUE(opt$plot_only)) {
    opt$genelist_file <- resolve_existing_input(opt$genelist_file, "--genelist_file")
    if (is.null(opt$species) || !nzchar(trimws(opt$species))) fail("SKILL_INVALID_PARAMETER", "--species is required when --plot_only is FALSE.")
    if (is.null(opt$threshold) || is.na(opt$threshold)) fail("SKILL_INVALID_PARAMETER", "--threshold is required when --plot_only is FALSE.")
  }

  require_positive_number(opt$seed, "--seed", integer_only = TRUE)
  require_positive_number(opt$timeout_seconds, "--timeout_seconds", integer_only = TRUE)
  require_positive_number(opt$figure_width, "--figure_width")
  require_positive_number(opt$figure_height, "--figure_height")
  require_positive_number(opt$label_size, "--label_size")
  require_positive_number(opt$line_size, "--line_size")
  require_positive_number(opt$point_size, "--point_size")
  require_positive_number(opt$theme_size, "--theme_size")
  require_probability(opt$line_alpha, "--line_alpha")
  require_probability(opt$point_alpha, "--point_alpha")
  if (!isTRUE(opt$plot_only)) require_threshold_range(opt$threshold, "--threshold")

  opt$mapping_link_alpha <- normalize_optional_mode(opt$mapping_link_alpha, "--mapping_link_alpha")
  opt$mapping_link_color <- normalize_optional_mode(opt$mapping_link_color, "--mapping_link_color")
  opt$mapping_link_size <- normalize_optional_mode(opt$mapping_link_size, "--mapping_link_size")
  opt$mapping_node_alpha <- normalize_optional_mode(opt$mapping_node_alpha, "--mapping_node_alpha")
  opt$mapping_node_color <- normalize_optional_mode(opt$mapping_node_color, "--mapping_node_color")
  opt$mapping_node_size <- normalize_optional_mode(opt$mapping_node_size, "--mapping_node_size")
  opt$figure_family <- require_choice(opt$figure_family, "--figure_family", c("sans", "serif", "mono"))
  opt$label <- require_choice(opt$label, "--label", c("node", "none"))
  opt$line_type <- require_choice(opt$line_type, "--line_type", c("solid", "dashed", "dotted"))
  opt$point_shape <- require_choice(opt$point_shape, "--point_shape", c("circle", "square"))
  opt$style_layout <- require_choice(opt$style_layout, "--style_layout", c("kk", "fr", "nicely", "circle", "star", "grid", "randomly"))
  opt$style_line <- require_choice(opt$style_line, "--style_line", c("straight", "curve"))

  opt$species <- if (is.null(opt$species)) NULL else trimws(as.character(opt$species))
  opt$output_dir <- resolve_output_dir(opt$output_dir, skill_root)
  opt$string_cache_dir <- if (nzchar(trimws(opt$string_cache_dir))) resolve_input_dir(opt$string_cache_dir, "--string_cache_dir") else default_cache_dir
  opt$string_version <- trimws(as.character(opt$string_version))
  if (!nzchar(opt$string_version)) opt$string_version <- "auto"
  opt$skill_root <- skill_root
  opt
}
