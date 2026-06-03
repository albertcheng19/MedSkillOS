strip_utf8_bom <- function(text) {
  sub(paste0("^", intToUtf8(65279L)), "", text)
}

read_csv_header_fields <- function(input_file) {
  header_line <- readLines(input_file, n = 1L, warn = FALSE, encoding = "UTF-8")
  if (length(header_line) < 1L) {
    stop(sprintf("SKILL_EMPTY_FILE: File is empty: %s", input_file))
  }
  strsplit(strip_utf8_bom(header_line), ",", fixed = TRUE)[[1]]
}

validate_matrix_sample_names <- function(sample_names) {
  if (any(is.na(sample_names) | !nzchar(trimws(sample_names)))) {
    stop("SKILL_INVALID_DATA: Missing sample IDs detected in expression matrix header")
  }
  duplicated_names <- unique(sample_names[duplicated(sample_names)])
  if (length(duplicated_names) > 0L) {
    stop(sprintf(
      "SKILL_INVALID_DATA: Duplicate sample IDs detected in expression matrix header: %s",
      paste(duplicated_names, collapse = ", ")
    ))
  }
}

build_strata_labels <- function(group_data, group_column) {
  as.character(group_data[[group_column]])
}

prepare_group_data <- function(group_data, sample_column, group_column, matrix_samples) {
  missing_columns <- setdiff(c(sample_column, group_column), colnames(group_data))
  if (length(missing_columns) > 0) {
    stop(sprintf("SKILL_MISSING_COLUMNS: Missing group column(s): %s",
                 paste(missing_columns, collapse = ", ")))
  }
  if (any(is.na(group_data[[sample_column]]) | !nzchar(trimws(group_data[[sample_column]])))) {
    stop("SKILL_INVALID_DATA: Missing sample IDs detected in group file")
  }
  if (any(is.na(group_data[[group_column]]) | !nzchar(trimws(group_data[[group_column]])))) {
    stop("SKILL_INVALID_DATA: Missing group values detected in group file")
  }
  if (anyDuplicated(group_data[[sample_column]]) > 0) {
    stop("SKILL_INVALID_DATA: Duplicate sample IDs detected in group file")
  }
  missing_samples <- setdiff(group_data[[sample_column]], matrix_samples)
  if (length(missing_samples) > 0) {
    stop(sprintf("SKILL_SAMPLE_MISMATCH: Samples missing from expression matrix: %s",
                 paste(head(missing_samples, 10), collapse = ", ")))
  }
  ordered <- group_data[match(matrix_samples, group_data[[sample_column]]), , drop = FALSE]
  if (any(is.na(ordered[[sample_column]]))) {
    stop("SKILL_SAMPLE_MISMATCH: Group file does not cover every matrix sample")
  }
  ordered$stratum <- build_strata_labels(ordered, group_column)
  ordered
}

normalize_sample_column <- function(column_data) {
  if (is.numeric(column_data)) {
    return(as.numeric(column_data))
  }
  if (is.logical(column_data) && all(is.na(column_data))) {
    return(rep(NA_real_, length(column_data)))
  }
  parsed <- suppressWarnings(as.numeric(as.character(column_data)))
  invalid_values <- !is.na(column_data) & is.na(parsed)
  if (any(invalid_values)) {
    stop("SKILL_INVALID_DATA: All sample columns in the expression matrix must be numeric")
  }
  parsed
}

load_expression_data <- function(input_file) {
  header_fields <- read_csv_header_fields(input_file)
  if (length(header_fields) < 3L) {
    stop("SKILL_INVALID_DATA: Expression matrix must contain one feature column and at least two samples")
  }
  feature_column <- header_fields[1]
  sample_names <- header_fields[-1]
  validate_matrix_sample_names(sample_names)

  expression_df <- data.table::fread(
    input_file,
    data.table = FALSE,
    check.names = FALSE,
    na.strings = c("", "NA", "NaN")
  )
  if (ncol(expression_df) != length(header_fields)) {
    stop("SKILL_INVALID_DATA: Expression matrix header could not be parsed consistently")
  }
  colnames(expression_df) <- c(feature_column, sample_names)
  if (ncol(expression_df) < 3L) {
    stop("SKILL_INVALID_DATA: Expression matrix must contain one feature column and at least two samples")
  }
  sample_df <- expression_df[-1]
  sample_df[] <- lapply(sample_df, normalize_sample_column)
  feature_ids <- as.character(expression_df[[1]])
  if (anyDuplicated(feature_ids) > 0) {
    stop("SKILL_INVALID_DATA: Duplicate feature IDs detected in expression matrix")
  }
  value_matrix <- as.matrix(sample_df)
  storage.mode(value_matrix) <- "double"
  rownames(value_matrix) <- feature_ids
  list(feature_column = feature_column, feature_ids = feature_ids,
       sample_names = sample_names, matrix = value_matrix)
}
