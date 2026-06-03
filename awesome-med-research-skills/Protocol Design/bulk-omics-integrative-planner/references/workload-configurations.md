# Workload Configurations

Always output all four configurations. Recommend one as the primary plan.

| Configuration | Typical Scope | Data Expectation | Core Modules | Validation Level |
|---|---|---|---|---|
| Lite | Fast, bounded, public-data-first | 1 suitable dataset or 1 dominant omics layer | QC, normalization, primary contrast, focused pathway interpretation | Within-dataset consistency |
| Standard | Conventional publishable bulk-omics paper | 1–2 datasets or 1 strong dataset + orthogonal support | Lite + covariate-aware analysis + signature / subtype or clinical association + focused validation | Within-dataset + one external layer |
| Advanced | Stronger mechanism and robustness | 2+ datasets and/or 2 omics layers with usable metadata | Standard + cross-dataset robustness + deeper integration or stratified modeling | Cross-dataset + orthogonal validation |
| Publication+ | High-ambition, multi-layer manuscript | Multiple datasets and substantial validation support | Advanced + stronger translational or experimental extension | Multi-layer validation and extension |

## Recommendation Logic
- **Lite** = minimum executable version.
- **Standard** = default best-fit unless user constraints are extremely tight or the ambition is unusually high.
- **Advanced** = use when robustness or integrative depth materially improves the project.
- **Publication+** = use only when data, time, and validation resources plausibly support it.

## Subset Rule
Each higher configuration must extend the lower one. Do not introduce a completely different project at higher tiers.
