#!/usr/bin/env Rscript

if (!requireNamespace("optparse", quietly = TRUE)) {
  timestamp_now <- function() format(Sys.time(), "%Y-%m-%d %H:%M:%S")
  message(sprintf("[ERROR] %s | SKILL_PACKAGE_NOT_FOUND | Missing required package: optparse", timestamp_now()))
  quit(status = 1)
}

suppressPackageStartupMessages(library(optparse))

get_script_dir <- function() {
  cmd_args <- commandArgs(trailingOnly = FALSE)
  file_arg <- grep("^--file=", cmd_args, value = TRUE)
  if (length(file_arg)) dirname(normalizePath(sub("^--file=", "", file_arg[[1]]), winslash = "/", mustWork = FALSE)) else "."
}

script_dir <- get_script_dir()
skill_root <- normalizePath(file.path(script_dir, ".."), winslash = "/", mustWork = TRUE)
source(file.path(script_dir, "utils.R"))
source(file.path(script_dir, "io.R"))
source(file.path(script_dir, "functions.R"))
source(file.path(script_dir, "plot_helpers.R"))
source(file.path(script_dir, "visualization.R"))
source(file.path(script_dir, "recording.R"))
source(file.path(script_dir, "cli_options.R"))
source(file.path(script_dir, "run_analysis.R"))

required_packages <- c("igraph")

main <- function() {
  check_required_packages(required_packages)
  opt <- validate_cli_options(optparse::parse_args(build_option_parser()), skill_root)
  start_time <- Sys.time()
  start_proc <- proc.time()
  set.seed(opt$seed)
  enable_timeout(opt$timeout_seconds)

  ensure_dir(opt$output_dir)
  ensure_dir(file.path(opt$output_dir, "data"))
  ensure_dir(file.path(opt$output_dir, "table"))
  ensure_dir(file.path(opt$output_dir, "plot"))
  log_info(sprintf("Mode: %s", opt$mode))
  log_info(sprintf("Output directory: %s", opt$output_dir))

  output_items <- list()
  input_info <- list()
  if (opt$mode %in% c("analyze", "full")) {
    result <- run_analysis_mode(opt)
    input_info <- result$input_info
    output_items <- c(output_items, list(
      list(path = result$edge_file, description = "lncRNA-mRNA network edge table", content = "Each row is a database-supported lncRNA-mRNA association with shared miRNA counts."),
      list(path = result$evidence_file, description = "Tripartite evidence table", content = "Each row captures one lncRNA-miRNA-mRNA evidence chain from the local databases."),
      list(path = result$node_file, description = "Network node table", content = "Contains node type and degree in the lncRNA-mRNA projection."),
      list(path = result$stats_file, description = "Network summary statistics", content = "Reports edge counts, evidence rows, and node totals."),
      list(path = result$rda_file, description = "Serialized network result object", content = "Saved R object for visualization reuse."),
      list(path = file.path(opt$output_dir, "session_info.txt"), description = "R session information", content = "sessionInfo() output for reproducibility.")
    ))
  }
  if (opt$mode %in% c("visualize", "full")) {
    vis <- run_visualization_mode(opt)
    output_items <- c(output_items, list(
      list(path = vis$plot_file, description = "lncRNA-mRNA network PDF", content = "Projected network plot derived from shared-miRNA database evidence.")
    ))
  }

  end_time <- Sys.time()
  end_proc <- proc.time()
  runtime_info <- list(
    start_time = format(start_time, "%Y-%m-%d %H:%M:%S"),
    end_time = format(end_time, "%Y-%m-%d %H:%M:%S"),
    elapsed_seconds = as.numeric(difftime(end_time, start_time, units = "secs")),
    user_cpu_seconds = unname((end_proc - start_proc)[["user.self"]]),
    system_cpu_seconds = unname((end_proc - start_proc)[["sys.self"]]),
    gc_snapshot = capture.output(gc())
  )
  write_output_manifest(opt$output_dir, output_items, opt, runtime_info)
  write_run_record(opt$output_dir, opt, runtime_info, input_info, output_items)
}

tryCatch(
  {
    main()
    log_info("Database-driven lncRNA-mRNA network construction completed successfully.")
    quit(status = 0)
  },
  error = function(e) {
    message(sprintf("[ERROR] %s | %s", timestamp_now(), conditionMessage(e)))
    quit(status = 1)
  }
)
