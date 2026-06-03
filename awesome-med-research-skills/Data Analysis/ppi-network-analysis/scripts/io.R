read_delimited_table <- function(file_path) {
  if (grepl("\\.csv$", file_path, ignore.case = TRUE)) {
    utils::read.csv(file_path, header = TRUE, stringsAsFactors = FALSE, check.names = FALSE)
  } else if (grepl("\\.(tsv|txt)$", file_path, ignore.case = TRUE)) {
    utils::read.table(file_path, header = TRUE, sep = "\t", stringsAsFactors = FALSE, check.names = FALSE, quote = "\"", comment.char = "")
  } else {
    fail("SKILL_INVALID_PARAMETER", sprintf("Unsupported tabular extension: %s", file_path))
  }
}

pick_gene_column <- function(df) {
  normalized_names <- tolower(gsub("[^a-z0-9]+", "", colnames(df)))
  candidates <- c("gene", "genes", "genename", "genesymbol", "symbol", "hgnc", "hgncsymbol", "mgi", "ensembl", "ensemblgeneid", "geneid", "id")
  hit <- which(normalized_names %in% candidates)
  if (length(hit) > 0) return(hit[1])
  score <- vapply(df, function(column) {
    values <- as.character(column)
    values <- values[!is.na(values) & nzchar(trimws(values))]
    if (length(values) == 0) return(0)
    mean(!grepl("^\\d+(\\.\\d+)?$", values))
  }, numeric(1))
  if (all(score == 0)) 1 else which.max(score)
}

split_genes <- function(values) {
  values <- as.character(values)
  values <- values[!is.na(values)]
  values <- trimws(values)
  values <- values[nzchar(values)]
  if (length(values) == 0) return(character(0))
  pieces <- unlist(strsplit(values, "[,;|\\t\\s]+", perl = TRUE), use.names = FALSE)
  pieces <- trimws(pieces)
  pieces[nzchar(pieces)]
}

read_gene_list <- function(genelist_file) {
  extension <- tolower(tools::file_ext(genelist_file))
  genes <- character(0)
  if (extension %in% c("csv", "tsv", "txt")) {
    if (extension == "txt") {
      raw <- readLines(genelist_file, warn = FALSE)
      genes <- split_genes(raw)
      if (length(genes) == 0) {
        table_df <- tryCatch(utils::read.table(genelist_file, header = TRUE, sep = "\t", stringsAsFactors = FALSE, check.names = FALSE, quote = "\"", comment.char = ""), error = function(e) NULL)
        if (!is.null(table_df) && ncol(table_df) > 0) genes <- split_genes(table_df[[pick_gene_column(table_df)]])
      }
    } else {
      table_df <- tryCatch(read_delimited_table(genelist_file), error = function(e) NULL)
      if (!is.null(table_df) && ncol(table_df) > 0) {
        genes <- split_genes(table_df[[pick_gene_column(table_df)]])
      }
      if (length(genes) == 0) genes <- split_genes(readLines(genelist_file, warn = FALSE))
    }
  } else if (extension == "xlsx") {
    table_df <- openxlsx::read.xlsx(genelist_file)
    if (is.null(table_df) || ncol(table_df) == 0) fail("SKILL_EMPTY_DATA", sprintf("Gene list workbook is empty: %s", genelist_file))
    genes <- split_genes(table_df[[pick_gene_column(table_df)]])
  } else {
    fail("SKILL_INVALID_PARAMETER", "Gene list file must be CSV, TSV, TXT, or XLSX.")
  }

  genes <- unique(genes[!is.na(genes) & nzchar(trimws(genes))])
  if (length(genes) == 0) fail("SKILL_EMPTY_DATA", sprintf("No valid genes were parsed from: %s", genelist_file))
  genes
}

detect_first_existing_col <- function(df, candidates, table_name) {
  hit <- candidates[candidates %in% colnames(df)]
  if (length(hit) > 0) return(hit[1])
  fail("SKILL_MISSING_COLUMNS", sprintf("Expected columns not found in %s. Available columns: %s", table_name, paste(colnames(df), collapse = ", ")))
}
