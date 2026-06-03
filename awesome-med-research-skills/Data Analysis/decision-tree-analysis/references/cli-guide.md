# CLI Guide

## Basic Classification Example

```bash
Rscript scripts/main.R \
  --data_file tests/data/dt_sample1.csv \
  --target_var fustat \
  --task_type classification \
  --output_dir tests/output_dt_sample1_classification
```

## Second CSV Classification Example

```bash
Rscript scripts/main.R \
  --data_file tests/data/dt_sample2.csv \
  --target_var fustat \
  --task_type classification \
  --output_dir tests/output_dt_sample2_classification
```

## TXT Input Example

```bash
Rscript scripts/main.R \
  --data_file tests/data/dt_sample3.txt \
  --target_var Group \
  --task_type classification \
  --output_dir tests/output_dt_sample3_classification
```

## Exclude Identifier Columns

```bash
Rscript scripts/main.R \
  --data_file input.csv \
  --target_var outcome \
  --exclude_vars sample_id,patient_name \
  --output_dir results
```

## Tune Tree Size

```bash
Rscript scripts/main.R \
  --data_file input.csv \
  --target_var outcome \
  --max_depth 4 \
  --minsplit 10 \
  --minbucket 4 \
  --cp 0.005 \
  --output_dir tuned_results
```

## Write TXT Tables Instead of CSV

```bash
Rscript scripts/main.R \
  --data_file input.csv \
  --target_var outcome \
  --output_format txt \
  --output_dir txt_results
```

## Expected Key Outputs

- `table/decision_tree_feature_importance.csv`
- `figure/decision_tree_feature_importance.pdf`
- `data/decision_tree_predictions.csv`
