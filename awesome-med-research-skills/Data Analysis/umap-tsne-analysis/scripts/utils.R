log_msg <- function(level, msg) {
  timestamp <- format(Sys.time(), "%Y-%m-%d %H:%M:%S")
  cat(paste0("[", timestamp, "] ", toupper(level), ": ", msg, "\n"),
      file = if (level == "error") stderr() else stdout())
}

log_info <- function(msg) log_msg("info", msg)
log_warn <- function(msg) log_msg("warn", msg)
log_error <- function(msg) log_msg("error", msg)

normalize_warning_message <- function(msg) {
  gsub("\\s+", " ", trimws(msg))
}

quit_with_error <- function(msg) {
  log_error(msg)
  quit(save = "no", status = 1)
}

check_files <- function(input_file, group_file) {
  if (!file.exists(input_file)) {
    stop(paste("SKILL_FILE_NOT_FOUND:", input_file))
  }
  if (!file.exists(group_file)) {
    stop(paste("SKILL_FILE_NOT_FOUND:", group_file))
  }
  invisible(TRUE)
}

prepare_output_dir <- function(output_dir) {
  dir.create(output_dir, recursive = TRUE, showWarnings = FALSE)
  dir.create(file.path(output_dir, "table"), recursive = TRUE, showWarnings = FALSE)
  dir.create(file.path(output_dir, "plot"), recursive = TRUE, showWarnings = FALSE)
  dir.create(file.path(output_dir, "data"), recursive = TRUE, showWarnings = FALSE)
  invisible(TRUE)
}

save_session_info <- function(output_dir) {
  session_file <- file.path(output_dir, "data", "session_info.txt")
  writeLines(capture.output(sessionInfo()), session_file)
  log_info(paste("Session info saved to:", session_file))
}

read_matrix_file <- function(input_file) {
  df <- data.table::fread(input_file, data.table = FALSE)
  if (nrow(df) == 0) {
    stop("SKILL_EMPTY_DATA: input_file contains no rows")
  }
  if (ncol(df) < 2) {
    stop("SKILL_MISSING_COLUMNS: input_file must contain feature ID column and sample columns")
  }
  df
}

read_group_file <- function(group_file) {
  df <- data.table::fread(group_file, data.table = FALSE, header = TRUE)
  if (nrow(df) == 0) {
    stop("SKILL_EMPTY_DATA: group_file contains no rows")
  }
  if (ncol(df) < 2) {
    stop("SKILL_MISSING_COLUMNS: group_file must contain sample ID and group columns")
  }
  df
}

resolve_sample_id_col <- function(group_df, sample_id_col) {
  if (is.null(sample_id_col)) {
    return(colnames(group_df)[1])
  }
  if (!sample_id_col %in% colnames(group_df)) {
    stop("SKILL_MISSING_COLUMNS: sample_id_col not found in group_file")
  }
  sample_id_col
}

resolve_group_col <- function(group_df, group_col) {
  if (is.null(group_col)) {
    return(colnames(group_df)[2])
  }
  if (!group_col %in% colnames(group_df)) {
    stop("SKILL_MISSING_COLUMNS: group_col not found in group_file")
  }
  group_col
}

normalize_group_table <- function(group_df, sample_id_col, group_col) {
  group_df <- group_df[, c(sample_id_col, group_col), drop = FALSE]
  colnames(group_df) <- c("SampleID", group_col)
  rownames(group_df) <- group_df$SampleID
  group_df[[group_col]] <- factor(group_df[[group_col]], levels = unique(group_df[[group_col]]))
  group_df
}

validate_groups <- function(group_df, group_col, min_per_group = 2) {
  counts <- table(group_df[[group_col]])
  if (length(counts) < 2) {
    stop("SKILL_INVALID_PARAMETER: At least 2 groups are required")
  }
  if (min(counts) < min_per_group) {
    stop("SKILL_INVALID_PARAMETER: Each group must have at least 2 samples")
  }
  invisible(TRUE)
}

