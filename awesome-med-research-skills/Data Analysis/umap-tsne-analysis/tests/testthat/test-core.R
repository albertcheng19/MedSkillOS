root_dir <- Sys.getenv("UMAP_TSNE_ROOT")
if (!nzchar(root_dir)) {
  stop("TEST_FAILED: UMAP_TSNE_ROOT is not set")
}

source(file.path(root_dir, "scripts", "utils.R"))
source(file.path(root_dir, "scripts", "dim_reduction_methods.R"))
source(file.path(root_dir, "scripts", "visualization.R"))

testthat::test_that("validate_groups rejects a single-group input", {
  group_df <- data.frame(
    SampleID = c("S1", "S2", "S3"),
    Group = factor(c("Only", "Only", "Only"))
  )

  testthat::expect_error(
    validate_groups(group_df, group_col = "Group"),
    "At least 2 groups are required"
  )
})

testthat::test_that("align_and_prepare_matrix reorders samples and drops zero rows", {
  mat_df <- data.frame(
    Feature = c("OTU_1", "OTU_2"),
    S2 = c(2, 2),
    S1 = c(1, 0),
    S3 = c(0, 0),
    check.names = FALSE
  )

  group_df <- data.frame(
    SampleID = c("S1", "S2", "S3"),
    Group = factor(c("A", "A", "B"))
  )

  prepared <- align_and_prepare_matrix(mat_df, group_df)

  testthat::expect_equal(rownames(prepared$mat), c("S1", "S2"))
  testthat::expect_equal(group_df$SampleID[1:2], c("S1", "S2"))
  testthat::expect_equal(prepared$group_df$SampleID, c("S1", "S2"))
  testthat::expect_equal(unname(prepared$mat["S2", ]), c(2, 2))
})

testthat::test_that("run_tsne rejects oversized perplexity before calling Rtsne", {
  otu <- matrix(seq_len(12), nrow = 4)
  rownames(otu) <- paste0("S", seq_len(4))

  sample_info <- data.frame(
    SampleID = rownames(otu),
    Group = factor(c("A", "A", "B", "B"))
  )

  testthat::expect_error(
    run_tsne(
      otu = otu,
      sample_info = sample_info,
      sample_id_col = "SampleID",
      group_col = "Group",
      perplexity = 2
    ),
    "perplexity is too large"
  )
})

testthat::test_that("plot_dim skips ellipses for undersized groups without raw warnings", {
  set.seed(42)
  df <- data.frame(
    X1 = rnorm(7),
    X2 = rnorm(7),
    Group = factor(c("A", "A", "A", "B", "B", "B", "C"))
  )

  plot_log <- capture.output({
    plot_obj <- plot_dim(
      df = df,
      group_col = "Group",
      colors = c("#1597A5", "#FFC24B", "#FEB3AE")
    )
  })

  output_file <- tempfile(fileext = ".pdf")
  save_log <- capture.output(save_plot_pdf(plot_obj, output_file))
  combined_log <- paste(c(plot_log, save_log), collapse = "\n")

  testthat::expect_true(file.exists(output_file))
  testthat::expect_match(combined_log, "Skipping group ellipses", fixed = TRUE)
  testthat::expect_false(grepl("Too few points to calculate an ellipse", combined_log, fixed = TRUE))
})
