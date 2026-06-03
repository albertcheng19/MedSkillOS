extract_correlation_results <- function(correlation_result, method, params, data) {
  analysis_data <- prepare_complete_cases(data, params$x_var, params$y_var)
  x_complete <- analysis_data$x_complete
  y_complete <- analysis_data$y_complete
  
  conf_low <- if (!is.null(correlation_result$conf.int) && length(correlation_result$conf.int) >= 1) correlation_result$conf.int[1] else NA
  conf_high <- if (!is.null(correlation_result$conf.int) && length(correlation_result$conf.int) >= 2) correlation_result$conf.int[2] else NA
  
  result_df <- data.frame(
    method = method,
    correlation = correlation_result$estimate,
    statistic = correlation_result$statistic,
    p_value = correlation_result$p.value,
    conf_low = conf_low,
    conf_high = conf_high,
    alternative = params$alternative,
    conf_level = params$conf_level,
    sample_size = length(x_complete),
    x_variable = params$x_var,
    y_variable = params$y_var,
    variable_orientation = analysis_data$orientation,
    stringsAsFactors = FALSE
  )
  
  if (method == "pearson") {
    result_df$x_mean <- mean(x_complete)
    result_df$y_mean <- mean(y_complete)
    result_df$x_sd <- sd(x_complete)
    result_df$y_sd <- sd(y_complete)
  }
  
  return(result_df)
}

save_results <- function(results_df, output_dirs, params) {
  output_files <- NULL
  
  if (params$output_format %in% c('csv')) {
    csv_file <- file.path(output_dirs$table_dir, paste0(params$output_prefix, "_", params$method, ".csv"))
    write.csv(results_df, csv_file, row.names = FALSE)
    log_info("Saved results to:", csv_file, "\n")
    output_files <- csv_file
  }
  
  if (params$output_format %in% c('txt')) {
    txt_file <- file.path(output_dirs$table_dir, paste0(params$output_prefix, "_", params$method, ".txt"))
    write.table(results_df, txt_file, row.names = FALSE, sep = "\t", quote = FALSE)
    log_info("Saved results to:", txt_file, "\n")
    output_files <- txt_file
  }
  
  return(output_files)
}

correlation_analysis <- function(params) {
  
  output_dirs <- create_output_structure(params$output_dir)
  
  log_info("\nLoading data...\n")
  data <- read_data(params$data_file)
  
  log_info("\nPerforming correlation analysis...\n")
  
  if (params$method == "pearson") {
    correlation_result <- perform_pearson_correlation(data, 
                                                      params$x_var,
                                                      params$y_var,
                                                      params$alternative,
                                                      params$conf_level)
  } else if (params$method == "spearman") {
    correlation_result <- perform_spearman_correlation(data,
                                                       params$x_var,
                                                       params$y_var,
                                                       params$alternative,
                                                       params$conf_level)
  }
  
  log_info("\nExtracting results...\n")
  results_df <- extract_correlation_results(correlation_result, params$method, params, data)
  
  log_info("\nSaving results...\n")
  output_files <- save_results(results_df, output_dirs, params)
  
  log_info("\n=== Analysis completed successfully! ===\n")
  
  return(list(
    results = results_df,
    correlation_object = correlation_result,
    parameters = params,
    output_files = output_files,
    output_dirs = output_dirs
  ))
}