align_and_prepare_matrix <- function(mat_df, group_df) {
  rownames(mat_df) <- mat_df[[1]]
  mat_df <- mat_df[, -1, drop = FALSE]
  
  mat <- as.matrix(mat_df)
  suppressWarnings(storage.mode(mat) <- "numeric")
  
  if (any(is.na(mat))) {
    stop("SKILL_INVALID_PARAMETER: abundance matrix contains non-numeric values")
  }
  
  sample_cols <- group_df$SampleID
  if (!all(sample_cols %in% colnames(mat))) {
    missing <- setdiff(sample_cols, colnames(mat))
    stop(paste("SKILL_SAMPLE_MISMATCH:", paste(head(missing, 10), collapse = ", ")))
  }
  
  mat <- t(mat[, sample_cols, drop = FALSE])
  keep <- rowSums(mat, na.rm = TRUE) > 0
  
  if (any(!keep)) {
    dropped_samples <- rownames(mat)[!keep]
    log_warn(paste(
      "Dropped zero-abundance samples after alignment:",
      paste(dropped_samples, collapse = ", ")
    ))
  }
  
  mat <- mat[keep, , drop = FALSE]
  group_df <- group_df[group_df$SampleID %in% rownames(mat), , drop = FALSE]
  
  if (nrow(group_df) > 0) {
    group_df <- group_df[match(rownames(mat), group_df$SampleID), , drop = FALSE]
    rownames(group_df) <- group_df$SampleID
  }
  
  if (nrow(mat) == 0 || ncol(mat) == 0) {
    stop("SKILL_EMPTY_DATA: matrix is empty after preprocessing")
  }
  
  list(mat = mat, group_df = group_df)
}

save_table <- function(df, file_path) {
  write.csv(df, file_path, row.names = FALSE)
  log_info(paste("Saved table:", file_path))
}

save_plot_pdf <- function(plot_obj, file_path, width = 6, height = 5) {
  captured_warnings <- character(0)

  withCallingHandlers(
    ggplot2::ggsave(filename = file_path, plot = plot_obj, width = width, height = height),
    warning = function(w) {
      captured_warnings <<- c(captured_warnings, conditionMessage(w))
      invokeRestart("muffleWarning")
    }
  )

  log_info(paste("Saved plot:", file_path))

  for (warn in unique(vapply(captured_warnings, normalize_warning_message, character(1)))) {
    log_warn(paste("Plot rendering note:", warn))
  }
}

generate_group_colors <- function(n_group) {
  base_colors <- c(
    "#1597A5", "#FFC24B", "#FEB3AE", "#4DBBD5",
    "#E64B35", "#3C5488", "#00A087", "#F39B7F"
  )
  if (n_group <= length(base_colors)) {
    return(base_colors[seq_len(n_group)])
  }
  grDevices::colorRampPalette(base_colors)(n_group)
}

save_analysis_rda <- function(dat, output_dir,
                              input_file, group_file,
                              method, sample_id_col,
                              perplexity, theta, pca, check_duplicates,
                              normalize, norm_method, n_neighbors,
                              seed, timeout, colors) {
  analysis_data <- list(
    input_file = input_file,
    group_file = group_file,
    output_dir = normalizePath(output_dir, winslash = "/", mustWork = FALSE),
    
    mat = dat$mat,
    map = dat$map,
    group_col = dat$group_col,
    colors = colors,
    
    method = method,
    sample_id_col = sample_id_col,
    perplexity = perplexity,
    theta = theta,
    pca = pca,
    check_duplicates = check_duplicates,
    normalize = normalize,
    norm_method = norm_method,
    n_neighbors = n_neighbors,
    seed = seed,
    timeout = timeout
  )
  
  save(analysis_data, file = file.path(output_dir, "data", "analysis_data.rda"))
  log_info("Saved analysis object: data/analysis_data.rda")
}

with_timeout <- function(expr, timeout = 0) {
  if (timeout <= 0) {
    return(force(expr))
  }
  if (!requireNamespace("R.utils", quietly = TRUE)) {
    stop(
      paste(
        "SKILL_PACKAGE_NOT_FOUND: R.utils is required when timeout > 0",
        "| Run: Rscript scripts/install_dependencies.R"
      )
    )
  }
  tryCatch(
    R.utils::withTimeout(expr, timeout = timeout, onTimeout = "error"),
    TimeoutException = function(e) {
      stop(
        paste(
          "SKILL_TIMEOUT: analysis exceeded", timeout, "seconds",
          "| Increase --timeout or use --timeout 0 to disable timeout"
        )
      )
    }
  )
}
