#!/usr/bin/env Rscript

get_script_path <- function() {
  cmd_args <- commandArgs(trailingOnly = FALSE)
  file_arg <- grep("^--file=", cmd_args, value = TRUE)
  if (length(file_arg) > 0) {
    return(normalizePath(sub("^--file=", "", file_arg[1])))
  }

  script_candidates <- cmd_args[grepl("run_smoke_test\\.R$", cmd_args)]
  if (length(script_candidates) > 0 && file.exists(script_candidates[1])) {
    return(normalizePath(script_candidates[1]))
  }

  stop("SMOKE_TEST_FAILED: Unable to resolve run_smoke_test.R path")
}

assert_file_exists <- function(path) {
  if (!file.exists(path)) {
    stop(paste("SMOKE_TEST_FAILED: Missing expected file:", path))
  }
}

script_path <- get_script_path()
tests_dir <- dirname(script_path)
root_dir <- dirname(tests_dir)
main_script <- file.path(root_dir, "scripts", "main.R")
input_file <- file.path(root_dir, "tests", "data", "otu_table.csv")
group_file <- file.path(root_dir, "tests", "data", "group_info.csv")
output_dir <- file.path(tempdir(), paste0("umap-tsne-smoke-", Sys.getpid()))

args <- c(
  main_script,
  "--input_file", input_file,
  "--group_file", group_file,
  "--output_dir", output_dir,
  "--method", "both",
  "--seed", "42"
)

message("Running smoke test with temporary output: ", output_dir)
status <- system2("Rscript", args = args)
if (!identical(status, 0L)) {
  stop(paste("SMOKE_TEST_FAILED: main.R exited with status", status))
}

expected_files <- c(
  file.path(output_dir, "data", "session_info.txt"),
  file.path(output_dir, "data", "analysis_data.rda"),
  file.path(output_dir, "table", "tsne_coordinates.csv"),
  file.path(output_dir, "table", "umap_coordinates.csv"),
  file.path(output_dir, "plot", "tsne_plot.pdf"),
  file.path(output_dir, "plot", "umap_plot.pdf")
)

invisible(lapply(expected_files, assert_file_exists))
message("Smoke test passed.")
