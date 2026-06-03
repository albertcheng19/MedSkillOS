# 故障排查

## 错误码与处理建议

### SKILL_FILE_NOT_FOUND
- 场景：`--input`、`--running_file`、`--enrich_file`、`--rds_path` 路径不存在
- 处理：检查文件路径、权限和工作目录

### SKILL_MISSING_COLUMNS
- 场景：输入文件缺少 `--gene_col` 或 `--fc_col`
- 处理：核对列名，必要时显式传入参数

### SKILL_EMPTY_DATA
- 场景：输入表为空，或过滤 NA 后无可用基因
- 处理：检查文件内容与列值质量

### SKILL_INVALID_PARAMETER
- 场景：`type`、`species`、`method`、`pvalue_cutoff`、`timeout` 等参数非法
- 处理：运行 `Rscript scripts/main.R --help` 后逐项核对

### SKILL_PACKAGE_NOT_FOUND
- 场景：`optparse`、`clusterProfiler`、`fgsea`、`msigdbr`、`enrichplot` 等依赖缺失
- 处理：先安装缺失包，再重新运行

### SKILL_ANALYSIS_FAILED
- 场景：GSEA 在多次重试后仍失败
- 处理：检查输入数据质量、基因集内容和 `method` 参数，并查看完整错误日志

## 日志格式

日志统一为：
- `[INFO]  YYYY-MM-DD HH:MM:SS | 消息`
- `[WARN]  YYYY-MM-DD HH:MM:SS | 消息`
- `[ERROR] YYYY-MM-DD HH:MM:SS | 错误码: 消息`

## 建议排查顺序

1. 先运行 `Rscript scripts/main.R --help`
2. 再检查输入文件与列名
3. 再检查参数取值是否合法
4. 最后检查依赖包是否齐全

## 示例

`[ERROR] 2026-04-15 10:00:00 | SKILL_FILE_NOT_FOUND: File does not exist ./missing.csv`