#!/usr/bin/env Rscript

required_packages <- c(
  optparse = "1.7.5",
  data.table = "1.15.4",
  Rtsne = "0.17",
  umap = "0.2.10.0",
  ggplot2 = "3.4.0",
  vegan = "2.7.3"
)

optional_packages <- c(R.utils = "2.13.0")
dev_packages <- c(testthat = "3.1.2")

install_if_missing <- function(package_versions, repos = "https://cloud.r-project.org") {
  packages <- names(package_versions)
  missing <- packages[!vapply(packages, requireNamespace, logical(1), quietly = TRUE)]
  if (length(missing) == 0) {
    message("All requested packages are already installed.")
    return(invisible(character(0)))
  }

  message("Installing missing packages: ", paste(missing, collapse = ", "))
  install.packages(missing, repos = repos)

  missing_after_install <- missing[
    !vapply(missing, requireNamespace, logical(1), quietly = TRUE)
  ]
  if (length(missing_after_install) > 0) {
    stop(
      paste(
        "SKILL_PACKAGE_NOT_FOUND:",
        paste(missing_after_install, collapse = ", "),
        "| Install failed; check CRAN/network access and rerun this script."
      )
    )
  }

  invisible(missing)
}

report_version_baseline <- function(package_versions, label) {
  message("Validated ", label, " package baseline:")

  for (pkg in names(package_versions)) {
    expected <- package_versions[[pkg]]
    if (!requireNamespace(pkg, quietly = TRUE)) {
      message("  - ", pkg, " (expected ", expected, "): not installed")
      next
    }

    actual <- as.character(packageVersion(pkg))
    status <- if (identical(actual, expected)) "matched" else "detected"
    message("  - ", pkg, " ", actual, " [", status, "; tested baseline ", expected, "]")
  }
}

message("Installing core dependencies for umap-tsne-analysis...")
installed_core <- install_if_missing(required_packages)
report_version_baseline(required_packages, "core")

message("Checking optional timeout dependency (R.utils)...")
installed_optional <- install_if_missing(optional_packages)
report_version_baseline(optional_packages, "optional")

message("Checking development test dependency (testthat)...")
installed_dev <- install_if_missing(dev_packages)
report_version_baseline(dev_packages, "development")

message("Dependency setup complete.")
message("Tested dependency baseline is recorded in dependencies.lock.tsv.")
message(
  "Core packages installed this run: ",
  if (length(installed_core) == 0) "none" else paste(installed_core, collapse = ", ")
)
message(
  "Optional packages installed this run: ",
  if (length(installed_optional) == 0) "none" else paste(installed_optional, collapse = ", ")
)
message(
  "Development packages installed this run: ",
  if (length(installed_dev) == 0) "none" else paste(installed_dev, collapse = ", ")
)
