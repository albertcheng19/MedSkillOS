#!/usr/bin/env Rscript
# Test script for TF Regulatory Network Analysis

cat("=== Running tests for TF Regulatory Network Analysis ===\n")

# Utility function to get script directory
get_script_dir <- function() {
  cmd_args <- commandArgs(trailingOnly = FALSE)
  file_arg_idx <- which(grepl("^--file=", cmd_args))
  if (length(file_arg_idx) > 0) {
    arg0 <- sub("^--file=", "", cmd_args[file_arg_idx])
    if (!is.na(arg0) && length(arg0) > 0 && file.exists(arg0))
      return(dirname(normalizePath(arg0)))
  }
  return(".")
}

# Set paths
script_dir <- get_script_dir()
module_root <- normalizePath(file.path(script_dir, ".."))
setwd(module_root)

main_script <- file.path(module_root, "scripts", "main.R")

# Test output directory
test_output_dir <- file.path(module_root, "tests", "test_output")
if (dir.exists(test_output_dir)) {
  unlink(test_output_dir, recursive = TRUE)
}

# Function to run command and check exit code
run_test <- function(name, cmd, should_succeed = TRUE) {
  cat(sprintf("\n[Test] %s\n", name))
  cat(sprintf("Command: %s\n", cmd))
  
  exit_code <- system(cmd, ignore.stdout = !should_succeed, ignore.stderr = !should_succeed)
  
  if (should_succeed) {
    if (exit_code == 0) {
      cat("✅ PASS\n")
      return(TRUE)
    } else {
      cat("❌ FAIL (expected success, got exit code", exit_code, ")\n")
      return(FALSE)
    }
  } else {
    if (exit_code != 0) {
      cat("✅ PASS (correctly failed)\n")
      return(TRUE)
    } else {
      cat("❌ FAIL (expected failure, but succeeded)\n")
      return(FALSE)
    }
  }
}

# Function to check file exists
check_file <- function(filepath, description) {
  if (file.exists(filepath)) {
    cat(sprintf("  ✅ %s exists: %s\n", description, filepath))
    return(TRUE)
  } else {
    cat(sprintf("  ❌ %s missing: %s\n", description, filepath))
    return(FALSE)
  }
}

# Run tests
passed <- 0
total <- 0

# Test 1: Human genes from command line
total <- total + 1
test_cmd <- paste(
  "Rscript", main_script,
  "--gene TP53,MYC,EGFR",
  "--species human",
  "--output_dir", file.path(test_output_dir, "human_cmd"),
  "--seed 42",
  "--width 8 --height 6"  # Smaller size for faster testing
)

if (run_test("Human genes (command line)", test_cmd)) {
  output_dir <- file.path(test_output_dir, "human_cmd")
  check_file(file.path(output_dir, "plot", "TF_Network_Plot.pdf"), "PDF plot")
  check_file(file.path(output_dir, "table", "tf_network.xlsx"), "Network Excel file")
  check_file(file.path(output_dir, "table", "TF_Target_Filtered_Core_human.xlsx"), "Filtered table")
  check_file(file.path(output_dir, "session_info.txt"), "Session info")
  check_file(file.path(output_dir, "data", "tf.Rdata"), "R data file")
  passed <- passed + 1
}

# Test 2: Human genes from file
total <- total + 1
test_cmd <- paste(
  "Rscript", main_script,
  "--gene_file", file.path(module_root, "tests", "data", "human_genes.txt"),
  "--species human",
  "--output_dir", file.path(test_output_dir, "human_file"),
  "--seed 42"
)

if (run_test("Human genes (file input)", test_cmd)) {
  output_dir <- file.path(test_output_dir, "human_file")
  check_file(file.path(output_dir, "plot", "TF_Network_Plot.pdf"), "PDF plot")
  passed <- passed + 1
}

# Test 3: Mouse genes from command line
total <- total + 1
test_cmd <- paste(
  "Rscript", main_script,
  "--gene Tp53,Myc,Egfr",
  "--species mouse",
  "--output_dir", file.path(test_output_dir, "mouse_cmd"),
  "--seed 42"
)

if (run_test("Mouse genes (command line)", test_cmd)) {
  output_dir <- file.path(test_output_dir, "mouse_cmd")
  check_file(file.path(output_dir, "plot", "TF_Network_Plot.pdf"), "PDF plot")
  check_file(file.path(output_dir, "table", "TF_Target_Filtered_Core_mouse.xlsx"), "Filtered table")
  passed <- passed + 1
}

# Test 4: Error handling - no input genes
total <- total + 1
test_cmd <- paste(
  "Rscript", main_script,
  "--species human",
  "--output_dir", file.path(test_output_dir, "error_test"),
  "--seed 42"
)

if (run_test("Error: No input genes", test_cmd, should_succeed = FALSE)) {
  passed <- passed + 1
}

# Test 5: Error handling - invalid species
total <- total + 1
test_cmd <- paste(
  "Rscript", main_script,
  "--gene TP53,MYC,EGFR",
  "--species invalid",
  "--output_dir", file.path(test_output_dir, "error_species"),
  "--seed 42"
)

if (run_test("Error: Invalid species", test_cmd, should_succeed = FALSE)) {
  passed <- passed + 1
}

# Test 6: Help flag
total <- total + 1
test_cmd <- paste(
  "Rscript", main_script,
  "--help"
)

if (run_test("Help flag", test_cmd)) {
  passed <- passed + 1
}

# Test 7: Legacy localized visualization aliases
total <- total + 1
test_cmd <- paste(
  "Rscript", main_script,
  "--gene PTPRC,FOXP3,CD4",
  "--species human",
  "--style_layout '发散(fr)'",
  "--style_line '曲线'",
  "--point_shape '菱形,三角形'",
  "--line_color '#E64B35'",
  "--title 'Immune TF Network'",
  "--output_dir", file.path(test_output_dir, "legacy_aliases"),
  "--seed 42"
)

if (run_test("Legacy visualization aliases", test_cmd)) {
  output_dir <- file.path(test_output_dir, "legacy_aliases")
  check_file(file.path(output_dir, "plot", "TF_Network_Plot.pdf"), "PDF plot")
  check_file(file.path(output_dir, "table", "tf_network.xlsx"), "Network Excel file")
  passed <- passed + 1
}

# Cleanup
cat("\n=== Cleaning up test output ===\n")
if (dir.exists(test_output_dir)) {
  unlink(test_output_dir, recursive = TRUE)
  cat("Test output directory removed\n")
}

# Summary
cat("\n=== Test Summary ===\n")
cat(sprintf("Total tests: %d\n", total))
cat(sprintf("Passed: %d\n", passed))
cat(sprintf("Failed: %d\n", total - passed))
cat(sprintf("Success rate: %.1f%%\n", 100 * passed / total))

if (passed == total) {
  cat("\n✅ All tests passed!\n")
  quit(save = "no", status = 0)
} else {
  cat("\n❌ Some tests failed\n")
  quit(save = "no", status = 1)
}
