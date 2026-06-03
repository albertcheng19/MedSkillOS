#!/usr/bin/env Rscript

read_simple_table <- function(path) {
  if (!file.exists(path)) {
    stop_skill("SKILL_FILE_NOT_FOUND", sprintf("File not found: %s", path))
  }
  tryCatch(
    utils::read.csv(path, check.names = FALSE, stringsAsFactors = FALSE),
    error = function(e) {
      stop_skill("SKILL_INVALID_DATA", sprintf("Failed to read %s: %s", path, conditionMessage(e)))
    }
  )
}

read_id_list <- function(value, label) {
  items <- parse_optional_list(value)
  if (!length(items)) {
    return(character())
  }
  items <- unique(items[nzchar(items) & items != "NA"])
  if (!length(items)) {
    stop_skill("SKILL_EMPTY_DATA", sprintf("%s is empty after trimming.", label))
  }
  items
}

load_mirna_mrna_db <- function(base_dir, dataset) {
  file_map <- list(
    combined = file.path(base_dir, "miRNA_mRNA.csv"),
    starbase = file.path(base_dir, "starbase_miRNA_mRNA.csv"),
    mirdb = file.path(base_dir, "miRDB_miRNA_mRNA.csv"),
    mirtarbase = file.path(base_dir, "miRTarbase_miRNA_mRNA.csv")
  )

  read_one <- function(name) {
    tbl <- read_simple_table(file_map[[name]])
    validate_required_columns(tbl, c("miRNA", "mRNA"), basename(file_map[[name]]))
    tbl[, c("miRNA", "mRNA")]
  }

  intersect_pairs <- function(left_name, right_name) {
    left <- read_one(left_name)
    right <- read_one(right_name)
    left$key <- paste(left$miRNA, left$mRNA, sep = "|")
    right$key <- paste(right$miRNA, right$mRNA, sep = "|")
    common <- intersect(left$key, right$key)
    if (!length(common)) {
      return(data.frame(miRNA = character(), mRNA = character(), stringsAsFactors = FALSE))
    }
    parts <- strsplit(common, "|", fixed = TRUE)
    data.frame(
      miRNA = vapply(parts, `[`, character(1), 1),
      mRNA = vapply(parts, `[`, character(1), 2),
      stringsAsFactors = FALSE
    )
  }

  if (dataset == "starbase+mirdb") return(intersect_pairs("starbase", "mirdb"))
  if (dataset == "starbase+mirtarbase") return(intersect_pairs("starbase", "mirtarbase"))
  if (dataset == "mirdb+mirtarbase") return(intersect_pairs("mirdb", "mirtarbase"))
  read_one(dataset)
}

load_mirna_lncrna_db <- function(base_dir, strictness) {
  path <- file.path(base_dir, sprintf("starbase_miRNA_lncRNA_%s.csv", strictness))
  tbl <- read_simple_table(path)
  validate_required_columns(tbl, c("miRNA", "lncRNA"), basename(path))
  tbl[, c("miRNA", "lncRNA")]
}

write_session_info <- function(output_dir) {
  capture.output(sessionInfo(), file = file.path(output_dir, "session_info.txt"))
}
