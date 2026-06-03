resolve_species_meta <- function(species_input) {
  normalized <- tolower(trimws(as.character(species_input)))
  if (normalized %in% c("human", "homo sapiens", "9606")) return(list(species = "human", species_id = "9606", species_latin = "Homo sapiens"))
  if (normalized %in% c("mouse", "mus musculus", "10090")) return(list(species = "mouse", species_id = "10090", species_latin = "Mus musculus"))
  fail("SKILL_INVALID_PARAMETER", "--species must be one of: human, mouse, 9606, or 10090.")
}

parse_version_num <- function(version_text) {
  text <- sub("^v", "", basename(as.character(version_text)))
  pieces <- strsplit(text, "\\.")[[1]]
  values <- suppressWarnings(as.numeric(pieces))
  if (length(values) < 2 || any(is.na(values[1:2]))) return(c(-Inf, -Inf))
  values[1:2]
}

find_cache_file <- function(cache_dir, species_id, stem, preferred_version = "auto") {
  pattern <- paste0("^", species_id, "\\.protein\\.", stem, "\\.v[0-9]+\\.[0-9]+\\.txt\\.gz$")
  files <- list.files(cache_dir, pattern = pattern, full.names = TRUE)
  if (length(files) == 0) return(NULL)
  versions <- sub(paste0("^", species_id, "\\.protein\\.", stem, "\\."), "", basename(files))
  versions <- sub("\\.txt\\.gz$", "", versions)
  if (tolower(preferred_version) != "auto") {
    hit <- files[tolower(versions) == tolower(preferred_version)]
    return(if (length(hit) > 0) hit[1] else NULL)
  }
  version_mat <- t(vapply(versions, parse_version_num, numeric(2)))
  files[order(version_mat[, 1], version_mat[, 2], decreasing = TRUE)][1]
}

resolve_string_cache_files <- function(species_meta, cache_dir, preferred_version = "auto") {
  aliases_file <- find_cache_file(cache_dir, species_meta$species_id, "aliases", preferred_version)
  info_file <- find_cache_file(cache_dir, species_meta$species_id, "info", preferred_version)
  links_file <- find_cache_file(cache_dir, species_meta$species_id, "links", preferred_version)
  if (is.null(aliases_file) || is.null(info_file) || is.null(links_file)) {
    fail("SKILL_FILE_NOT_FOUND", sprintf("STRING cache files are missing for species %s in %s", species_meta$species_id, cache_dir))
  }
  version_text <- sub(paste0("^", species_meta$species_id, "\\.protein\\.aliases\\."), "", basename(aliases_file))
  version_text <- sub("\\.txt\\.gz$", "", version_text)
  list(aliases = aliases_file, info = info_file, links = links_file, version = version_text)
}

read_string_table <- function(file_path, sep = "\t", table_name) {
  if (!file.exists(file_path)) fail("SKILL_FILE_NOT_FOUND", sprintf("Missing STRING %s file: %s", table_name, file_path))
  table_df <- tryCatch(utils::read.delim(file_path, header = TRUE, sep = sep, stringsAsFactors = FALSE, check.names = FALSE, quote = "", comment.char = ""), error = function(e) NULL)
  if (is.null(table_df) || ncol(table_df) == 0) fail("SKILL_EMPTY_DATA", sprintf("Failed to parse STRING %s file: %s", table_name, file_path))
  colnames(table_df) <- trimws(colnames(table_df))
  table_df
}

map_genes_to_string_local <- function(genes, alias_file, info_file) {
  aliases <- read_string_table(alias_file, sep = "\t", table_name = "aliases")
  info <- read_string_table(info_file, sep = "\t", table_name = "info")
  alias_id_col <- detect_first_existing_col(aliases, c("protein_external_id", "#string_protein_id", "string_protein_id", "STRING_id", "protein_id"), "aliases")
  alias_symbol_col <- detect_first_existing_col(aliases, c("alias", "symbol", "gene", "preferred_name"), "aliases")
  info_id_col <- detect_first_existing_col(info, c("protein_external_id", "#string_protein_id", "string_protein_id", "STRING_id", "protein_id"), "info")

  alias_map <- dplyr::transmute(aliases, STRING_id = as.character(.data[[alias_id_col]]), alias_symbol = as.character(.data[[alias_symbol_col]]), alias_upper = toupper(trimws(alias_symbol)))
  alias_map <- dplyr::filter(alias_map, !is.na(STRING_id), !is.na(alias_symbol), nzchar(alias_symbol))
  genes_df <- data.frame(gene = genes, gene_upper = toupper(trimws(genes)), stringsAsFactors = FALSE)
  mapped <- dplyr::left_join(genes_df, alias_map, by = c("gene_upper" = "alias_upper"))
  mapped <- dplyr::filter(mapped, !is.na(STRING_id))
  mapped <- dplyr::distinct(mapped, gene, .keep_all = TRUE)
  keep_cols <- intersect(c(info_id_col, "preferred_name", "annotation", "protein_size"), colnames(info))
  mapped <- dplyr::left_join(mapped, dplyr::select(info, dplyr::all_of(keep_cols)), by = setNames(info_id_col, "STRING_id"))
  mapped
}

get_interactions_local <- function(string_ids, links_file, threshold) {
  links <- read_string_table(links_file, sep = " ", table_name = "links")
  from_col <- detect_first_existing_col(links, c("protein1", "from", "node1"), "links")
  to_col <- detect_first_existing_col(links, c("protein2", "to", "node2"), "links")
  score_col <- detect_first_existing_col(links, c("combined_score", "score"), "links")
  edges <- dplyr::transmute(links, from = as.character(.data[[from_col]]), to = as.character(.data[[to_col]]), combined_score = as.numeric(.data[[score_col]]))
  dplyr::filter(edges, from %in% string_ids, to %in% string_ids, combined_score >= threshold)
}
