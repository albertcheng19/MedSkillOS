# CLI 使用示例

## 示例 1：最小运行命令

```bash
Rscript scripts/main.R \
  --input tests/data/sample_deg_results.csv \
  --outdir ./output_basic \
  --type KEGG \
  --species human \
  --seed 42 \
  --timeout 300
```

## 示例 2：自定义列名并输出详细日志

```bash
Rscript scripts/main.R \
  --input tests/data/sample_deg_results.csv \
  --outdir ./output_verbose \
  --gene_col name \
  --fc_col logFC \
  --type GO_BP \
  --species human \
  --method fgsea \
  --pvalue_cutoff 0.05 \
  --verbose \
  --seed 42 \
  --timeout 300
```

## 示例 3：使用预存基因集 RDS

说明：CLI 参数使用 `--type HALLMARKS`，脚本会在预载 RDS 中自动映射到资产键 `Hallmarks`。

```bash
Rscript scripts/main.R \
  --input tests/data/sample_deg_results.csv \
  --outdir ./output_rds \
  --type HALLMARKS \
  --species human \
  --rds_path ./assets/ssGSEA.rds \
  --seed 42 \
  --timeout 300
```

## 示例 4：绘制富集曲线图

先运行示例 1，使用 `tests/data/sample_deg_results.csv` 生成 `./output_basic/Table/enrichGSEA.csv` 和 `./output_basic/Table/gsea_running_scores.csv`。

```bash
Rscript scripts/main.R \
  --running_file ./output_basic/Table/gsea_running_scores.csv \
  --enrich_file ./output_basic/Table/enrichGSEA.csv \
  --plot_output ./output_basic/plot/gsea_plot.pdf \
  --top_n 3 \
  --plot_format pdf \
  --verbose \
  --seed 42 \
  --timeout 300
```