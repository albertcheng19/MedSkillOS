#!/usr/bin/env Rscript

suppressPackageStartupMessages({
  library(optparse)
})

get_script_dir <- function() {
  cmd_args <- commandArgs(trailingOnly = FALSE)
  file_arg_idx <- which(grepl("^--file=", cmd_args))
  if (length(file_arg_idx) > 0) {
    arg0 <- sub("^--file=", "", cmd_args[file_arg_idx])
    if (!is.na(arg0) && length(arg0) > 0 && file.exists(arg0)) {
      return(dirname(normalizePath(arg0)))
    }
  }
  "."
}

script_dir <- get_script_dir()
source(file.path(script_dir, "utils.R"))
source(file.path(script_dir, "functions.R"))
source(file.path(script_dir, "run_analysis.R"))

skill_fail <- function(message, show_help = FALSE, opt_parser = NULL) {
  cat(paste0(message, "\n"), file = stderr())
  if (show_help && !is.null(opt_parser)) {
    cat("\n", file = stderr())
    print_help(opt_parser)
  }
  quit(save = "no", status = 1)
}

option_list <- list(
  make_option(c("-d", "--data_file"), type = "character",
              help = "Data file (CSV, TXT, TSV format)", metavar = "file"),
  make_option(c("-t", "--target_var"), type = "character",
              help = "Target column to predict", metavar = "column"),
  make_option(c("-k", "--task_type"), type = "character", default = "auto",
              help = "Task type: auto, classification, regression [default %default]"),
  make_option(c("-o", "--output_dir"), type = "character", default = "./Decision_Tree_Results",
              help = "Output directory [default %default]", metavar = "dir"),
  make_option(c("-r", "--train_ratio"), type = "double", default = 0.7,
              help = "Train ratio between 0 and 1 [default %default]"),
  make_option(c("--max_depth"), type = "integer", default = 5,
              help = "Maximum tree depth [default %default]"),
  make_option(c("--minsplit"), type = "integer", default = 10,
              help = "Minimum observations required to split [default %default]"),
  make_option(c("--minbucket"), type = "integer", default = 3,
              help = "Minimum observations in terminal nodes [default %default]"),
  make_option(c("--cp"), type = "double", default = 0.001,
              help = "Complexity parameter for pruning [default %default]"),
  make_option(c("-s", "--seed"), type = "integer", default = 42,
              help = "Random seed [default %default]"),
  make_option(c("-e", "--exclude_vars"), type = "character", default = "",
              help = "Comma-separated columns to exclude from modeling"),
  make_option(c("--importance_top_n"), type = "integer", default = 15,
              help = "Top N features to show in the importance figure [default %default]"),
  make_option(c("-f", "--output_format"), type = "character", default = "csv",
              help = "Output format: csv, txt [default %default]")
)

opt_parser <- OptionParser(
  option_list = option_list,
  description = "Decision Tree Analysis: Train a decision tree model and export feature importance ranking results."
)
opt <- parse_args(opt_parser)

if (is.null(opt$data_file) || identical(opt$data_file, "")) {
  skill_fail("SKILL_MISSING_INPUT: Data file (-d) option is required", show_help = TRUE, opt_parser = opt_parser)
}

if (is.null(opt$target_var) || identical(opt$target_var, "")) {
  skill_fail("SKILL_MISSING_INPUT: Target variable (-t) option is required", show_help = TRUE, opt_parser = opt_parser)
}

params <- list(
  data_file = opt$data_file,
  target_var = opt$target_var,
  task_type = opt$task_type,
  output_dir = opt$output_dir,
  train_ratio = opt$train_ratio,
  max_depth = opt$max_depth,
  minsplit = opt$minsplit,
  minbucket = opt$minbucket,
  cp = opt$cp,
  seed = opt$seed,
  exclude_vars = opt$exclude_vars,
  importance_top_n = opt$importance_top_n,
  output_format = opt$output_format
)

params <- tryCatch({
  validate_parameters_opt(params)
}, error = function(e) {
  skill_fail(e$message, show_help = TRUE, opt_parser = opt_parser)
})

tryCatch({
  decision_tree_analysis(params)
  save_session_info(params$output_dir)
}, error = function(e) {
  skill_fail(e$message)
})
