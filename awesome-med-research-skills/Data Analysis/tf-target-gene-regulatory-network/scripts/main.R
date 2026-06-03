#!/usr/bin/env Rscript
# Main CLI entry for TF Regulatory Network Analysis

suppressPackageStartupMessages(library(optparse))

# Get script directory for relative sourcing
get_script_dir <- function() {
  cmd_args <- commandArgs(trailingOnly = FALSE)
  file_arg_idx <- which(grepl("^--file=", cmd_args))
  if (length(file_arg_idx) > 0) {
    arg0 <- sub("^--file=", "", cmd_args[file_arg_idx])
    if (!is.na(arg0) && length(arg0) > 0 && file.exists(arg0))
      return(dirname(normalizePath(arg0)))
  }
  return(".")
}

script_dir <- get_script_dir()

# Source all module files
source(file.path(script_dir, "utils.R"))
source(file.path(script_dir, "functions.R"))
source(file.path(script_dir, "run_analysis.R"))
source(file.path(script_dir, "visualization.R"))

# Command line argument parsing
option_list <- list(
  # Core parameters
  make_option(c("-g", "--gene"), type = "character", default = NULL,
              help = "Comma-separated gene list (e.g., 'TP53,MYC,EGFR')", metavar = "genes"),
  make_option(c("-f", "--gene_file"), type = "character", default = NULL,
              help = "File containing gene names (txt or csv, one per line or comma-separated)", metavar = "file"),
  make_option(c("-s", "--species"), type = "character", default = "human",
              help = "Species: 'human' or 'mouse' [default: %default]"),
  make_option(c("-o", "--output_dir"), type = "character", default = "TF_Result",
              help = "Output directory name [default: %default]", metavar = "dir"),
  make_option(c("--db_path"), type = "character", default = NULL,
              help = "Local database file path (.rds format). If not specified, auto-search in default paths", metavar = "path"),
  
  # Basic settings
  make_option(c("-w", "--width"), type = "numeric", default = 12,
              help = "Figure width in inches [default: %default]"),
  make_option(c("-e", "--height"), type = "numeric", default = 10,
              help = "Figure height in inches [default: %default]"),
  make_option(c("--family"), type = "character", default = "Arial",
              help = "Font family for text [default: %default]"),
  make_option(c("-d", "--dir"), type = "character", default = NULL,
              help = "Working root directory (advanced)", metavar = "dir"),
  
  # Label and legend
  make_option(c("--label"), type = "character", default = "node",
              help = "Label mapping type: 'node' or legacy alias '节点'; use 'none' to hide labels [default: %default]"),
  make_option(c("--label_size"), type = "character", default = "20pt",
              help = "Label font size [default: %default]"),
  make_option(c("--legend_position"), type = "character", default = "bottom",
              help = "Legend position: 'bottom', 'right', or legacy aliases '底部'/'右侧' [default: %default]"),
  
  # Line settings
  make_option(c("--line_color"), type = "character", default = "#7E8B8E",
              help = "Line color (hex code) [default: %default]"),
  make_option(c("--line_type"), type = "character", default = "solid",
              help = "Line type: 'solid', 'dashed', or legacy aliases '实线'/'虚线' [default: %default]"),
  
  # Mapping settings
  make_option(c("--mapping_link_alpha"), type = "character", default = "none",
              help = "Edge alpha mapping: 'Value' or 'none' [default: %default]"),
  make_option(c("--mapping_link_color"), type = "character", default = "none",
              help = "Edge color mapping: 'Value' or 'none' [default: %default]"),
  make_option(c("--mapping_link_size"), type = "character", default = "none",
              help = "Edge size mapping: 'Value' or 'none' [default: %default]"),
  make_option(c("--mapping_link_type"), type = "character", default = "none",
              help = "Edge type mapping: 'Value' or 'none' [default: %default]"),
  make_option(c("--mapping_node_color"), type = "character", default = "type",
              help = "Node color mapping: 'type' (TF/Target) or 'none' [default: %default]"),
  make_option(c("--mapping_node_type"), type = "character", default = "type",
              help = "Node shape mapping: 'type' (TF/Target) or 'none' [default: %default]"),
  
  # Node styling
  make_option(c("--point_color"), type = "character", default = "#2E889D",
              help = "Node border color (hex code) [default: %default]"),
  make_option(c("--point_fill"), type = "character", default = "#2E879A",
              help = "Node fill color (hex code) [default: %default]"),
  make_option(c("--point_shape"), type = "character", default = "circle,square,diamond,triangle,triangle_down",
              help = "Node shapes: canonical English names or legacy aliases like '菱形,三角形' [default: %default]"),
  
  # Layout and titles
  make_option(c("--style_layout"), type = "character", default = "sphere",
              help = "Layout style: 'sphere', 'kk', 'fr', 'nicely', 'circle', 'star', 'grid', 'randomly' or legacy aliases like '发散(fr)' [default: %default]"),
  make_option(c("--style_line"), type = "character", default = "straight",
              help = "Line shape style: 'straight', 'curve', or legacy aliases '直线'/'曲线' [default: %default]"),
  make_option(c("--theme_size"), type = "character", default = "30pt",
              help = "Base theme font size [default: %default]"),
  make_option(c("--title"), type = "character", default = "",
              help = "Chart title [default: %default]"),
  make_option(c("--title_x"), type = "character", default = "",
              help = "X-axis title [default: %default]"),
  
  # Random seed (REQUIRED)
  make_option(c("--seed"), type = "integer", default = 42,
              help = "Random seed for reproducibility [default: %default]")
)

opt_parser <- OptionParser(option_list = option_list, 
                           description = "Transcription Factor (TF) Regulatory Network Analysis using Dorothea database")
opt <- parse_args(opt_parser)
opt <- normalize_visualization_options(opt)

# Validate required parameters
if (is.null(opt$gene) && is.null(opt$gene_file)) {
  print_help(opt_parser)
  stop("SKILL_INVALID_PARAMETER: Either --gene or --gene_file must be provided")
}

# Set random seed for reproducibility
set.seed(opt$seed)

# Run main analysis with error handling
tryCatch({
  log_info("Starting TF-target regulatory network analysis")
  
  # Run TF analysis
  result <- run_tf_analysis(
    gene_cmd = opt$gene,
    gene_file = opt$gene_file,
    species = opt$species,
    output_dir = opt$output_dir,
    db_path = opt$db_path,
    script_dir = script_dir,
    seed = opt$seed
  )
  
  # Run network visualization if output directory was created
  if (!is.null(result$output_dir) && dir.exists(result$output_dir)) {
    log_info("Running network visualization...")
    run_network_visualization(
      output_dir = result$output_dir,
      vis_params = opt,
      script_dir = script_dir
    )
  }
  
  # Save session info
  save_session_info(result$output_dir)
  
  log_info("TF-target regulatory network analysis completed successfully")
  log_info(paste("Results saved to:", result$output_dir))
  
}, error = function(e) {
  error_message <- conditionMessage(e)
  exit_status <- if (grepl("^SKILL_EMPTY_RESULTS", error_message)) 2 else 1
  log_error(paste("Analysis failed:", error_message))
  quit(save = "no", status = exit_status)
})
