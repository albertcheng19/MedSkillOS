# Project Memory

## Research

**Topic**: 生物医学计算研究，聚焦胶质瘤（glioma）与阿尔茨海默病（Alzheimer's disease）的分子机制，结合机器学习与生物信息学方法进行多组学分析。具体方向包括：铁死亡（ferroptosis）调控机制、lncRNA/ceRNA网络在胶质瘤中的作用、神经退行性疾病与肿瘤的双向关联，以及基于ML的预后模型构建。

**Key variables / framework**: 铁死亡（ferroptosis）、lncRNA、胶质瘤（glioma）、ceRNA网络、机器学习（ML）预后模型、生物信息学分析（RNA-seq/多组学）、阿尔茨海默病与癌症交叉、神经退行性疾病生物标志物

**Status**: 文献调研阶段。已完成5篇核心论文精读，建立了lncRNA–ferroptosis–胶质瘤调控网络的初步框架；机器学习和阿尔茨海默病交叉方向尚在探索。

## Project Structure
Paths are managed in `config.json`. Update that file if folders are renamed.
- ArticleFeed dir: `recommend.py`, `lookup_paper.py`, `rename_pdfs.py`, `search_config.json`, `config.json`
- `config.json["data_dir"]` — data root; PDFs here, notes in `data_dir/notes/`

## Key Decisions
- Paper feed: Semantic Scholar API; search terms in search_config.json, updated by Claude each session
- Three-tier reading diet: Tier 1 core / Tier 2 adjacent field / Tier 3 wild card (tech-heavy)
- Note folder structure: all analyzed papers → notes/YYYY-MM-DD/PaperName/ (PDF + MD together); recommendations list → notes/YYYY-MM-DD/recommendations.md
- PDF naming convention: Author_Year_Keywords.pdf; automated via rename_pdfs.py (no Claude needed)
- Paper analysis: interactive via Claude Code (4 sections: 论文权重 / 亮点 / 可借鉴 / 如何用到论文)

## Standing Coding Rules (apply to all future work)
1. **No hardcoded paths/keywords**: always read from config.json or derive paths relative to script location (`os.path.dirname(__file__)`). Never write absolute paths as string literals in scripts.
2. **Keep folder clean**: when adding a new script, check if any existing script is superseded and delete it. When changing workflow, immediately sync all related files (WORKFLOW.md, MEMORY.md, reading_list.md, config.json).

## Auto-sync Rules (execute automatically, no reminder needed)
After analyzing any paper:
1. Add [x] entry to reading_list.md with correct relative link (YYYY-MM-DD/PaperName/PaperName.md, relative to notes/ dir)
2. Add paper note filename to search_config.json `based_on_notes` — keep max 25 entries (sliding window, drop oldest)
3. Add to Reading Progress below — keep max 20 entries (sliding window, drop oldest)
4. Create the dated folder, copy PDF in, save MD — all in one step

## Reading Progress (最近已读，供 /feed 参考)
<!-- Claude 自动维护，最多 20 条，超出时删除最旧的 -->
- 2026-03-27: Chen_2021_TMEM161B-AS1 — lncRNA TMEM161B-AS1通过hsa-miR-27a-3p海绵化上调FANCD2/CD44，调控胶质瘤恶性行为和TMZ耐药 (Cell Death Discovery, 引用57)
- 2026-03-27: Zheng_2023_SNAI3-AS1 — lncRNA SNAI3-AS1受DNA甲基化沉默，通过SND1干扰m6A依赖性Nrf2 mRNA稳定性促进铁死亡 (J Exp Clin Cancer Res, 引用39)
- 2026-03-27: Yang_Pan_2021_Ferroptosis_Gene_Prediction — 8-FRG预后风险评分模型 + ceRNA网络，揭示FRG与CRC免疫治疗疗效关联；方法可迁移至胶质瘤 (Disease Markers, 引用11)
- 2026-03-27: Miao_2022_Hsp90_Acsl4_Ferroptosis_Glioma — 首次揭示Hsp90–Drp1–Acsl4轴调控胶质瘤铁死亡的机制，体外+体内验证完整 (Cell Death & Disease, 引用86)
- 2026-03-27: Hu_2020_TMZ_Resistance_Ferroptosis_Glioma — TMZ耐药与铁死亡综述，系统梳理erastin等铁死亡诱导剂在胶质瘤耐药中的作用 (Frontiers in Oncology, 引用90)
- 2026-03-29: Tan_2023_lncRNA_ceRNA_Ferroptosis_Alzheimer — AD脑组织中LASSO+WGCNA筛选5个铁死亡hub基因（EPT1/KLHL24/LRRFIP1/CXCL2/CD44），构建lncRNA-ceRNA网络+CIBERSORT免疫浸润 (Front Aging Neurosci, 引用12)
- 2026-03-29: Gross_2024_DeepLearning_RNAseq_Survival — TCGA多癌种RNA-seq基准测试，DL表征与PCA在生存预测中表现相当；AE+masking在基因必要性预测中占优 (Scientific Reports, 引用10)

## Relevant Journals
- Neuro-Oncology
- Cancer Research
- Cell Death & Differentiation
- Autophagy
- Molecular Cancer
- Genome Research
- Journal of Clinical Oncology
- Alzheimer's & Dementia
- Acta Neuropathologica
- Clinical Cancer Research
