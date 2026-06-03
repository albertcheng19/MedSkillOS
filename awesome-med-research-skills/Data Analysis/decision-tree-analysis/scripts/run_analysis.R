write_table_output <- function(df, file_path, output_format) {
  if (identical(output_format, "csv")) {
    utils::write.csv(df, file_path, row.names = FALSE)
  } else {
    utils::write.table(df, file_path, row.names = FALSE, sep = "\t", quote = FALSE)
  }
}

save_importance_plot <- function(importance_df, output_file, top_n, task_type) {
  plot_df <- utils::head(importance_df, top_n)
  if (nrow(plot_df) == 0) {
    stop("SKILL_INVALID_DATA: No feature importance values available for plotting")
  }

  plot_df <- plot_df[seq(nrow(plot_df), 1), , drop = FALSE]
  image_height_inches <- max(6, 1.5 + 0.4 * nrow(plot_df))
  label_width <- max(nchar(plot_df$feature))

  grDevices::pdf(output_file, width = 10, height = image_height_inches)
  graphics::par(mar = c(5, max(8, label_width * 0.8), 4, 2))
  graphics::barplot(
    plot_df$relative_importance,
    names.arg = plot_df$feature,
    horiz = TRUE,
    las = 1,
    col = "steelblue",
    xlab = "Relative importance",
    main = paste("Feature Importance Ranking -", task_type)
  )
  grDevices::dev.off()
}

decision_tree_analysis <- function(params) {
  log_info("Preparing decision tree analysis")
  raw_data <- read_data(params$data_file)
  prepared <- prepare_model_data(raw_data, params$target_var, params$exclude_vars, params$task_type)
  output_dirs <- create_output_structure(params$output_dir)

  log_info("Task type resolved as: ", prepared$task_type)
  log_info("Predictor count: ", length(prepared$predictors))
  log_info("Usable rows: ", prepared$row_count)

  split_data <- split_train_test(prepared$data, prepared$target_var, prepared$task_type, params$train_ratio, params$seed)
  log_info("Train rows: ", nrow(split_data$train), ", Test rows: ", nrow(split_data$test))

  model <- fit_decision_tree(
    train_df = split_data$train,
    target_var = prepared$target_var,
    task_type = prepared$task_type,
    max_depth = params$max_depth,
    minsplit = params$minsplit,
    minbucket = params$minbucket,
    cp = params$cp
  )

  if (is_unsplit_tree(model)) {
    log_warn(
      "Decision tree did not split. Results may be degenerate. ",
      "Try lowering --minsplit and --minbucket, or provide more training rows."
    )
  }

  evaluation <- evaluate_model(model, split_data$test, prepared$target_var, prepared$task_type)
  importance_df <- build_importance_table(model, prepared$predictors)

  metrics_df <- evaluation$metrics
  metrics_df$task_type <- prepared$task_type
  metrics_df$target_var <- prepared$target_var
  metrics_df$train_rows <- nrow(split_data$train)
  metrics_df$test_rows <- nrow(split_data$test)
  metrics_df <- metrics_df[, c("task_type", "target_var", "train_rows", "test_rows", "metric", "value")]

  table_ext <- if (identical(params$output_format, "csv")) "csv" else "txt"
  importance_file <- file.path(output_dirs$table_dir, paste0("decision_tree_feature_importance.", table_ext))
  metrics_file <- file.path(output_dirs$table_dir, "decision_tree_metrics.csv")
  predictions_file <- file.path(output_dirs$data_dir, "decision_tree_predictions.csv")
  model_file <- file.path(output_dirs$data_dir, "decision_tree_model.rds")
  figure_file <- file.path(output_dirs$figure_dir, "decision_tree_feature_importance.pdf")

  write_table_output(importance_df, importance_file, params$output_format)
  utils::write.csv(metrics_df, metrics_file, row.names = FALSE)
  utils::write.csv(evaluation$predictions, predictions_file, row.names = FALSE)
  saveRDS(model, model_file)
  save_importance_plot(importance_df, figure_file, params$importance_top_n, prepared$task_type)

  log_info("Saved feature importance table to: ", importance_file)
  log_info("Saved metrics table to: ", metrics_file)
  log_info("Saved predictions to: ", predictions_file)
  log_info("Saved model object to: ", model_file)
  log_info("Saved feature importance figure to: ", figure_file)
  log_info("=== Analysis completed successfully ===")

  list(
    task_type = prepared$task_type,
    importance = importance_df,
    metrics = metrics_df,
    predictions = evaluation$predictions,
    output_dirs = output_dirs
  )
}
