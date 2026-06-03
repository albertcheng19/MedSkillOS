run_tsne <- function(otu, sample_info, sample_id_col = "SampleID", group_col = "Group",
                     dims = 2, perplexity = 25, theta = 0.0, pca = FALSE,
                     check_duplicates = FALSE, seed = 42) {
  set.seed(seed)

  if (!sample_id_col %in% colnames(sample_info)) {
    stop("SKILL_MISSING_COLUMNS: sample_id_col not found in sample_info")
  }
  if (!group_col %in% colnames(sample_info)) {
    stop("SKILL_MISSING_COLUMNS: group_col not found in sample_info")
  }

  n_samples <- nrow(otu)
  if (n_samples < 3) {
    stop("SKILL_INVALID_PARAMETER: t-SNE requires at least 3 samples")
  }
  if (perplexity >= (n_samples - 1) / 3) {
    stop("SKILL_INVALID_PARAMETER: perplexity is too large for the number of samples")
  }

  tsne_res <- Rtsne::Rtsne(
    otu,
    dims = dims,
    perplexity = perplexity,
    theta = theta,
    pca = pca,
    check_duplicates = check_duplicates
  )

  df <- as.data.frame(tsne_res$Y)
  colnames(df) <- c("X1", "X2")
  df$SampleID <- rownames(otu)

  group_df <- sample_info
  group_df$SampleID <- group_df[[sample_id_col]]

  merge(df, group_df, by = "SampleID")
}

run_umap <- function(otu, sample_info, sample_id_col = "SampleID", group_col = "Group",
                     normalize = TRUE, norm_method = "hellinger",
                     n_neighbors = 10, random_state = 42) {
  set.seed(random_state)

  if (!sample_id_col %in% colnames(sample_info)) {
    stop("SKILL_MISSING_COLUMNS: sample_id_col not found in sample_info")
  }
  if (!group_col %in% colnames(sample_info)) {
    stop("SKILL_MISSING_COLUMNS: group_col not found in sample_info")
  }
  if (n_neighbors <= 1) {
    stop("SKILL_INVALID_PARAMETER: n_neighbors must be > 1")
  }
  if (n_neighbors >= nrow(otu)) {
    stop("SKILL_INVALID_PARAMETER: n_neighbors must be smaller than sample count")
  }

  otu_use <- otu
  if (normalize) {
    otu_use <- vegan::decostand(otu, method = norm_method)
  }

  umap_res <- umap::umap(otu_use, n_neighbors = n_neighbors)

  df <- as.data.frame(umap_res$layout)
  colnames(df) <- c("X1", "X2")
  df$SampleID <- rownames(otu_use)

  group_df <- sample_info
  group_df$SampleID <- group_df[[sample_id_col]]

  merge(df, group_df, by = "SampleID")
}
