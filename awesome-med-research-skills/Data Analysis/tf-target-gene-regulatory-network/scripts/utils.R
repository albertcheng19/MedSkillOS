# Utility functions for TF Regulatory Network Analysis

log_msg <- function(level, msg) {
  timestamp <- format(Sys.time(), "%Y-%m-%d %H:%M:%S")
  cat(paste0("[", timestamp, "] ", toupper(level), ": ", msg, "\n"))
}

log_info <- function(msg) log_msg("info", msg)
log_error <- function(msg) log_msg("error", msg)
log_warn <- function(msg) log_msg("warn", msg)

#' Check package dependency
#'
#' @param pkg Package name (character)
#' @param min_ver Minimum required version (optional, character)
#' 
#' @return Loads the package into namespace, invisibly returns TRUE
#' @throws SKILL_DEPENDENCY_MISSING if package not installed
#' @throws SKILL_PKG_VERSION if package version below minimum
#' 
#' @examples
#' check_pkg("dplyr")
#' check_pkg("ggplot2", "3.4.0")
check_pkg <- function(pkg, min_ver = NULL) {
  if (!requireNamespace(pkg, quietly = TRUE))
    stop(paste("SKILL_DEPENDENCY_MISSING:", pkg))
  library(pkg, character.only = TRUE, warn.conflicts = FALSE)
  if (!is.null(min_ver) && packageVersion(pkg) < min_ver)
    stop(paste("SKILL_PKG_VERSION:", pkg, "needs >=", min_ver))
}

#' Check if file exists
#'
#' @param file_path Path to file (character)
#' @param file_desc Description of file for error message (character, default: "File")
#' 
#' @return TRUE invisibly if file exists
#' @throws SKILL_FILE_NOT_FOUND if file does not exist
#' 
#' @examples
#' check_file_exists("data/genes.txt")
#' check_file_exists("results/output.csv", "Output file")
check_file_exists <- function(file_path, file_desc = "File") {
  if (!file.exists(file_path))
    stop(paste("SKILL_FILE_NOT_FOUND:", file_desc, "does not exist:", file_path))
  invisible(TRUE)
}

#' Validate input genes
#'
#' @param gene_list Character vector of gene symbols
#' 
#' @return Unique, non-empty gene symbols (character vector)
#' @throws SKILL_NO_INPUT_GENES if no valid genes provided
#' 
#' @examples
#' validate_genes(c("TP53", "MYC", "EGFR"))
#' validate_genes(c("TP53", "", NA, "MYC"))  # Returns c("TP53", "MYC")
validate_genes <- function(gene_list) {
  gene_list <- unique(gene_list[gene_list != "" & !is.na(gene_list)])
  if (length(gene_list) == 0)
    stop("SKILL_NO_INPUT_GENES: No valid input genes provided")
  gene_list
}

#' Validate species parameter
#'
#' @param species Species identifier (character)
#' 
#' @return Standardized species code: "human" or "mouse"
#' @throws SKILL_INVALID_SPECIES if species not recognized
#' 
#' @examples
#' validate_species("human")   # returns "human"
#' validate_species("HUMAN")   # returns "human"
#' validate_species("hs")      # returns "human"
#' validate_species("mouse")   # returns "mouse"
validate_species <- function(species) {
  species_choice <- tolower(trimws(species))
  valid_species <- c("human", "hs", "mouse", "mm")
  if (!species_choice %in% valid_species)
    stop("SKILL_INVALID_SPECIES: Species must be 'human' or 'mouse'")
  species_choice
}

