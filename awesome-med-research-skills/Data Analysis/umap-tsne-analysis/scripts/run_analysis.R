run_umap_tsne_analysis <- function(
    input_file,
    group_file,
    output_dir,
    method = "both",
    sample_id_col = NULL,
    group_col = NULL,
    perplexity = 25,
    theta = 0.0,
    pca = FALSE,
    check_duplicates = FALSE,
    normalize = TRUE,
    norm_method = "hellinger",
    n_neighbors = 10,
    seed = 42,
    timeout = 0
) {
  log_info("Step 1/4: Loading and validating data...")
  dat <- load_data(
    input_file = input_file,
    group_file = group_file,
    sample_id_col = sample_id_col,
    group_col = group_col
  )
  
  log_info(paste("Samples:", nrow(dat$map)))
  log_info(paste("Features:", ncol(dat$mat)))
  log_info(paste("Group column:", dat$group_col))
  log_info(paste("Samples per group:", paste(table(dat$map[[dat$group_col]]), collapse = ", ")))
  
  colors <- generate_group_colors(nlevels(dat$map[[dat$group_col]]))
  
  save_analysis_rda(
    dat = dat,
    output_dir = output_dir,
    input_file = input_file,
    group_file = group_file,
    method = method,
    sample_id_col = sample_id_col,
    perplexity = perplexity,
    theta = theta,
    pca = pca,
    check_duplicates = check_duplicates,
    normalize = normalize,
    norm_method = norm_method,
    n_neighbors = n_neighbors,
    seed = seed,
    timeout = timeout,
    colors = colors
  )
  
  with_timeout({
    if (method %in% c("tsne", "both")) {
      run_tsne_workflow(
        dat = dat,
        output_dir = output_dir,
        colors = colors,
        perplexity = perplexity,
        theta = theta,
        pca = pca,
        check_duplicates = check_duplicates,
        seed = seed
      )
    }
    
    if (method %in% c("umap", "both")) {
      run_umap_workflow(
        dat = dat,
        output_dir = output_dir,
        colors = colors,
        normalize = normalize,
        norm_method = norm_method,
        n_neighbors = n_neighbors,
        seed = seed
      )
    }
  }, timeout = timeout)
  
  log_info("Analysis complete!")
}