log_msg <- function(level, ...) {
  timestamp <- format(Sys.time(), "%Y-%m-%d %H:%M:%S")
  msg <- paste(..., sep = "", collapse = "")
  cat(paste0("[", timestamp, "] ", toupper(level), ": ", msg, "\n"))
}

log_info <- function(...) log_msg("info", ...)
log_error <- function(...) log_msg("error", ...)
log_warn <- function(...) log_msg("warn", ...)

validate_parameters_opt <- function(params) {
  if (!file.exists(params$data_file)) {
    stop("SKILL_FILE_NOT_FOUND: Data file not found: ", params$data_file)
  }
  
  if (!(params$method %in% c('pearson', 'spearman'))) {
    stop("SKILL_INVALID_PARAMETER: method must be one of: 'pearson', 'spearman'")
  }
  
  if (!(params$alternative %in% c('two.sided', 'less', 'greater'))) {
    stop("SKILL_INVALID_PARAMETER: alternative must be one of: 'two.sided', 'less', 'greater'")
  }
  
  if (params$conf_level <= 0 || params$conf_level >= 1) {
    stop("SKILL_INVALID_PARAMETER: conf_level must be between 0 and 1 (exclusive)")
  }
  
  if (!(params$output_format %in% c('csv', 'txt'))) {
    stop("SKILL_INVALID_PARAMETER: output_format must be one of: 'csv', 'txt'")
  }
  
  return(params)
}

read_data <- function(file_path) {
  check_pkg("data.table")
  if (!file.exists(file_path)) {
    stop("SKILL_FILE_NOT_FOUND: File not found: ", file_path)
  }
  
  file_ext <- tools::file_ext(file_path)
  log_info("Loading data from", file_path, "(", file_ext, "format)...\n")
  
  if (file_ext == "csv") {
    data <- fread(file_path, header = TRUE, check.names = FALSE)
  } else if (file_ext %in% c("txt", "tsv")) {
    data <- fread(file_path, header = TRUE, sep = ifelse(file_ext == "tsv", "\t", ""), check.names = FALSE)
  } else if (file_ext == "") {
    data <- fread(file_path, header = TRUE, sep = "\t", check.names = FALSE)
  } else {
    stop("SKILL_INVALID_PARAMETER: Unsupported file format: ", file_ext, 
         ". Supported formats: .csv, .txt, .tsv")
  }
  
  log_info("Data loaded:", nrow(data), "rows,", ncol(data), "columns\n")
  
  return(data)
}

create_output_structure <- function(base_dir) {
  if (!dir.exists(base_dir)) {
    dir.create(base_dir, recursive = TRUE, showWarnings = FALSE)
    log_info("Created output directory:", base_dir, "\n")
  }

  dir.create(paste0(base_dir, "/data"), recursive = TRUE, showWarnings = FALSE)
  dir.create(paste0(base_dir, "/table"), recursive = TRUE, showWarnings = FALSE)
  dir.create(paste0(base_dir, "/figure"), recursive = TRUE, showWarnings = FALSE)
  
  return(list(
    base_dir = base_dir,
    data_dir = paste0(base_dir, "/data"),
    table_dir = paste0(base_dir, "/table"),
    figure_dir = paste0(base_dir, "/figure")
  ))
}

check_pkg <- function(pkg, min_ver = NULL) {
  if (!requireNamespace(pkg, quietly = TRUE))
    stop(paste("SKILL_DEPENDENCY_MISSING:", pkg))
  library(pkg, character.only = TRUE, warn.conflicts = FALSE)
  if (!is.null(min_ver) && packageVersion(pkg) < min_ver)
    stop(paste("SKILL_PKG_VERSION:", pkg, "needs >=", min_ver))
}

save_session_info <- function(output_dir) {
  session_file <- file.path(output_dir, "session_info.txt")
  writeLines(capture.output(sessionInfo()), session_file)
  log_info(paste("Session info saved to:", session_file))
}