#' Parse gene input from command line arguments
#'
#' Accepts gene input from either command-line string or file, or both.
#' Supports CSV, TSV, and plain text files with comma/space/tab/newline separated genes.
#'
#' @param gene_cmd Comma-separated gene string from command line (character or NULL)
#' @param gene_file Path to gene file (character or NULL)
#' 
#' @return Validated list of unique gene symbols (character vector)
#' @throws SKILL_FILE_NOT_FOUND if gene file doesn't exist and no command-line genes
#' @throws SKILL_NO_INPUT_GENES if no valid genes provided after parsing
#' 
#' @examples
#' parse_gene_input("TP53,MYC,EGFR", NULL)
#' parse_gene_input(NULL, "genes.txt")
#' parse_gene_input("TP53", "additional_genes.csv")
parse_gene_input <- function(gene_cmd, gene_file) {
  gene_list <- c()
  
  if (!is.null(gene_cmd)) {
    genes_cmd <- strsplit(gene_cmd, ",")[[1]] %>% trimws()
    gene_list <- c(gene_list, genes_cmd)
  }
  
  if (!is.null(gene_file)) {
    if (!file.exists(gene_file)) {
      if (length(gene_list) == 0) {
        stop("SKILL_FILE_NOT_FOUND: Gene file does not exist and no command-line genes provided")
      } else {
        log_warn(paste("Gene file not found:", gene_file, "- using command-line genes only"))
      }
    } else {
      tryCatch({
        file_ext <- tolower(tools::file_ext(gene_file))
        if (file_ext == "csv") {
          genes_file <- read.csv(gene_file, header = FALSE, stringsAsFactors = FALSE)
        } else {
          genes_file <- read.table(gene_file, header = FALSE, stringsAsFactors = FALSE, sep = "\t")
        }
        genes_from_file <- as.character(unlist(genes_file))
        genes_from_file <- unlist(strsplit(genes_from_file, "[,\\s]+")) %>% trimws()
        gene_list <- c(gene_list, genes_from_file)
      }, error = function(e) {
        log_warn(paste("Failed to parse gene file:", e$message))
      })
    }
  }
  
  validate_genes(gene_list)
}

#' Create output directory structure
#'
#' Creates standardized output directory structure: data/, plot/, table/
#' Changes working directory to the output directory.
#'
#' @param output_dir Output directory path (character)
#' 
#' @return Absolute path to output directory (character)
#' 
#' @examples
#' create_output_dirs("./results")
#' create_output_dirs("TF_Result")
create_output_dirs <- function(output_dir) {
  dir.create(output_dir, showWarnings = FALSE, recursive = TRUE)
  abs_output_path <- normalizePath(output_dir)
  setwd(abs_output_path)
  dir.create("data", showWarnings = FALSE)
  dir.create("plot", showWarnings = FALSE)
  dir.create("table", showWarnings = FALSE)
  log_info(paste("Output directory:", abs_output_path))
  abs_output_path
}

#' Save session info for reproducibility
#'
#' Saves R session information to file for reproducibility tracking.
#'
#' @param output_dir Output directory path (character)
#' 
#' @return Invisibly returns path to session info file
#' 
#' @examples
#' save_session_info("./results")
save_session_info <- function(output_dir) {
  session_file <- file.path(output_dir, "session_info.txt")
  writeLines(capture.output(sessionInfo()), session_file)
  log_info(paste("Session info saved to:", session_file))
  invisible(session_file)
}

# Load Dorothea database with local priority
load_dorothea_database <- function(species_key, db_path = NULL, script_dir = ".") {
  default_db_name <- paste0("dorothea_", species_key, ".rds")
  
  # Priority search for local database
  potential_paths <- c(
    db_path,
    file.path(getwd(), "database", default_db_name),
    file.path(script_dir, "database", default_db_name),
    file.path(dirname(script_dir), "database", default_db_name)
  )
  
  db_file <- NULL
  for (path in potential_paths) {
    if (!is.null(path) && file.exists(path)) {
      db_file <- path
      break
    }
  }
  
  if (!is.null(db_file)) {
    log_info(paste("Using local database:", db_file))
    dt_data <- readRDS(db_file)
  } else {
    log_warn("Local database not found, attempting to load from Dorothea package...")
    
    # Check if dorothea package is available
    if (!requireNamespace("dorothea", quietly = TRUE)) {
      stop(paste(
        "SKILL_DEPENDENCY_MISSING: Local database file not found and dorothea package not installed.",
        "Solution:",
        "1. Install dorothea package:",
        "   if (!require('BiocManager', quietly = TRUE)) install.packages('BiocManager')",
        "   BiocManager::install('dorothea')",
        "2. Or generate local database files:",
        "   Rscript database/database-get.R",
        sep = "\n"
      ))
    }
    
    log_info("Dorothea package found, loading database...")
    if (species_key == "hs") {
      data(dorothea_hs, package = "dorothea")
      dt_data <- dorothea_hs
    } else {
      data(dorothea_mm, package = "dorothea")
      dt_data <- dorothea_mm
    }
  }
  
  dt_data
}