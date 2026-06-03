load_data <- function(input_file, group_file, sample_id_col = NULL, group_col = NULL) {
  mat_df <- read_matrix_file(input_file)
  group_df <- read_group_file(group_file)
  
  sample_id_col <- resolve_sample_id_col(group_df, sample_id_col)
  group_col <- resolve_group_col(group_df, group_col)
  
  group_df <- normalize_group_table(group_df, sample_id_col, group_col)
  validate_groups(group_df, group_col = group_col)
  
  prepared <- align_and_prepare_matrix(mat_df, group_df)
  validate_groups(prepared$group_df, group_col = group_col)
  
  list(
    mat = prepared$mat,
    map = prepared$group_df,
    group_col = group_col
  )
}

run_tsne_workflow <- function(dat, output_dir, colors, perplexity, theta, pca,
                              check_duplicates, seed) {
  log_info("Step 2/4: Running t-SNE...")
  
  df_tsne <- run_tsne(
    otu = dat$mat,
    sample_info = dat$map,
    sample_id_col = "SampleID",
    group_col = dat$group_col,
    dims = 2,
    perplexity = perplexity,
    theta = theta,
    pca = pca,
    check_duplicates = check_duplicates,
    seed = seed
  )
  
  save_table(df_tsne, file.path(output_dir, "table", "tsne_coordinates.csv"))
  
  p_tsne <- plot_dim(
    df = df_tsne,
    x_col = "X1",
    y_col = "X2",
    group_col = dat$group_col,
    colors = colors,
    xlab = "tSNE1",
    ylab = "tSNE2"
  )
  
  save_plot_pdf(p_tsne, file.path(output_dir, "plot", "tsne_plot.pdf"))
  log_info("t-SNE finished.")
}

run_umap_workflow <- function(dat, output_dir, colors, normalize, norm_method,
                              n_neighbors, seed) {
  log_info("Step 3/4: Running UMAP...")
  
  df_umap <- run_umap(
    otu = dat$mat,
    sample_info = dat$map,
    sample_id_col = "SampleID",
    group_col = dat$group_col,
    normalize = normalize,
    norm_method = norm_method,
    n_neighbors = n_neighbors,
    random_state = seed
  )
  
  save_table(df_umap, file.path(output_dir, "table", "umap_coordinates.csv"))
  
  p_umap <- plot_dim(
    df = df_umap,
    x_col = "X1",
    y_col = "X2",
    group_col = dat$group_col,
    colors = colors,
    xlab = "UMAP1",
    ylab = "UMAP2"
  )
  
  save_plot_pdf(p_umap, file.path(output_dir, "plot", "umap_plot.pdf"))
  log_info("UMAP finished.")
}