#!/usr/bin/env Rscript

build_missing_pkg_message <- function(missing) {
  missing <- sort(unique(missing))
  install_cmd <- paste0(
    "Rscript -e \"install.packages(c(",
    paste(sprintf("'%s'", missing), collapse = ", "),
    "), repos='https://cloud.r-project.org')\""
  )

  paste(
    "SKILL_PACKAGE_NOT_FOUND:", paste(missing, collapse = ", "),
    "| Run: Rscript scripts/install_dependencies.R",
    "| Manual install:", install_cmd
  )
}

check_required_packages <- function(timeout = 0) {
  required_packages <- c(
    "data.table",
    "Rtsne",
    "umap",
    "ggplot2",
    "vegan"
  )

  if (timeout > 0) {
    required_packages <- c(required_packages, "R.utils")
  }

  missing <- required_packages[
    !vapply(required_packages, requireNamespace, logical(1), quietly = TRUE)
  ]
  if (length(missing) > 0)
    stop(build_missing_pkg_message(missing))

  invisible(TRUE)
}

if (!requireNamespace("optparse", quietly = TRUE)) {
  stop(build_missing_pkg_message("optparse"))
}

suppressPackageStartupMessages(library(optparse))

get_script_dir <- function() {
  cmd_args <- commandArgs(trailingOnly = FALSE)
  file_arg <- grep("^--file=", cmd_args, value = TRUE)
  if (length(file_arg) > 0) {
    return(dirname(normalizePath(sub("^--file=", "", file_arg))))
  }
  return(".")
}

script_dir <- get_script_dir()

source(file.path(script_dir, "utils.R"))
source(file.path(script_dir, "functions.R"))
source(file.path(script_dir, "dim_reduction_methods.R"))
source(file.path(script_dir, "visualization.R"))
source(file.path(script_dir, "run_analysis.R"))

option_list <- list(
  make_option(c("-i", "--input_file"), type = "character", default = NULL,
              help = "OTU/abundance matrix file [required]", metavar = "file"),
  make_option(c("-g", "--group_file"), type = "character", default = NULL,
              help = "Sample group file [required]", metavar = "file"),
  make_option(c("-o", "--output_dir"), type = "character", default = "./output/",
              help = "Output directory [default %default]", metavar = "dir"),
  make_option(c("-m", "--method"), type = "character", default = "both",
              help = "Method: tsne, umap, both [default %default]"),
  make_option(c("--sample_id_col"), type = "character", default = NULL,
              help = "Sample ID column name in group file; default = first column"),
  make_option(c("--group_col"), type = "character", default = NULL,
              help = "Group column name in group file; default = second column"),
  make_option(c("--perplexity"), type = "double", default = 25,
              help = "t-SNE perplexity [default %default]"),
  make_option(c("--theta"), type = "double", default = 0.0,
              help = "t-SNE theta [default %default]"),
  make_option(c("--pca"), type = "logical", default = FALSE,
              help = "Use PCA before t-SNE [default %default]"),
  make_option(c("--check_duplicates"), type = "logical", default = FALSE,
              help = "Check duplicates in t-SNE [default %default]"),
  make_option(c("--normalize"), type = "logical", default = TRUE,
              help = "Normalize data before UMAP [default %default]"),
  make_option(c("--norm_method"), type = "character", default = "hellinger",
              help = "Normalization method for vegan::decostand [default %default]"),
  make_option(c("--n_neighbors"), type = "integer", default = 10,
              help = "UMAP n_neighbors [default %default]"),
  make_option(c("-s", "--seed"), type = "integer", default = 42,
              help = "Random seed [default %default]"),
  make_option(c("-t", "--timeout"), type = "integer", default = 0,
              help = "Timeout in seconds; 0 disables timeout [default %default]")
)

parser <- OptionParser(
  option_list = option_list,
  description = "UMAP / t-SNE analysis"
)
opt <- parse_args(parser)

if (is.null(opt$input_file) || is.null(opt$group_file)) {
  print_help(parser)
  quit_with_error("SKILL_INVALID_PARAMETER: Both --input_file and --group_file are required")
}

if (!opt$method %in% c("tsne", "umap", "both")) {
  quit_with_error("SKILL_INVALID_PARAMETER: --method must be one of tsne, umap, both")
}
if (opt$perplexity <= 0) {
  quit_with_error("SKILL_INVALID_PARAMETER: --perplexity must be > 0")
}
if (opt$n_neighbors <= 1) {
  quit_with_error("SKILL_INVALID_PARAMETER: --n_neighbors must be > 1")
}
if (opt$timeout < 0) {
  quit_with_error("SKILL_INVALID_PARAMETER: --timeout must be >= 0")
}

set.seed(opt$seed)

tryCatch({
  check_required_packages(timeout = opt$timeout)
  prepare_output_dir(opt$output_dir)
  check_files(opt$input_file, opt$group_file)
  save_session_info(opt$output_dir)

  log_info("==========================================")
  log_info("UMAP / t-SNE Analysis")
  log_info("==========================================")
  log_info(paste("Input:", opt$input_file))
  log_info(paste("Group:", opt$group_file))
  log_info(paste("Method:", opt$method))
  log_info(paste("Output:", opt$output_dir))
  log_info(paste("Seed:", opt$seed))
  log_info(paste("Timeout:", opt$timeout))

  run_umap_tsne_analysis(
    input_file = opt$input_file,
    group_file = opt$group_file,
    output_dir = opt$output_dir,
    method = opt$method,
    sample_id_col = opt$sample_id_col,
    group_col = opt$group_col,
    perplexity = opt$perplexity,
    theta = opt$theta,
    pca = opt$pca,
    check_duplicates = opt$check_duplicates,
    normalize = opt$normalize,
    norm_method = opt$norm_method,
    n_neighbors = opt$n_neighbors,
    seed = opt$seed,
    timeout = opt$timeout
  )

  log_info("Analysis completed successfully")
  quit(save = "no", status = 0)
}, error = function(e) {
  log_error(paste("Analysis failed:", conditionMessage(e)))
  quit(save = "no", status = 1)
})
