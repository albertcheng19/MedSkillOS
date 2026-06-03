#!/usr/bin/env Rscript

`%||%` <- function(x, y) {
  if (is.null(x) || !length(x) || (is.character(x) && !nzchar(x))) y else x
}

timestamp_now <- function() {
  format(Sys.time(), "%Y-%m-%d %H:%M:%S")
}

log_message <- function(level, text) {
  message(sprintf("[%s] %s | %s", level, timestamp_now(), text))
}

log_info <- function(text) log_message("INFO", text)
log_warn <- function(text) log_message("WARN", text)

stop_skill <- function(code, text) {
  stop(sprintf("%s | %s", code, text), call. = FALSE)
}

ensure_dir <- function(path) {
  if (!dir.exists(path)) {
    dir.create(path, recursive = TRUE, showWarnings = FALSE)
  }
  invisible(path)
}

check_required_packages <- function(packages) {
  missing <- packages[!vapply(packages, requireNamespace, logical(1), quietly = TRUE)]
  if (length(missing) > 0) {
    stop_skill(
      "SKILL_PACKAGE_NOT_FOUND",
      sprintf("Missing required package(s): %s", paste(missing, collapse = ", "))
    )
  }
}

validate_required_columns <- function(tbl, required_columns, label) {
  missing <- setdiff(required_columns, colnames(tbl))
  if (length(missing) > 0) {
    stop_skill(
      "SKILL_MISSING_COLUMNS",
      sprintf("%s is missing required columns: %s", label, paste(missing, collapse = ", "))
    )
  }
  tbl
}

enable_timeout <- function(timeout_seconds) {
  if (!is.null(timeout_seconds) && isTRUE(timeout_seconds > 0)) {
    setTimeLimit(elapsed = timeout_seconds, transient = TRUE)
  }
}

resolve_output_dir <- function(output_dir, skill_root) {
  split_path_parts <- function(path) {
    parts <- unlist(strsplit(gsub("\\\\", "/", path), "/", fixed = TRUE))
    parts[nzchar(parts)]
  }

  collapse_parts <- function(parts) {
    stack <- character()
    for (part in parts) {
      if (part %in% c("", ".")) next
      if (part == "..") {
        if (!length(stack)) {
          return(NULL)
        }
        stack <- stack[-length(stack)]
      } else {
        stack <- c(stack, part)
      }
    }
    stack
  }

  is_absolute <- grepl("^[A-Za-z]:[/\\\\]|^/", output_dir)
  root_norm <- normalizePath(skill_root, winslash = "/", mustWork = TRUE)
  root_parts <- split_path_parts(root_norm)
  output_parts <- split_path_parts(output_dir)

  if (is_absolute) {
    normalized_parts <- collapse_parts(output_parts)
    if (is.null(normalized_parts)) {
      stop_skill("SKILL_INVALID_PARAMETER", "Output directory must stay inside the skill root directory.")
    }
    normalized <- if (grepl("^[A-Za-z]:", output_dir)) {
      drive <- sub("^([A-Za-z]:).*", "\\1", gsub("\\\\", "/", output_dir))
      paste(c(drive, normalized_parts), collapse = "/")
    } else {
      paste0("/", paste(normalized_parts, collapse = "/"))
    }
  } else {
    combined_parts <- c(root_parts, output_parts)
    normalized_parts <- collapse_parts(combined_parts)
    if (is.null(normalized_parts) || length(normalized_parts) < length(root_parts)) {
      stop_skill("SKILL_INVALID_PARAMETER", "Output directory must stay inside the skill root directory.")
    }
    normalized <- if (grepl("^[A-Za-z]:", root_norm)) {
      drive <- sub("^([A-Za-z]:).*", "\\1", root_norm)
      paste(c(drive, normalized_parts[-1]), collapse = "/")
    } else {
      paste0("/", paste(normalized_parts, collapse = "/"))
    }
  }

  root_prefix <- paste0(root_norm, "/")
  if (!(identical(normalized, root_norm) || startsWith(paste0(normalized, "/"), root_prefix))) {
    stop_skill("SKILL_INVALID_PARAMETER", "Output directory must stay inside the skill root directory.")
  }
  normalized
}

validate_plot_file_name <- function(file_name) {
  if (grepl("[/\\\\]", file_name)) {
    stop_skill("SKILL_INVALID_PARAMETER", "--plot_file must be a file name only, not a path.")
  }
  if (!grepl("\\.pdf$", file_name, ignore.case = TRUE)) {
    stop_skill("SKILL_INVALID_PARAMETER", "--plot_file must end with .pdf.")
  }
  file_name
}

parse_optional_list <- function(value) {
  if (is.null(value) || !nzchar(value)) {
    return(character())
  }
  if (file.exists(value)) {
    items <- readLines(value, warn = FALSE)
  } else {
    items <- strsplit(value, ",", fixed = TRUE)[[1]]
  }
  unique(trimws(items[nzchar(trimws(items))]))
}
