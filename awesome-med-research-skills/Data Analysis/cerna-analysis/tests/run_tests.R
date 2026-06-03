if (!requireNamespace("testthat", quietly = TRUE)) {
  stop("SKILL_DEPENDENCY_MISSING: Package 'testthat' is required. Install with: install.packages('testthat')", call. = FALSE)
}

project_root <- normalizePath(getwd())
testthat::test_dir(file.path(project_root, "tests", "testthat"), reporter = "summary")
