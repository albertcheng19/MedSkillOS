build_core_option_list <- function() {
  list(
    optparse::make_option(c("-g", "--genelist_file"), type = "character", default = NULL,
      help = "Gene list file in CSV, TSV, TXT, or XLSX format [required unless --plot_only TRUE]", metavar = "file"),
    optparse::make_option(c("-s", "--species"), type = "character", default = NULL,
      help = "Species: human, mouse, 9606, or 10090 [required unless --plot_only TRUE]", metavar = "label"),
    optparse::make_option(c("-t", "--threshold"), type = "integer", default = NULL,
      help = "STRING combined-score threshold between 400 and 1000 [required unless --plot_only TRUE]", metavar = "int"),
    optparse::make_option(c("-o", "--output_dir"), type = "character", default = "output",
      help = "Output directory inside the skill root [default %default]", metavar = "dir"),
    optparse::make_option(c("-p", "--plot_only"), type = "logical", default = FALSE,
      help = "Reuse an existing network bundle from output_dir/data/ppi_result.rds and regenerate the plot [default %default]"),
    optparse::make_option(c("-d", "--seed"), type = "integer", default = 42,
      help = "Random seed used for layout reproducibility [default %default]", metavar = "int"),
    optparse::make_option(c("-u", "--timeout_seconds"), type = "integer", default = 600,
      help = "Elapsed time limit in seconds [default %default]", metavar = "int"),
    optparse::make_option("--string_cache_dir", type = "character", default = "",
      help = "Local STRING cache directory; default is references/string_cache inside the skill"),
    optparse::make_option("--string_version", type = "character", default = "auto",
      help = "Preferred STRING cache version; use auto, v11.5, or v12.0 when available [default %default]")
  )
}
