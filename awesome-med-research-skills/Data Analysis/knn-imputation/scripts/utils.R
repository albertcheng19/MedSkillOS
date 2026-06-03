log_message <- function(level, message_text) {
  timestamp <- format(Sys.time(), "%Y-%m-%d %H:%M:%S")
  message(sprintf("[%s]  %s | %s", level, timestamp, message_text))
}

log_info <- function(message_text) log_message("INFO", message_text)
log_warn <- function(message_text) log_message("WARN", message_text)
log_error <- function(message_text) log_message("ERROR", message_text)

check_pkg <- function(pkg, min_ver = NULL) {
  if (!suppressMessages(requireNamespace(pkg, quietly = TRUE))) {
    stop(sprintf("SKILL_DEPENDENCY_MISSING: Package not installed: %s", pkg))
  }
  suppressMessages(suppressPackageStartupMessages(
    library(pkg, character.only = TRUE, warn.conflicts = FALSE)
  ))
  if (!is.null(min_ver) && packageVersion(pkg) < min_ver) {
    stop(sprintf("SKILL_PKG_VERSION: %s requires version >= %s", pkg, min_ver))
  }
}

check_dependencies <- function(packages) {
  for (pkg in packages) check_pkg(pkg)
  invisible(TRUE)
}

parse_csv_arg <- function(value) {
  parts <- trimws(strsplit(value, ",", fixed = TRUE)[[1]])
  parts[nzchar(parts)]
}

ensure_file_exists <- function(path) {
  if (!file.exists(path)) {
    stop(sprintf("SKILL_FILE_NOT_FOUND: File does not exist: %s", path))
  }
  if (is.na(file.info(path)$size) || file.info(path)$size == 0) {
    stop(sprintf("SKILL_EMPTY_FILE: File is empty: %s", path))
  }
}

ensure_output_dir <- function(path) {
  dir.create(path, recursive = TRUE, showWarnings = FALSE)
  invisible(normalizePath(path, winslash = "/", mustWork = FALSE))
}

cleanup_empty_output_dir <- function(path) {
  if (!dir.exists(path)) return(FALSE)
  if (length(list.files(path, all.files = TRUE, no.. = TRUE)) > 0L) return(FALSE)
  unlink(path, recursive = FALSE, force = TRUE)
  !dir.exists(path)
}

validate_cli_options <- function(opt) {
  if (is.null(opt$input_file) || is.null(opt$group_file)) {
    stop("SKILL_INVALID_PARAMETER: --input_file and --group_file are required")
  }
  ensure_file_exists(opt$input_file)
  ensure_file_exists(opt$group_file)
  if (opt$k < 1L) stop("SKILL_INVALID_PARAMETER: --k must be >= 1")
  if (opt$timeout_seconds < 0) {
    stop("SKILL_INVALID_PARAMETER: --timeout_seconds must be >= 0")
  }
  if (!opt$small_strata_fill_method %in% c("mean", "median")) {
    stop("SKILL_INVALID_PARAMETER: --small_strata_fill_method must be mean or median")
  }
  group_columns <- parse_csv_arg(opt$group_column)
  if (length(group_columns) != 1L) {
    stop("SKILL_INVALID_PARAMETER: --group_column must contain exactly one column name")
  }
  invisible(TRUE)
}

validate_output_targets <- function(output_dir, overwrite = FALSE) {
  target_files <- c("imputed_expression_matrix.csv", "session_info.txt")
  existing_files <- target_files[file.exists(file.path(output_dir, target_files))]
  if (length(existing_files) > 0 && !isTRUE(overwrite)) {
    stop(sprintf(
      "SKILL_OUTPUT_EXISTS: Output files already exist in %s: %s. Use --overwrite to replace them",
      output_dir,
      paste(existing_files, collapse = ", ")
    ))
  }
  invisible(existing_files)
}

set_timeout_limit <- function(timeout_seconds) {
  if (timeout_seconds > 0) setTimeLimit(elapsed = timeout_seconds, transient = FALSE)
}

clear_timeout_limit <- function() {
  setTimeLimit(cpu = Inf, elapsed = Inf, transient = FALSE)
}

save_session_info <- function(output_dir) {
  sink(file.path(output_dir, "session_info.txt"))
  print(sessionInfo())
  sink()
}

cleanup_temp_files <- function(temp_files) {
  for (temp_file in temp_files) {
    if (file.exists(temp_file)) file.remove(temp_file)
  }
}

monitor_memory <- function(threshold_mb = 4096) {
  gc_stats <- gc()
  used_mb <- sum(gc_stats[, 2])
  if (used_mb > threshold_mb) {
    log_warn(sprintf("High memory usage detected: %.2f MB", used_mb))
    gc()
  }
  invisible(used_mb)
}

warn_large_input_file <- function(path, threshold_mb = 100) {
  file_size_mb <- file.info(path)$size / 1024 / 1024
  if (is.finite(file_size_mb) && file_size_mb > threshold_mb) {
    log_warn(sprintf(
      "Large input file detected (%.2f MB); DMwR2 loads the matrix into memory",
      file_size_mb
    ))
  }
  invisible(file_size_mb)
}
