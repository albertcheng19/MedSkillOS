resolve_variable_pair <- function(data, x_var, y_var) {
  if (x_var %in% colnames(data) && y_var %in% colnames(data)) {
    x_data <- data[[x_var]]
    y_data <- data[[y_var]]

    if (!is.numeric(x_data)) {
      stop("SKILL_INVALID_DATA: X variable '", x_var, "' must be numeric")
    }

    if (!is.numeric(y_data)) {
      stop("SKILL_INVALID_DATA: Y variable '", y_var, "' must be numeric")
    }

    return(list(x_data = x_data, y_data = y_data, orientation = "columns"))
  }

  first_column <- data[[1]]
  if (!is.numeric(first_column)) {
    x_matches <- which(first_column == x_var)
    y_matches <- which(first_column == y_var)

    if (length(x_matches) > 1 || length(y_matches) > 1) {
      stop("SKILL_INVALID_DATA: Variable names in the first column must be unique")
    }

    if (length(x_matches) == 1 && length(y_matches) == 1) {
      x_data <- suppressWarnings(as.numeric(unlist(data[x_matches, -1, with = FALSE], use.names = FALSE)))
      y_data <- suppressWarnings(as.numeric(unlist(data[y_matches, -1, with = FALSE], use.names = FALSE)))

      if (all(is.na(x_data))) {
        stop("SKILL_INVALID_DATA: X variable '", x_var, "' could not be parsed as numeric values")
      }

      if (all(is.na(y_data))) {
        stop("SKILL_INVALID_DATA: Y variable '", y_var, "' could not be parsed as numeric values")
      }

      return(list(x_data = x_data, y_data = y_data, orientation = "rows"))
    }
  }

  if (!x_var %in% colnames(data) && !x_var %in% first_column) {
    stop("SKILL_MISSING_COLUMNS: X variable '", x_var, "' not found in data")
  }

  if (!y_var %in% colnames(data) && !y_var %in% first_column) {
    stop("SKILL_MISSING_COLUMNS: Y variable '", y_var, "' not found in data")
  }

  stop("SKILL_INVALID_DATA: X and Y variables must both be provided as column names or as first-column row labels")
}

prepare_complete_cases <- function(data, x_var, y_var) {
  variable_pair <- resolve_variable_pair(data, x_var, y_var)
  complete_cases <- complete.cases(variable_pair$x_data, variable_pair$y_data)
  x_complete <- variable_pair$x_data[complete_cases]
  y_complete <- variable_pair$y_data[complete_cases]

  if (length(x_complete) < 3) {
    stop("SKILL_INSUFFICIENT_DATA: Insufficient complete observations for correlation analysis. Need at least 3 pairs, found: ", length(x_complete))
  }

  return(list(
    x_complete = x_complete,
    y_complete = y_complete,
    orientation = variable_pair$orientation
  ))
}

perform_pearson_correlation <- function(data, x_var, y_var, alternative, conf_level) {
  log_info("Performing Pearson correlation analysis...\n")
  log_info("X variable:", x_var, "\n")
  log_info("Y variable:", y_var, "\n")
  log_info("Alternative hypothesis:", alternative, "\n")
  log_info("Confidence level:", conf_level, "\n")

  analysis_data <- prepare_complete_cases(data, x_var, y_var)
  x_complete <- analysis_data$x_complete
  y_complete <- analysis_data$y_complete

  log_info("Detected variable orientation:", analysis_data$orientation, "\n")
  log_info("Complete observation pairs:", length(x_complete), "\n")
  log_info("X variable - Mean:", mean(x_complete), ", SD:", sd(x_complete), "\n")
  log_info("Y variable - Mean:", mean(y_complete), ", SD:", sd(y_complete), "\n")
  
  result <- cor.test(x_complete, y_complete, 
                     method = "pearson",
                     alternative = alternative,
                     conf.level = conf_level,
                     exact = FALSE)
  
  return(result)
}

perform_spearman_correlation <- function(data, x_var, y_var, alternative, conf_level) {
  log_info("Performing Spearman rank correlation analysis...\n")
  log_info("X variable:", x_var, "\n")
  log_info("Y variable:", y_var, "\n")
  log_info("Alternative hypothesis:", alternative, "\n")
  log_info("Confidence level:", conf_level, "\n")

  analysis_data <- prepare_complete_cases(data, x_var, y_var)
  x_complete <- analysis_data$x_complete
  y_complete <- analysis_data$y_complete

  log_info("Detected variable orientation:", analysis_data$orientation, "\n")
  log_info("Complete observation pairs:", length(x_complete), "\n")
  
  result <- cor.test(x_complete, y_complete, 
                     method = "spearman",
                     alternative = alternative,
                     conf.level = conf_level,
                     exact = FALSE,
                     continuity = FALSE)
  
  return(result)
}
