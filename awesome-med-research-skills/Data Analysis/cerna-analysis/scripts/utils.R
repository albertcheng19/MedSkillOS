skill_stop <- function(code, message_text) {
  stop(sprintf("%s: %s", code, message_text), call. = FALSE)
}

is_skill_error <- function(message_text) {
  grepl("^SKILL_[A-Z0-9_]+:", message_text)
}

timestamp_now <- function() {
  format(Sys.time(), "%Y-%m-%d %H:%M:%S")
}

log_message <- function(level, message_text) {
  prefix <- sprintf("%-7s", sprintf("[%s]", level))
  message(sprintf("%s %s | %s", prefix, timestamp_now(), message_text))
}

log_info <- function(message_text) log_message("INFO", message_text)
log_warn <- function(message_text) log_message("WARN", message_text)
log_error <- function(message_text) log_message("ERROR", message_text)

check_required_packages <- function(packages) {
  missing_packages <- packages[!vapply(packages, requireNamespace, logical(1), quietly = TRUE)]
  if (length(missing_packages) > 0) {
    skill_stop(
      "SKILL_DEPENDENCY_MISSING",
      sprintf("Missing package(s): %s", paste(missing_packages, collapse = ", "))
    )
  }
  invisible(TRUE)
}

load_required_packages <- function(packages) {
  invisible(lapply(packages, function(pkg) {
    suppressPackageStartupMessages(library(pkg, character.only = TRUE, warn.conflicts = FALSE))
  }))
}

ensure_dir <- function(path) {
  dir.create(path, recursive = TRUE, showWarnings = FALSE)
  if (!dir.exists(path)) {
    skill_stop("SKILL_RUNTIME_ERROR", sprintf("Cannot create output directory: %s", path))
  }
  normalizePath(path, winslash = "/", mustWork = FALSE)
}

validate_file_exists <- function(path, label = "File") {
  if (!file.exists(path)) {
    skill_stop("SKILL_FILE_NOT_FOUND", sprintf("%s does not exist: %s", label, path))
  }
  if (!dir.exists(path) && isTRUE(file.info(path)$size == 0)) {
    skill_stop("SKILL_EMPTY_FILE", sprintf("%s is empty: %s", label, path))
  }
  invisible(TRUE)
}

validate_choice <- function(value, choices, label) {
  if (!value %in% choices) {
    skill_stop(
      "SKILL_INVALID_PARAMETER",
      sprintf("%s must be one of %s", label, paste(choices, collapse = ", "))
    )
  }
  invisible(TRUE)
}

validate_non_negative_integer <- function(value, label) {
  if (length(value) != 1 || is.na(value) || value < 0 || value != as.integer(value)) {
    skill_stop("SKILL_INVALID_PARAMETER", sprintf("%s must be a non-negative integer", label))
  }
  invisible(TRUE)
}

validate_positive_number <- function(value, label) {
  if (length(value) != 1 || is.na(value) || !is.finite(value) || value <= 0) {
    skill_stop("SKILL_INVALID_PARAMETER", sprintf("%s must be a positive number", label))
  }
  invisible(TRUE)
}

validate_color <- function(value, label) {
  tryCatch(
    {
      grDevices::col2rgb(value)
      invisible(TRUE)
    },
    error = function(err) {
      skill_stop("SKILL_INVALID_PARAMETER", sprintf("%s is not a valid color: %s", label, value))
    }
  )
}

run_with_timeout <- function(fun, timeout_seconds, context) {
  setTimeLimit(elapsed = timeout_seconds, transient = FALSE)
  on.exit(setTimeLimit(), add = TRUE)
  tryCatch(
    fun(),
    error = function(err) {
      err_message <- conditionMessage(err)
      if (grepl("reached .* time limit", err_message, ignore.case = TRUE)) {
        skill_stop("SKILL_TIMEOUT", sprintf("%s exceeded the timeout limit", context))
      }
      if (is_skill_error(err_message)) {
        stop(err_message, call. = FALSE)
      }
      skill_stop("SKILL_RUNTIME_ERROR", sprintf("%s failed: %s", context, err_message))
    }
  )
}

write_session_info <- function(output_dir) {
  session_file <- file.path(output_dir, "session_info.txt")
  package_versions <- data.frame(
    package = sort(loadedNamespaces()),
    version = vapply(sort(loadedNamespaces()), function(pkg) as.character(packageVersion(pkg)), character(1)),
    stringsAsFactors = FALSE
  )
  sink(session_file)
  on.exit(sink(), add = TRUE)
  print(sessionInfo())
  cat("\nLoaded package versions:\n")
  print(package_versions, row.names = FALSE)
  invisible(session_file)
}
