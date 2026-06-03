infer_task_type <- function(target_values) {
  non_missing <- target_values[!is.na(target_values)]

  if (is.numeric(non_missing)) {
    unique_count <- length(unique(non_missing))
    if (unique_count > 10) {
      return("regression")
    }
    return("classification")
  }

  "classification"
}

replace_blank_strings <- function(df) {
  for (col_name in names(df)) {
    if (is.character(df[[col_name]])) {
      trimmed <- trimws(df[[col_name]])
      trimmed[trimmed == ""] <- NA_character_
      df[[col_name]] <- trimmed
    }
  }
  df
}

count_unique_values <- function(column) {
  length(unique(column[!is.na(column)]))
}

prepare_model_data <- function(data, target_var, exclude_vars, task_type) {
  row_ids <- attr(data, "row_ids")
  row_id_name <- attr(data, "row_id_name")

  if (!(target_var %in% colnames(data))) {
    stop("SKILL_MISSING_COLUMNS: Target variable '", target_var, "' not found in data")
  }

  missing_exclusions <- setdiff(exclude_vars, colnames(data))
  if (length(missing_exclusions) > 0) {
    stop("SKILL_MISSING_COLUMNS: Excluded columns not found in data: ", paste(missing_exclusions, collapse = ", "))
  }

  if (target_var %in% exclude_vars) {
    stop("SKILL_INVALID_PARAMETER: target_var cannot also appear in exclude_vars")
  }

  selected_columns <- setdiff(colnames(data), exclude_vars)
  predictor_names <- setdiff(selected_columns, target_var)
  if (length(predictor_names) == 0) {
    stop("SKILL_INVALID_DATA: No predictor columns remain after excluding target_var and exclude_vars")
  }

  model_df <- as.data.frame(data[, selected_columns, with = FALSE], stringsAsFactors = FALSE)
  if (!is.null(row_ids)) {
    rownames(model_df) <- row_ids
    attr(model_df, "row_id_name") <- row_id_name
  }
  model_df <- replace_blank_strings(model_df)

  resolved_task_type <- if (identical(task_type, "auto")) infer_task_type(model_df[[target_var]]) else task_type

  for (predictor in predictor_names) {
    predictor_values <- model_df[[predictor]]
    if (is.character(predictor_values) || is.logical(predictor_values)) {
      model_df[[predictor]] <- factor(predictor_values)
    }
  }

  if (identical(resolved_task_type, "classification")) {
    model_df[[target_var]] <- factor(model_df[[target_var]])
  } else {
    if (!is.numeric(model_df[[target_var]])) {
      converted_target <- suppressWarnings(as.numeric(model_df[[target_var]]))
      if (any(is.na(converted_target) & !is.na(model_df[[target_var]]))) {
        stop("SKILL_INVALID_DATA: Target variable '", target_var, "' must be numeric for regression")
      }
      model_df[[target_var]] <- converted_target
    }
  }

  complete_rows <- stats::complete.cases(model_df)
  removed_rows <- sum(!complete_rows)
  if (removed_rows > 0) {
    log_warn("Removed ", removed_rows, " rows with missing values in modeling columns")
  }
  model_df <- model_df[complete_rows, , drop = FALSE]
  if (!is.null(row_id_name)) {
    attr(model_df, "row_id_name") <- row_id_name
  }

  if (nrow(model_df) < 5) {
    stop("SKILL_INSUFFICIENT_DATA: Need at least 5 complete rows after filtering, found: ", nrow(model_df))
  }

  retained_predictors <- predictor_names[vapply(model_df[predictor_names], count_unique_values, integer(1)) > 1]
  removed_predictors <- setdiff(predictor_names, retained_predictors)
  if (length(removed_predictors) > 0) {
    log_warn("Dropped constant predictors: ", paste(removed_predictors, collapse = ", "))
  }

  if (length(retained_predictors) == 0) {
    stop("SKILL_INVALID_DATA: No predictors with at least two distinct values remain after filtering")
  }

  model_df <- model_df[, c(target_var, retained_predictors), drop = FALSE]
  if (!is.null(row_id_name)) {
    attr(model_df, "row_id_name") <- row_id_name
  }

  if (identical(resolved_task_type, "classification")) {
    model_df[[target_var]] <- droplevels(factor(model_df[[target_var]]))
    class_count <- nlevels(model_df[[target_var]])
    if (class_count < 2) {
      stop("SKILL_INSUFFICIENT_DATA: Classification requires at least two target classes after filtering")
    }
  } else {
    if (count_unique_values(model_df[[target_var]]) < 2) {
      stop("SKILL_INSUFFICIENT_DATA: Regression target must have at least two distinct values")
    }
  }

  list(
    data = model_df,
    target_var = target_var,
    predictors = retained_predictors,
    task_type = resolved_task_type,
    removed_predictors = removed_predictors,
    row_count = nrow(model_df),
    row_id_name = row_id_name
  )
}

build_prediction_output <- function(test_df, actual, predicted) {
  prediction_df <- data.frame(
    actual = actual,
    predicted = predicted,
    stringsAsFactors = FALSE
  )

  row_id_name <- attr(test_df, "row_id_name")
  default_row_names <- as.character(seq_len(nrow(test_df)))
  if (is.null(row_id_name) && !identical(rownames(test_df), default_row_names)) {
    row_id_name <- "row_name"
  }

  if (!is.null(row_id_name) && !identical(rownames(test_df), default_row_names)) {
    prediction_df <- cbind(setNames(data.frame(rownames(test_df), stringsAsFactors = FALSE), row_id_name), prediction_df)
  }

  prediction_df
}

