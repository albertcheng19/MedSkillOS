candidate_roots <- unique(c(
  tryCatch(dirname(dirname(dirname(normalizePath(sys.frame(1)$ofile)))), error = function(...) NA_character_),
  normalizePath(getwd(), mustWork = FALSE),
  normalizePath(file.path(getwd(), ".."), mustWork = FALSE),
  normalizePath(file.path(getwd(), "..", ".."), mustWork = FALSE)
))

project_root <- candidate_roots[
  vapply(candidate_roots, function(path) file.exists(file.path(path, "scripts", "utils.R")), logical(1))
][1]

if (is.na(project_root) || !nzchar(project_root)) {
  stop("Unable to locate project root for tests", call. = FALSE)
}

source(file.path(project_root, "scripts", "utils.R"))
source(file.path(project_root, "scripts", "validation.R"))
source(file.path(project_root, "scripts", "functions.R"))
source(file.path(project_root, "scripts", "io.R"))
source(file.path(project_root, "scripts", "plot_functions.R"))
source(file.path(project_root, "scripts", "run_analysis.R"))
