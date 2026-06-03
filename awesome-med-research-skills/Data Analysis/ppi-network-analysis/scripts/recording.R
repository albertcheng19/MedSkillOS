write_session_info <- function(output_dir) {
  target <- file.path(output_dir, "session_info.txt")
  writeLines(capture.output(sessionInfo()), target)
  invisible(target)
}
