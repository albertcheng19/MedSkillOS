write_imputed_matrix <- function(output_dir, expression_data, imputed_matrix) {
  output_df <- data.frame(expression_data$feature_ids, imputed_matrix,
                          check.names = FALSE, stringsAsFactors = FALSE)
  colnames(output_df) <- c(expression_data$feature_column, expression_data$sample_names)
  output_file <- file.path(output_dir, "imputed_expression_matrix.csv")
  header_line <- paste(c(expression_data$feature_column, expression_data$sample_names),
                       collapse = ",")
  writeLines(header_line, output_file, useBytes = TRUE)
  data.table::fwrite(output_df, output_file, append = TRUE, col.names = FALSE)
}

filter_expression_by_missingness <- function(expression_data, max_missing_fraction = 0.5) {
  missing_fraction <- rowMeans(is.na(expression_data$matrix))
  keep_rows <- missing_fraction < max_missing_fraction
  removed_count <- sum(!keep_rows)
  if (!any(keep_rows)) {
    stop("SKILL_INVALID_DATA: All genes were removed by the >=50% missingness filter")
  }
  list(
    expression_data = list(
      feature_column = expression_data$feature_column,
      feature_ids = expression_data$feature_ids[keep_rows],
      sample_names = expression_data$sample_names,
      matrix = expression_data$matrix[keep_rows, , drop = FALSE]
    ),
    removed_count = removed_count,
    removed_features = expression_data$feature_ids[!keep_rows]
  )
}

compute_stratum_skip_rows <- function(expression_matrix, strata_indices, max_missing_fraction = 0.5) {
  skip_rows <- lapply(strata_indices, function(idx) {
    rowMeans(is.na(expression_matrix[, idx, drop = FALSE])) >= max_missing_fraction
  })
  names(skip_rows) <- names(strata_indices)
  skip_rows
}

normalize_analysis_options <- function(opt) {
  defaults <- list(
    sample_column = "sample",
    group_column = "group",
    k = 10L,
    small_strata_fill_method = "mean",
    timeout_seconds = 0L,
    seed = 42L,
    overwrite = FALSE
  )
  for (name in names(defaults)) {
    if (is.null(opt[[name]])) {
      opt[[name]] <- defaults[[name]]
    }
  }
  opt
}

run_analysis <- function(opt) {
  opt <- normalize_analysis_options(opt)
  group_column <- parse_csv_arg(opt$group_column)[1]
  min_samples_for_knn <- 11L
  log_info("Step 1/3: Loading and validating data...")
  warn_large_input_file(opt$input_file)
  expression_data <- load_expression_data(opt$input_file)
  filtered_expression <- filter_expression_by_missingness(expression_data)
  expression_data <- filtered_expression$expression_data
  group_raw <- data.table::fread(opt$group_file, data.table = FALSE, check.names = FALSE)
  group_data <- prepare_group_data(group_raw, opt$sample_column, group_column, expression_data$sample_names)
  names(group_data)[names(group_data) == opt$sample_column] <- "sample"
  strata_indices <- split(seq_along(expression_data$sample_names), group_data$stratum)
  stratum_skip_rows <- compute_stratum_skip_rows(expression_data$matrix, strata_indices)
  input_missing <- sum(is.na(expression_data$matrix))
  global_feature_means <- rowMeans(expression_data$matrix, na.rm = TRUE)
  global_feature_means[is.nan(global_feature_means)] <- NA_real_
  names(global_feature_means) <- expression_data$feature_ids
  small_strata_fill_values <- if (identical(opt$small_strata_fill_method, "median")) {
    apply(expression_data$matrix, 1, median, na.rm = TRUE)
  } else {
    global_feature_means
  }
  small_strata_fill_values[is.nan(small_strata_fill_values)] <- NA_real_
  names(small_strata_fill_values) <- expression_data$feature_ids
  log_info(sprintf("Detected %d samples across %d strata", length(expression_data$sample_names), length(strata_indices)))
  log_info(sprintf("Strata: %s", paste(names(strata_indices), collapse = ", ")))
  strata_sizes <- lengths(strata_indices)
  if (filtered_expression$removed_count > 0L) {
    log_warn(sprintf(
      "Removed %d genes with >=50%% missing values across all samples before imputation",
      filtered_expression$removed_count
    ))
  }
  if (input_missing > 0L) {
    log_warn(sprintf("Detected %d missing values in the input matrix", input_missing))
  }
  skipped_gene_strata <- sum(vapply(stratum_skip_rows, sum, integer(1)))
  if (skipped_gene_strata > 0L) {
    log_warn(sprintf(
      "Skipping imputation for %d gene-stratum combinations with >=50%% missing values inside their stratum",
      skipped_gene_strata
    ))
  }
  skipped_strata <- sum(strata_sizes < min_samples_for_knn)
  if (skipped_strata > 0L) {
    log_warn(sprintf(
      "%d/%d strata are too small for KNN; using %s fill for strata with %d or fewer samples",
      skipped_strata,
      length(strata_sizes),
      opt$small_strata_fill_method,
      min_samples_for_knn - 1L
    ))
  }
  log_info(sprintf(
    "Step 2/3: Running stratified DMwR2 KNN imputation where stratum size is at least %d (k=%d)...",
    min_samples_for_knn,
    opt$k
  ))
  imputed <- impute_by_strata(expression_data$matrix, strata_indices, opt$k,
                              global_feature_means, opt$small_strata_fill_method,
                              small_strata_fill_values, stratum_skip_rows = stratum_skip_rows)
  ensure_output_dir(opt$output_dir)
  log_info("Step 3/3: Writing output files...")
  write_imputed_matrix(opt$output_dir, expression_data, imputed$matrix)
  if (sum(imputed$unresolved_counts) > 0L) {
    log_warn(sprintf("%d values remained NA after DMwR2 imputation", sum(imputed$unresolved_counts)))
  }
  monitor_memory()
  log_info(sprintf("Imputed %d values across all strata", sum(imputed$sample_counts)))
  invisible(imputed)
}
