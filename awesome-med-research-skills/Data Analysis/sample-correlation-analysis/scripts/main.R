#!/usr/bin/env Rscript

suppressPackageStartupMessages({
  library(optparse)
})

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
  make_option(c("-o", "--output_dir"), type = "character", default = "./Correlation_Results",
              help = "Output directory [default %default]", metavar = "dir"),
  make_option(c("-m", "--method"), type = "character", default = "pearson",
              help = "Correlation method: pearson, spearman [default %default]"),
  make_option(c("-x", "--x_var"), type = "character", default = "variable1",
              help = "First variable name for correlation [default %default]", metavar = "var"),
  make_option(c("-y", "--y_var"), type = "character", default = "variable2",
              help = "Second variable name for correlation [default %default]", metavar = "var"),
  make_option(c("-a", "--alternative"), type = "character", default = "two.sided",
              help = "Alternative: two.sided, less, greater [default %default]"),
  make_option(c("-c", "--conf_level"), type = "numeric", default = 0.95,
              help = "Confidence level [default %default]"),
  make_option(c("-f", "--output_format"), type = "character", default = "csv",
              help = "Output format: csv, txt [default %default]"),
  make_option(c("-p", "--output_prefix"), type = "character", default = "correlation",
              help = "Output file prefix [default %default]")
)

opt_parser <- OptionParser(option_list = option_list, 
                          description = "Correlation Analysis: Perform Pearson or Spearman correlation analysis with statistical results output.")
opt <- parse_args(opt_parser)

if (is.null(opt$data_file)) {
  skill_fail("SKILL_MISSING_INPUT: Data file (-d) option is required", show_help = TRUE, opt_parser = opt_parser)
}

params <- list(
  data_file = opt$data_file,
  output_dir = opt$output_dir,
  method = opt$method,
  x_var = opt$x_var,
  y_var = opt$y_var,
  alternative = opt$alternative,
  conf_level = opt$conf_level,
  output_format = opt$output_format,
  output_prefix = opt$output_prefix
)

params <- tryCatch({
  validate_parameters_opt(params)
}, error = function(e) {
  skill_fail(e$message, show_help = TRUE, opt_parser = opt_parser)
})

results <- tryCatch({
  correlation_analysis(params)
  save_session_info(params$output_dir)
}, error = function(e) {
  skill_fail(e$message)
})
