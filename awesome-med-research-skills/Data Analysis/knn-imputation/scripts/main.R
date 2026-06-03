#!/usr/bin/env Rscript
if (!requireNamespace("optparse", quietly = TRUE)) {
  stop("SKILL_DEPENDENCY_MISSING: Package not installed: optparse", call. = FALSE)
}

REQUIRED_PACKAGES <- c("data.table", "DMwR2")

get_script_dir <- function() {
  cmd_args <- commandArgs(trailingOnly = FALSE)
  file_arg_idx <- which(grepl("^--file=", cmd_args))
  if (length(file_arg_idx) > 0) {
    script_path <- sub("^--file=", "", cmd_args[file_arg_idx][1])
    if (!is.na(script_path) && nzchar(script_path) && file.exists(script_path)) {
      return(dirname(normalizePath(script_path)))
    }
  }
  return(normalizePath("."))
}

script_dir <- get_script_dir()
source(file.path(script_dir, "utils.R"))
source(file.path(script_dir, "functions.R"))
source(file.path(script_dir, "imputation_helpers.R"))
source(file.path(script_dir, "imputation_functions.R"))
source(file.path(script_dir, "run_analysis.R"))

normalize_parse_error <- function(message_text) {
  cleaned <- gsub("\\s+", " ", message_text)
  cleaned <- sub("^Error in getopt_options\\(object, args\\) : ?", "", cleaned)
  cleaned <- sub("^Error in getopt\\(spec = spec, opt = args\\) : ?", "", cleaned)
  sprintf("SKILL_INVALID_PARAMETER: %s", trimws(cleaned))
}

parse_cli_args <- function(parser) {
  tryCatch(
    optparse::parse_args(parser),
    error = function(e) {
      log_error(normalize_parse_error(conditionMessage(e)))
      quit(status = 1)
    }
  )
}

option_list <- list(
  optparse::make_option(c("-i", "--input_file"), type = "character", default = NULL,
                        help = "Expression matrix CSV file with features in rows [required]", metavar = "file"),
  optparse::make_option(c("-g", "--group_file"), type = "character", default = NULL,
                        help = "Group annotation CSV file [required]", metavar = "file"),
  optparse::make_option(c("-o", "--output_dir"), type = "character", default = "./output/",
                        help = "Output directory [default %default]", metavar = "dir"),
  optparse::make_option(c("-c", "--sample_column"), type = "character", default = "sample",
                        help = "Sample ID column in group file [default %default]"),
  optparse::make_option(c("-l", "--group_column"), type = "character", default = "group",
                        help = "Grouping column used to define strata [default %default]"),
  optparse::make_option(c("-k", "--k"), type = "integer", default = 10,
                         help = "Number of nearest neighbors within each stratum [default %default]"),
  optparse::make_option(c("-m", "--small_strata_fill_method"), type = "character", default = "mean",
                         help = "Fill method for strata with <=10 samples: mean or median [default %default]"),
  optparse::make_option(c("--overwrite"), action = "store_true", default = FALSE,
                         help = "Overwrite existing output files [default %default]"),
  optparse::make_option(c("-t", "--timeout_seconds"), type = "integer", default = 0,
                        help = "Optional elapsed timeout in seconds, 0 disables timeout [default %default]"),
  optparse::make_option(c("-s", "--seed"), type = "integer", default = 42,
                        help = "Random seed for reproducibility [default %default]")
)

parser <- optparse::OptionParser(
  option_list = option_list,
  description = "Group-stratified DMwR2 KNN imputation for expression matrices"
)
opt <- parse_cli_args(parser)
output_dir_existed_before <- dir.exists(opt$output_dir)

tryCatch({
  result <- withCallingHandlers({
    validate_cli_options(opt)
    validate_output_targets(opt$output_dir, opt$overwrite)
    check_dependencies(REQUIRED_PACKAGES)
    set.seed(opt$seed)
    set_timeout_limit(opt$timeout_seconds)
    log_info("==========================================")
    log_info("KNN Imputation")
    log_info("==========================================")
    log_info(sprintf("Input matrix: %s", opt$input_file))
    log_info(sprintf("Group file: %s", opt$group_file))
    log_info(sprintf("Output directory: %s", opt$output_dir))
    log_info(sprintf("Grouping column: %s", opt$group_column))
    log_info(sprintf("Small-strata fill method: %s", opt$small_strata_fill_method))
    log_info(sprintf("Overwrite existing files: %s", opt$overwrite))
    log_info(sprintf("Seed: %d", opt$seed))
    run_analysis(opt)
  }, warning = function(w) {
    log_warn(conditionMessage(w))
    invokeRestart("muffleWarning")
  })
  clear_timeout_limit()
  save_session_info(opt$output_dir)
  log_info("Analysis complete!")
  log_info(sprintf("All results in: %s", opt$output_dir))
}, error = function(e) {
  clear_timeout_limit()
  if (!output_dir_existed_before) {
    cleanup_empty_output_dir(opt$output_dir)
  }
  error_message <- conditionMessage(e)
  if (grepl("time limit", error_message, ignore.case = TRUE)) {
    error_message <- "SKILL_TIMEOUT: Time limit exceeded"
  }
  log_error(error_message)
  quit(status = 1)
}, warning = function(w) {
  log_warn(conditionMessage(w))
})