stratified_train_indices <- function(target_values, train_ratio, seed) {
  set.seed(seed)
  index_groups <- split(seq_along(target_values), target_values)
  train_indices <- integer(0)

  for (group_indices in index_groups) {
    group_size <- length(group_indices)
    if (group_size == 1) {
      train_count <- 1
    } else {
      proposed_count <- floor(group_size * train_ratio)
      train_count <- max(1, min(group_size - 1, proposed_count))
    }
    train_indices <- c(train_indices, sample(group_indices, size = train_count))
  }

  sort(unique(train_indices))
}

split_train_test <- function(model_df, target_var, task_type, train_ratio, seed) {
  row_indices <- seq_len(nrow(model_df))

  if (identical(task_type, "classification")) {
    train_indices <- stratified_train_indices(model_df[[target_var]], train_ratio, seed)
  } else {
    set.seed(seed)
    train_count <- max(1, min(nrow(model_df) - 1, floor(nrow(model_df) * train_ratio)))
    train_indices <- sort(sample(row_indices, size = train_count))
  }

  test_indices <- setdiff(row_indices, train_indices)
  if (length(test_indices) == 0) {
    stop("SKILL_INSUFFICIENT_DATA: Test set is empty. Reduce train_ratio or provide more data")
  }

  train_df <- model_df[train_indices, , drop = FALSE]
  test_df <- model_df[test_indices, , drop = FALSE]
  row_id_name <- attr(model_df, "row_id_name")
  if (!is.null(row_id_name)) {
    attr(train_df, "row_id_name") <- row_id_name
    attr(test_df, "row_id_name") <- row_id_name
  }

  list(
    train = train_df,
    test = test_df
  )
}

fit_decision_tree <- function(train_df, target_var, task_type, max_depth, minsplit, minbucket, cp) {
  check_pkg("rpart")

  model_formula <- stats::as.formula(paste(target_var, "~ ."))
  method_name <- if (identical(task_type, "classification")) "class" else "anova"
  control <- rpart::rpart.control(
    maxdepth = as.integer(max_depth),
    minsplit = as.integer(minsplit),
    minbucket = as.integer(minbucket),
    cp = cp,
    xval = 0
  )

  rpart::rpart(
    formula = model_formula,
    data = train_df,
    method = method_name,
    control = control,
    model = TRUE
  )
}

is_unsplit_tree <- function(model) {
  if (is.null(model$frame) || nrow(model$frame) <= 1) {
    return(TRUE)
  }

  all(model$frame$var == "<leaf>")
}

compute_classification_metrics <- function(actual, predicted) {
  class_levels <- levels(actual)
  actual_factor <- factor(actual, levels = class_levels)
  predicted_factor <- factor(predicted, levels = class_levels)
  confusion <- table(actual = actual_factor, predicted = predicted_factor)

  tp <- diag(confusion)
  predicted_totals <- colSums(confusion)
  actual_totals <- rowSums(confusion)

  precision <- ifelse(predicted_totals == 0, NA_real_, tp / predicted_totals)
  recall <- ifelse(actual_totals == 0, NA_real_, tp / actual_totals)
  f1 <- ifelse(is.na(precision) | is.na(recall) | (precision + recall) == 0,
               NA_real_,
               2 * precision * recall / (precision + recall))

  metrics <- data.frame(
    metric = c("accuracy", "macro_precision", "macro_recall", "macro_f1"),
    value = c(
      sum(tp) / sum(confusion),
      mean(precision, na.rm = TRUE),
      mean(recall, na.rm = TRUE),
      mean(f1, na.rm = TRUE)
    ),
    stringsAsFactors = FALSE
  )

  list(metrics = metrics, confusion = confusion)
}

compute_regression_metrics <- function(actual, predicted) {
  residuals <- actual - predicted
  mse <- mean(residuals^2)
  rmse <- sqrt(mse)
  mae <- mean(abs(residuals))
  sst <- sum((actual - mean(actual))^2)
  r_squared <- if (sst == 0) NA_real_ else 1 - sum(residuals^2) / sst

  data.frame(
    metric = c("rmse", "mae", "r_squared"),
    value = c(rmse, mae, r_squared),
    stringsAsFactors = FALSE
  )
}

evaluate_model <- function(model, test_df, target_var, task_type) {
  if (identical(task_type, "classification")) {
    predicted <- predict(model, newdata = test_df, type = "class")
    metrics_result <- compute_classification_metrics(test_df[[target_var]], predicted)
    prediction_df <- build_prediction_output(test_df, as.character(test_df[[target_var]]), as.character(predicted))

    return(list(
      metrics = metrics_result$metrics,
      predictions = prediction_df,
      confusion = metrics_result$confusion
    ))
  }

  predicted <- as.numeric(predict(model, newdata = test_df))
  prediction_df <- build_prediction_output(test_df, test_df[[target_var]], predicted)

  list(
    metrics = compute_regression_metrics(test_df[[target_var]], predicted),
    predictions = prediction_df,
    confusion = NULL
  )
}

build_importance_table <- function(model, predictors) {
  importance_values <- stats::setNames(rep(0, length(predictors)), predictors)
  if (!is.null(model$variable.importance)) {
    matched_predictors <- intersect(names(model$variable.importance), predictors)
    importance_values[matched_predictors] <- unname(model$variable.importance[matched_predictors])
  }

  total_importance <- sum(importance_values)
  relative_importance <- if (total_importance > 0) importance_values / total_importance else rep(0, length(importance_values))

  importance_df <- data.frame(
    feature = names(importance_values),
    importance = as.numeric(importance_values),
    relative_importance = as.numeric(relative_importance),
    stringsAsFactors = FALSE
  )

  importance_df <- importance_df[order(-importance_df$importance, importance_df$feature), , drop = FALSE]
  importance_df$rank <- seq_len(nrow(importance_df))
  importance_df[, c("rank", "feature", "importance", "relative_importance")]
}
