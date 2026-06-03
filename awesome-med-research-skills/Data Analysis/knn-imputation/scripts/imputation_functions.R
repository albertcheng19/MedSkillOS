fill_small_stratum <- function(stratum_matrix, fill_method, fallback_values, skip_rows = NULL) {
  if (is.null(skip_rows)) skip_rows <- rep(FALSE, nrow(stratum_matrix))
  row_fill <- if (identical(fill_method, "median")) apply(stratum_matrix, 1, median, na.rm = TRUE) else rowMeans(stratum_matrix, na.rm = TRUE)
  fillable_rows <- !skip_rows
  row_fill[is.na(row_fill) & fillable_rows] <- fallback_values[is.na(row_fill) & fillable_rows]
  missing_mask <- is.na(stratum_matrix)
  fill_mask <- missing_mask & !skip_rows[row(stratum_matrix)]
  stratum_matrix[fill_mask] <- row_fill[row(stratum_matrix)[fill_mask]]
  resolved_mask <- missing_mask & !is.na(stratum_matrix)
  list(matrix = stratum_matrix, imputed = sum(resolved_mask), unresolved = sum(is.na(stratum_matrix)),
       sample_counts = colSums(resolved_mask))
}

impute_stratum_matrix <- function(stratum_matrix, k, global_feature_means, skip_rows = NULL) {
  sample_names <- colnames(stratum_matrix)
  if (is.null(skip_rows)) skip_rows <- rep(FALSE, nrow(stratum_matrix))
  allowed_features <- !skip_rows
  if (!anyNA(stratum_matrix)) {
    counts <- setNames(integer(length(sample_names)), sample_names)
    return(list(matrix = stratum_matrix, imputed = 0L, unresolved = 0L, sample_counts = counts))
  }
  if (!any(allowed_features) || !anyNA(stratum_matrix[allowed_features, , drop = FALSE])) {
    counts <- setNames(integer(length(sample_names)), sample_names)
    return(list(matrix = stratum_matrix, imputed = 0L, unresolved = sum(is.na(stratum_matrix)), sample_counts = counts))
  }
  transposed <- as.data.frame(t(stratum_matrix), check.names = FALSE)
  column_stats <- compute_column_stats(as.matrix(transposed))
  resolved_counts <- setNames(integer(nrow(transposed)), sample_names)
  sample_indices <- seq_len(nrow(transposed))
  results <- lapply(
    sample_indices,
    impute_sample_index,
    transposed = transposed,
    k = k,
    global_feature_means = global_feature_means,
    column_stats = column_stats,
    allowed_features = allowed_features
  )
  for (result in results) {
    transposed[result$index, ] <- as.list(result$row)
    resolved_counts[result$index] <- result$resolved
  }
  imputed_transposed <- transposed
  imputed_matrix <- t(as.matrix(imputed_transposed))
  storage.mode(imputed_matrix) <- "double"
  colnames(imputed_matrix) <- colnames(stratum_matrix)
  rownames(imputed_matrix) <- rownames(stratum_matrix)
  unresolved_mask <- is.na(stratum_matrix) & is.na(imputed_matrix)
  list(matrix = imputed_matrix, imputed = sum(resolved_counts),
       unresolved = sum(unresolved_mask), sample_counts = resolved_counts)
}

impute_by_strata <- function(expression_matrix, strata_indices, k, global_feature_means,
                             small_strata_fill_method, small_strata_fill_values,
                             min_samples_for_knn = 11L, stratum_skip_rows = NULL) {
  sample_counts <- setNames(integer(ncol(expression_matrix)), colnames(expression_matrix))
  stratum_counts <- setNames(integer(length(strata_indices)), names(strata_indices))
  unresolved_counts <- stratum_counts
  imputed_matrix <- expression_matrix
  for (stratum_name in names(strata_indices)) {
    idx <- strata_indices[[stratum_name]]
    skip_rows <- if (is.null(stratum_skip_rows)) rep(FALSE, nrow(expression_matrix)) else stratum_skip_rows[[stratum_name]]
    if (sum(skip_rows) > 0L) {
      log_warn(sprintf(
        "Stratum %s: skipping imputation for %d genes with >=50%% missing values inside the stratum",
        stratum_name,
        sum(skip_rows)
      ))
    }
    if (length(idx) < min_samples_for_knn) {
      log_warn(sprintf(
        "Stratum %s has %d samples; using %s fill instead of KNN",
        stratum_name,
        length(idx),
        small_strata_fill_method
      ))
      result <- fill_small_stratum(imputed_matrix[, idx, drop = FALSE], small_strata_fill_method,
                                   small_strata_fill_values, skip_rows = skip_rows)
      imputed_matrix[, idx] <- result$matrix
      sample_counts[idx] <- sample_counts[idx] + result$sample_counts
      stratum_counts[stratum_name] <- result$imputed
      unresolved_counts[stratum_name] <- result$unresolved
      next
    }
    effective_k <- min(k, length(idx))
    if (effective_k < k) {
      log_warn(sprintf("Stratum %s has only %d samples; using k=%d", stratum_name, length(idx), effective_k))
    }
    result <- tryCatch({
      impute_stratum_matrix(imputed_matrix[, idx, drop = FALSE], effective_k,
                            global_feature_means, skip_rows = skip_rows)
    }, error = function(e) {
      stop(sprintf("SKILL_INVALID_DATA: DMwR2 failed for stratum %s: %s",
                   stratum_name, conditionMessage(e)))
    })
    imputed_matrix[, idx] <- result$matrix
    sample_counts[idx] <- sample_counts[idx] + result$sample_counts
    stratum_counts[stratum_name] <- result$imputed
    unresolved_counts[stratum_name] <- result$unresolved
  }
  list(matrix = imputed_matrix, sample_counts = sample_counts,
       stratum_counts = stratum_counts, unresolved_counts = unresolved_counts)
}
