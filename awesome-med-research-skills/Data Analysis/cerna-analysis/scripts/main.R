#!/usr/bin/env Rscript

required_packages <- c("optparse", "igraph")

check_entry_packages <- function(packages) {
  missing_packages <- packages[!vapply(packages, requireNamespace, logical(1), quietly = TRUE)]
  if (length(missing_packages) > 0) {
    message(sprintf("[ERROR] %s | SKILL_DEPENDENCY_MISSING: Missing package(s): %s", format(Sys.time(), "%Y-%m-%d %H:%M:%S"), paste(missing_packages, collapse = ", ")))
    quit(status = 1)
  }
}

get_script_dir <- function() {
  cmd_args <- commandArgs(trailingOnly = FALSE)
  file_args <- sub("^--file=", "", cmd_args[grepl("^--file=", cmd_args)])
  script_args <- cmd_args[grepl("(^|/)main\\.R$", cmd_args)]
  candidates <- c(file_args, script_args)
  for (candidate in candidates) {
    if (!is.na(candidate) && nzchar(candidate) && file.exists(candidate)) {
      return(dirname(normalizePath(candidate, winslash = "/", mustWork = TRUE)))
    }
  }
  if (file.exists(file.path("scripts", "utils.R"))) return(normalizePath("scripts", winslash = "/", mustWork = FALSE))
  if (file.exists("utils.R")) return(normalizePath(".", winslash = "/", mustWork = FALSE))
  stop("SKILL_FILE_NOT_FOUND: Unable to determine script directory", call. = FALSE)
}

source_required_script <- function(script_dir, script_name) {
  script_path <- file.path(script_dir, script_name)
  if (!file.exists(script_path)) stop(sprintf("SKILL_FILE_NOT_FOUND: Required script missing: %s", script_path), call. = FALSE)
  tryCatch(
    source(script_path),
    error = function(err) {
      message_text <- conditionMessage(err)
      if (grepl("^SKILL_[A-Z0-9_]+:", message_text)) stop(message_text, call. = FALSE)
      stop(sprintf("SKILL_RUNTIME_ERROR: Failed to source %s: %s", script_name, message_text), call. = FALSE)
    }
  )
}

boot_fail <- function(err) {
  message(sprintf("[ERROR] %s | %s", format(Sys.time(), "%Y-%m-%d %H:%M:%S"), conditionMessage(err)))
  quit(status = 1)
}

check_entry_packages(required_packages)
invisible(lapply(required_packages, function(pkg) suppressPackageStartupMessages(library(pkg, character.only = TRUE, warn.conflicts = FALSE))))

script_dir <- tryCatch(get_script_dir(), error = boot_fail)
tryCatch(source_required_script(script_dir, "utils.R"), error = boot_fail)
tryCatch(source_required_script(script_dir, "validation.R"), error = boot_fail)
tryCatch(source_required_script(script_dir, "functions.R"), error = boot_fail)
tryCatch(source_required_script(script_dir, "io.R"), error = boot_fail)
tryCatch(source_required_script(script_dir, "plot_functions.R"), error = boot_fail)
tryCatch(source_required_script(script_dir, "run_analysis.R"), error = boot_fail)

option_list <- list(
  make_option(c("-i", "--key_genes"), type = "character", default = NULL, help = "Key gene file path or comma-separated gene names [required]", metavar = "file"),
  make_option(c("-o", "--output_dir"), type = "character", default = "./output/", help = "Output directory [default %default]", metavar = "dir"),
  make_option(c("-m", "--mirna_dataset"), type = "character", default = "combined", help = "miRNA-mRNA dataset: combined, starbase, mirdb, mirtarbase, starbase+mirdb, starbase+mirtarbase, mirdb+mirtarbase [default %default]"),
  make_option(c("-l", "--lncrna_strictness"), type = "character", default = "High", help = "lncRNA interaction strictness: Low, Median, High [default %default]"),
  make_option(c("-f", "--lncrna_freq_thresh"), type = "integer", default = 0, help = "Minimum lncRNA frequency threshold [default %default]"),
  make_option(c("-r", "--reference_dir"), type = "character", default = file.path(script_dir, "..", "references", "database"), help = "Reference dataset directory [default %default]", metavar = "dir"),
  make_option(c("--plot_width"), type = "double", default = 12, help = "Plot width in inches [default %default]"),
  make_option(c("--plot_height"), type = "double", default = 8, help = "Plot height in inches [default %default]"),
  make_option(c("--layout_type"), type = "character", default = "kk", help = "Network layout: kk, fr, nicely, circle, grid, randomly [default %default]"),
  make_option(c("--mrna_color"), type = "character", default = "#D16BA5", help = "mRNA node color [default %default]"),
  make_option(c("--lncrna_color"), type = "character", default = "#008dcd", help = "lncRNA node color [default %default]"),
  make_option(c("--mirna_color"), type = "character", default = "#00c9a7", help = "miRNA node color [default %default]"),
  make_option(c("--node_size_base"), type = "double", default = 15, help = "Base node size [default %default]"),
  make_option(c("--label_size"), type = "double", default = 0.8, help = "Node label size [default %default]"),
  make_option(c("--show_legend"), type = "logical", default = TRUE, help = "Show legend in PDF output [default %default]"),
  make_option(c("-t", "--timeout_seconds"), type = "integer", default = 3600, help = "Elapsed timeout in seconds [default %default]"),
  make_option(c("-s", "--seed"), type = "integer", default = 42, help = "Random seed for reproducibility [default %default]")
)

opt <- parse_args(OptionParser(option_list = option_list, description = "ceRNA Network Analysis"))
output_dir <- NULL

withCallingHandlers(
  tryCatch({
    validate_main_options(opt)
    set.seed(opt$seed)
    output_dir <- normalizePath(opt$output_dir, winslash = "/", mustWork = FALSE)
    opt$output_dir <- output_dir
    log_info(sprintf("Seed: %d", opt$seed))
    log_info(sprintf("Input: %s", opt$key_genes))
    log_info(sprintf("Output: %s", opt$output_dir))
    run_with_timeout(function() run_cerna_analysis(opt), opt$timeout_seconds, "ceRNA analysis")
    write_session_info(opt$output_dir)
    log_info("Analysis completed")
  }, error = function(e) {
    if (!is.null(output_dir) && dir.exists(output_dir)) write_session_info(output_dir)
    log_error(conditionMessage(e))
    quit(status = 1)
  }),
  warning = function(w) {
    log_warn(conditionMessage(w))
    invokeRestart("muffleWarning")
  }
)
