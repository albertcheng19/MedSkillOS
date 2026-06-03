compute_column_stats <- function(matrix_data) {
  list(
    sums = colSums(matrix_data, na.rm = TRUE),
    counts = colSums(!is.na(matrix_data))
  )
}

complete_reference_data <- function(reference_data, fill_means) {
  if (any(is.na(fill_means))) {
    stop("SKILL_INVALID_DATA: No fallback values available for donor reference data")
  }
  completed_data <- reference_data
  for (idx in seq_along(completed_data)) {
    missing_idx <- is.na(completed_data[[idx]])
    if (any(missing_idx)) completed_data[[idx]][missing_idx] <- fill_means[idx]
  }
  completed_data
}

compute_leave_one_out_means <- function(target_row, column_stats, global_feature_means) {
  adjusted_sums <- column_stats$sums - ifelse(is.na(target_row), 0, target_row)
  adjusted_counts <- column_stats$counts - ifelse(is.na(target_row), 0, 1)
  donor_means <- adjusted_sums / adjusted_counts
  donor_means[adjusted_counts <= 0] <- global_feature_means[adjusted_counts <= 0]
  donor_means
}

impute_target_sample <- function(target_row, donor_data, k, global_feature_means, donor_means,
                                 allowed_features = rep(TRUE, length(target_row))) {
  imputable_cols <- allowed_features & !is.na(global_feature_means)
  if (!any(imputable_cols) || !any(is.na(target_row[imputable_cols]))) return(target_row)

  target_values <- target_row[imputable_cols]
  missing_target <- is.na(target_values)
  if (!any(!missing_target)) {
    target_values[missing_target] <- donor_means[imputable_cols][missing_target]
    target_row[imputable_cols] <- target_values
    return(target_row)
  }

  reference_data <- as.data.frame(donor_data[, imputable_cols, drop = FALSE], check.names = FALSE)
  completed_reference <- complete_reference_data(reference_data, donor_means[imputable_cols])
  effective_k <- min(k, nrow(completed_reference))
  if (effective_k < 1L) return(target_row)

  names(target_values) <- colnames(reference_data)
  target_data <- as.data.frame(as.list(target_values), check.names = FALSE)
  imputed_target <- DMwR2::knnImputation(
    target_data,
    distData = completed_reference,
    k = effective_k,
    scale = FALSE,
    meth = "weighAvg"
  )
  target_row[imputable_cols] <- unlist(imputed_target[1, ], use.names = FALSE)
  target_row
}

impute_sample_index <- function(sample_idx, transposed, k, global_feature_means, column_stats,
                                allowed_features) {
  before_row <- unlist(transposed[sample_idx, ], use.names = FALSE)
  if (!anyNA(before_row)) {
    return(list(index = sample_idx, row = before_row, resolved = 0L))
  }

  donor_idx <- setdiff(seq_len(nrow(transposed)), sample_idx)
  donor_means <- compute_leave_one_out_means(before_row, column_stats, global_feature_means)
  imputed_row <- impute_target_sample(before_row, transposed[donor_idx, , drop = FALSE],
                                      k, global_feature_means, donor_means, allowed_features)
  list(index = sample_idx, row = imputed_row,
       resolved = sum(is.na(before_row) & !is.na(imputed_row)))
}
