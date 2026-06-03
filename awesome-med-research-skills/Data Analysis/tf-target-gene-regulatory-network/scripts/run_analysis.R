# Main analysis workflow for TF Regulatory Network Analysis

#' Main analysis function
#'
#' Executes the complete TF regulatory network analysis workflow:
#' 1. Parse and validate input genes
#' 2. Load Dorothea database
#' 3. Filter TF-target relationships
#' 4. Prepare network data
#' 5. Save results
#'
#' @param gene_cmd Comma-separated gene string (character or NULL)
#' @param gene_file Path to gene file (character or NULL)
#' @param species Species identifier: "human" or "mouse" (default: "human")
#' @param output_dir Output directory name (default: "TF_Result")
#' @param db_path Path to local database file (optional)
#' @param script_dir Script directory for relative paths
#' @param seed Random seed for reproducibility (default: 42)
#' 
#' @return List with analysis results:
#'   - output_dir: Absolute path to output directory
#'   - gene_count: Number of input genes analyzed
#'   - tf_target_count: Number of TF-target relationships found
#'   - network_data: Network data structure
#' 
#' @examples
#' \dontrun{
#' result <- run_tf_analysis(gene_cmd = "TP53,MYC,EGFR", species = "human")
#' }
run_tf_analysis <- function(gene_cmd = NULL, gene_file = NULL, species = "human",
                           output_dir = "TF_Result", db_path = NULL, 
                           script_dir = ".", seed = 42) {
  
  # Set random seed for reproducibility
  set.seed(seed)
  
  # Check dependencies
  check_pkg("dplyr")
  check_pkg("dorothea")
  check_pkg("openxlsx")
  check_pkg("tidyverse")
  
  log_info("Starting TF-target regulatory network analysis")
  
  # Parse gene input
  gene_list <- parse_gene_input(gene_cmd, gene_file)
  log_info(paste("Analyzing", length(gene_list), "input genes"))
  
  # Validate species
  species_choice <- validate_species(species)
  species_key <- get_species_key(species_choice)
  
  # Create output directory structure
  abs_output_path <- create_output_dirs(output_dir)
  
  # Load Dorothea database
  dt_data <- load_dorothea_database(species_key, db_path, script_dir)
  
  # Filter TF-target relationships
  filtered_table <- filter_tf_targets(dt_data, gene_list)
  
  # Prepare network data
  network_data <- prepare_network_data(filtered_table)
  
  # Save results
  save_network_results(network_data, abs_output_path, species_choice)
  
  log_info(paste("Analysis complete. Found", nrow(filtered_table), "TF-target relationships"))
  
  list(
    output_dir = abs_output_path,
    gene_count = length(gene_list),
    tf_target_count = nrow(filtered_table),
    network_data = network_data
  )
}