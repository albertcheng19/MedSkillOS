log_msg <- function(level, ...) {
  timestamp <- format(Sys.time(), "%Y-%m-%d %H:%M:%S")
  msg <- paste(..., sep = "", collapse = "")
  cat(paste0("[", timestamp, "] ", toupper(level), ": ", msg, "\n"))
}

log_info <- function(...) log_msg("info", ...)
log_warn <- function(...) log_msg("warn", ...)
log_error <- function(...) log_msg("error", ...)

check_pkg <- function(pkg, min_ver = NULL) {
  if (!requireNamespace(pkg, quietly = TRUE)) {
    stop(paste("SKILL_DEPENDENCY_MISSING:", pkg))
  }

  library(pkg, character.only = TRUE, warn.conflicts = FALSE)

  if (!is.null(min_ver) && packageVersion(pkg) < min_ver) {
    stop(paste("SKILL_PKG_VERSION:", pkg, "needs >=", min_ver))
  }
}

parse_csv_list <- function(value) {
  if (is.null(value) || identical(value, "")) {
    return(character(0))
  }

  parts <- trimws(unlist(strsplit(value, ",", fixed = TRUE)))
  unique(parts[nzchar(parts)])
}

should_promote_first_column_to_row_names <- function(data) {
  if (ncol(data) < 2) {
    return(FALSE)
  }

  first_name <- colnames(data)[1]
  normalized_name <- tolower(trimws(first_name))
  name_suggests_row_ids <- identical(first_name, "") || normalized_name %in% c(
    "id", "rowname", "row_name", "rownames", "row.names", "sample", "sample_id", "sampleid"
  )

  if (!name_suggests_row_ids && normalized_name == "v1" && is.character(data[[1]])) {
    name_suggests_row_ids <- TRUE
  }

  if (!name_suggests_row_ids) {
    return(FALSE)
  }

  row_ids <- as.character(data[[1]])
  valid_ids <- !is.na(row_ids) & nzchar(trimws(row_ids))
  all(valid_ids) && length(unique(row_ids)) == length(row_ids)
}

validate_parameters_opt <- function(params) {
  if (!file.exists(params$data_file)) {
    stop("SKILL_FILE_NOT_FOUND: Data file not found: ", params$data_file)
  }

  if (!(params$task_type %in% c("auto", "classification", "regression"))) {
    stop("SKILL_INVALID_PARAMETER: task_type must be one of: 'auto', 'classification', 'regression'")
  }

  if (!is.numeric(params$train_ratio) || params$train_ratio <= 0 || params$train_ratio >= 1) {
    stop("SKILL_INVALID_PARAMETER: train_ratio must be between 0 and 1 (exclusive)")
  }

  if (!is.numeric(params$max_depth) || params$max_depth < 1) {
    stop("SKILL_INVALID_PARAMETER: max_depth must be a positive integer")
  }

  if (!is.numeric(params$minsplit) || params$minsplit < 2) {
    stop("SKILL_INVALID_PARAMETER: minsplit must be at least 2")
  }

  if (!is.numeric(params$minbucket) || params$minbucket < 1) {
    stop("SKILL_INVALID_PARAMETER: minbucket must be at least 1")
  }

  if (!is.numeric(params$cp) || params$cp < 0) {
    stop("SKILL_INVALID_PARAMETER: cp must be non-negative")
  }

  if (!is.numeric(params$importance_top_n) || params$importance_top_n < 1) {
    stop("SKILL_INVALID_PARAMETER: importance_top_n must be at least 1")
  }

  if (!(params$output_format %in% c("csv", "txt"))) {
    stop("SKILL_INVALID_PARAMETER: output_format must be one of: 'csv', 'txt'")
  }

  params$exclude_vars <- parse_csv_list(params$exclude_vars)
  params
}

read_data <- function(file_path) {
  check_pkg("data.table")

  if (!file.exists(file_path)) {
    stop("SKILL_FILE_NOT_FOUND: File not found: ", file_path)
  }

  file_ext <- tolower(tools::file_ext(file_path))
  log_info("Loading data from ", file_path, " (", ifelse(file_ext == "", "no extension", file_ext), ")")

  if (file_ext == "csv") {
    data <- data.table::fread(file_path, header = TRUE, check.names = FALSE)
  } else if (file_ext %in% c("txt", "tsv")) {
    sep_value <- "\t"
    data <- data.table::fread(file_path, header = TRUE, sep = sep_value, check.names = FALSE)
  } else if (file_ext == "") {
    data <- data.table::fread(file_path, header = TRUE, sep = "\t", check.names = FALSE)
  } else {
    stop("SKILL_INVALID_PARAMETER: Unsupported file format: ", file_ext,
         ". Supported formats: .csv, .txt, .tsv")
  }

  if (should_promote_first_column_to_row_names(data)) {
    row_id_name <- colnames(data)[1]
    if (identical(row_id_name, "") || identical(tolower(trimws(row_id_name)), "v1")) {
      row_id_name <- "row_name"
    }

    attr(data, "row_ids") <- as.character(data[[1]])
    attr(data, "row_id_name") <- row_id_name
    data <- data[, -1, with = FALSE]
    log_info("Detected first column as row identifiers: ", row_id_name)
  }

  log_info("Data loaded: ", nrow(data), " rows, ", ncol(data), " columns")
  data
}

create_output_structure <- function(base_dir) {
  if (!dir.exists(base_dir)) {
    dir.create(base_dir, recursive = TRUE, showWarnings = FALSE)
    log_info("Created output directory: ", base_dir)
  }

  dir.create(file.path(base_dir, "data"), recursive = TRUE, showWarnings = FALSE)
  dir.create(file.path(base_dir, "table"), recursive = TRUE, showWarnings = FALSE)
  dir.create(file.path(base_dir, "figure"), recursive = TRUE, showWarnings = FALSE)

  list(
    base_dir = base_dir,
    data_dir = file.path(base_dir, "data"),
    table_dir = file.path(base_dir, "table"),
    figure_dir = file.path(base_dir, "figure")
  )
}

save_session_info <- function(output_dir) {
  session_file <- file.path(output_dir, "session_info.txt")
  writeLines(capture.output(sessionInfo()), session_file)
  log_info("Session info saved to: ", session_file)
}
