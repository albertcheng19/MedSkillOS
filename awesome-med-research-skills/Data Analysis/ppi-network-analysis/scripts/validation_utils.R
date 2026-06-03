require_positive_number <- function(value, label, integer_only = FALSE) {
  if (is.null(value) || length(value) != 1 || is.na(value) || !is.finite(value) || value <= 0) {
    fail("SKILL_INVALID_PARAMETER", sprintf("%s must be a positive number.", label))
  }
  if (integer_only && value != as.integer(value)) fail("SKILL_INVALID_PARAMETER", sprintf("%s must be an integer.", label))
  invisible(TRUE)
}

require_probability <- function(value, label) {
  if (is.null(value) || length(value) != 1 || is.na(value) || value < 0 || value > 1) {
    fail("SKILL_INVALID_PARAMETER", sprintf("%s must be between 0 and 1.", label))
  }
  invisible(TRUE)
}

require_threshold_range <- function(value, label, low = 400, high = 1000) {
  if (is.null(value) || length(value) != 1 || is.na(value) || value < low || value > high) {
    fail("SKILL_INVALID_PARAMETER", sprintf("%s must be between %d and %d.", label, low, high))
  }
  invisible(TRUE)
}

require_choice <- function(value, label, allowed) {
  normalized <- tolower(trimws(as.character(value)))
  if (length(normalized) != 1 || is.na(normalized) || !normalized %in% allowed) {
    fail("SKILL_INVALID_PARAMETER", sprintf("%s must be one of: %s", label, paste(allowed, collapse = ", ")))
  }
  normalized
}
