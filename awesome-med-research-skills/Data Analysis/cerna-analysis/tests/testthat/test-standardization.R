library(testthat)

build_main_opt <- function(output_dir, key_genes = file.path(project_root, "tests", "data", "gene.txt")) {
  list(
    key_genes = key_genes,
    output_dir = output_dir,
    reference_dir = file.path(project_root, "references", "database"),
    mirna_dataset = "combined",
    lncrna_strictness = "High",
    lncrna_freq_thresh = 0,
    plot_width = 12,
    plot_height = 8,
    layout_type = "kk",
    mrna_color = "#D16BA5",
    lncrna_color = "#008dcd",
    mirna_color = "#00c9a7",
    node_size_base = 15,
    label_size = 0.8,
    show_legend = TRUE,
    timeout_seconds = 120,
    seed = 42
  )
}

test_that("missing key gene files are rejected", {
  expect_error(parse_key_genes_input(file.path(project_root, "tests", "data", "missing_gene_list.txt")), "SKILL_FILE_NOT_FOUND")
})

test_that("duplicate key genes are cleaned", {
  key_file <- tempfile(fileext = ".txt")
  writeLines(c("TP53", "TP53", "# note", "MYC", ""), key_file)
  expect_equal(parse_key_genes_input(key_file), c("TP53", "MYC"))
})

test_that("timeout wrapper converts elapsed limit errors", {
  expect_error(run_with_timeout(function() stop("reached elapsed time limit", call. = FALSE), 1, "test"), "SKILL_TIMEOUT")
})

test_that("reference validation only requires files for the selected dataset", {
  source_dir <- file.path(project_root, "references", "database")
  temp_ref_dir <- tempfile(pattern = "cerna-ref-")
  dir.create(temp_ref_dir)

  required_for_combined <- c("miRNA_mRNA.csv", "starbase_miRNA_lncRNA_High.csv")
  copied_files <- file.copy(file.path(source_dir, required_for_combined), file.path(temp_ref_dir, required_for_combined))
  expect_true(all(copied_files))

  expect_error(validate_reference_files(temp_ref_dir, "combined", "High"), NA)
  expect_error(validate_reference_files(temp_ref_dir, "starbase", "High"), "SKILL_FILE_NOT_FOUND")
})

test_that("lncrna frequency threshold is inclusive", {
  input_table <- data.frame(miRNA = c("miR-1", "miR-2", "miR-3"), lncRNA = c("LNC1", "LNC1", "LNC2"), stringsAsFactors = FALSE)
  result <- filter_mirna_lncrna_pairs(input_table, c("miR-1", "miR-2", "miR-3"), 2)
  expect_equal(unique(result$lncRNA), "LNC1")
})

test_that("main CLI supports help mode", {
  rscript <- file.path(R.home("bin"), "Rscript")
  main_help <- system2(rscript, c(file.path(project_root, "scripts", "main.R"), "--help"), stdout = TRUE, stderr = TRUE)
  expect_true(any(grepl("ceRNA Network Analysis", main_help, fixed = TRUE)))
})

test_that("main CLI rejects missing key gene files with a clear error", {
  rscript <- file.path(R.home("bin"), "Rscript")
  output_dir <- tempfile(pattern = "cerna-missing-")
  result <- suppressWarnings(system2(
    rscript,
    c(file.path(project_root, "scripts", "main.R"), "-i", file.path(project_root, "tests", "data", "missing_gene_list.txt"), "-o", output_dir, "-t", "120"),
    stdout = TRUE,
    stderr = TRUE
  ))
  expect_identical(attr(result, "status"), 1L)
  expect_true(any(grepl("SKILL_FILE_NOT_FOUND", result, fixed = TRUE)))
  expect_false(dir.exists(output_dir))
})

test_that("analysis workflow writes only the expected flat outputs", {
  skip_if_not_installed("igraph")
  output_dir <- tempfile(pattern = "cerna-test-")
  dir.create(output_dir, recursive = TRUE)

  expect_error(run_cerna_analysis(build_main_opt(output_dir)), NA)
  write_session_info(output_dir)

  expect_true(file.exists(file.path(output_dir, "session_info.txt")))
  expect_true(file.exists(file.path(output_dir, "ceRNA_network_edges.csv")))
  expect_true(file.exists(file.path(output_dir, "ceRNA_network_nodes.csv")))
  expect_true(file.exists(file.path(output_dir, "ceRNA_network.pdf")))
  expect_false(file.exists(file.path(output_dir, "analysis.log")))
  expect_false(file.exists(file.path(output_dir, "ceRNA_stats.txt")))
  expect_false(dir.exists(file.path(output_dir, "data")))
  expect_false(dir.exists(file.path(output_dir, "plot")))
  expect_false(dir.exists(file.path(output_dir, "table")))

  generated_edges <- read.csv(file.path(output_dir, "ceRNA_network_edges.csv"), stringsAsFactors = FALSE)
  generated_nodes <- read.csv(file.path(output_dir, "ceRNA_network_nodes.csv"), stringsAsFactors = FALSE)
  expected_files <- c("ceRNA_network_edges.csv", "ceRNA_network_nodes.csv", "ceRNA_network.pdf", "session_info.txt")

  expect_setequal(list.files(output_dir), expected_files)
  expect_equal(colnames(generated_edges), c("node1", "node2"))
  expect_equal(colnames(generated_nodes), c("node", "type", "degree"))
  expect_gt(nrow(generated_edges), 0)
  expect_gt(nrow(generated_nodes), 0)
  expect_equal(nrow(unique(generated_edges)), nrow(generated_edges))
  expect_equal(nrow(unique(generated_nodes)), nrow(generated_nodes))
  expect_true(all(generated_nodes$type %in% c("miRNA", "mRNA", "lncRNA")))
  expect_true(all(generated_nodes$degree >= 0))
  expect_true(all(generated_nodes$degree == as.integer(generated_nodes$degree)))

  edge_nodes <- sort(unique(c(generated_edges$node1, generated_edges$node2)))
  expect_equal(edge_nodes, sort(generated_nodes$node))

  graph <- igraph::graph_from_data_frame(generated_edges, directed = FALSE)
  expect_equal(unname(igraph::degree(graph)[generated_nodes$node]), generated_nodes$degree)

  key_genes <- parse_key_genes_input(build_main_opt(output_dir)$key_genes)
  expect_true(all(generated_nodes$node[generated_nodes$type == "mRNA"] %in% key_genes))
  expect_true(any(generated_nodes$type == "miRNA"))
  expect_true(any(generated_nodes$type == "mRNA"))
  expect_true(any(generated_nodes$type == "lncRNA"))
  expect_true(all(generated_edges$node1 %in% generated_nodes$node[generated_nodes$type == "miRNA"]))
  expect_true(all(generated_edges$node2 %in% generated_nodes$node[generated_nodes$type != "miRNA"]))

})

test_that("analysis rejects runs where the ceRNA layer collapses", {
  skip_if_not_installed("igraph")
  output_dir <- tempfile(pattern = "cerna-no-lncrna-")
  opt <- build_main_opt(output_dir)
  opt$lncrna_freq_thresh <- 1000

  expect_error(
    run_cerna_analysis(opt),
    "SKILL_INVALID_DATA: No miRNA-lncRNA interactions remained after filtering; the ceRNA layer collapsed"
  )
  expect_false(dir.exists(output_dir))
})
