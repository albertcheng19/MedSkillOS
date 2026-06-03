# Algorithm Details

## Dimensionality Reduction Methods

### 1. t-SNE

t-SNE (t-distributed stochastic neighbor embedding) is a non-linear dimensionality reduction method designed to preserve local neighborhood relationships in a low-dimensional embedding.

#### Workflow
1. Compute pairwise similarities in high-dimensional space
2. Convert similarities into conditional probabilities
3. Define low-dimensional similarities using a Student t-distribution
4. Minimize divergence between the two distributions by iterative optimization

#### Key Parameters
- `perplexity`: controls the effective neighborhood size
- `theta`: controls approximation speed/accuracy tradeoff in Barnes-Hut t-SNE
- `pca`: whether to use PCA preprocessing before embedding
- `check_duplicates`: whether to explicitly detect duplicate rows

#### Practical Notes
- Best suited for exploring local cluster structure
- Sensitive to perplexity and random seed
- The script fixes the seed for reproducibility

### 2. UMAP

UMAP (uniform manifold approximation and projection) is a manifold learning approach that constructs a graph representation of the data and optimizes a low-dimensional embedding.

#### Workflow
1. Build local fuzzy simplicial sets from nearest neighbors
2. Construct weighted graph structure in high-dimensional space
3. Optimize a low-dimensional embedding to preserve graph relationships

#### Key Parameters
- `n_neighbors`: controls local neighborhood size
- `random_state`: controls reproducibility
- `normalize`: whether to transform abundance values before UMAP
- `norm_method`: normalization method used by `vegan::decostand()`

#### Practical Notes
- Often preserves both local and some global structure
- Usually faster than t-SNE on comparable data
- Helpful for abundance-style matrices after ecological normalization

## Data Preparation

### Matrix Orientation
The input matrix is expected to contain:
- first column: feature / OTU IDs
- remaining columns: samples

During preprocessing:
1. sample columns are aligned to the order in the group file
2. the matrix is transposed
3. rows become samples and columns become features

### Sample Matching
The analysis requires exact sample ID matching between:
- matrix column names
- group file sample IDs

Any mismatch causes a `SKILL_SAMPLE_MISMATCH` error.

### Group Constraints
The script requires:
- at least 2 groups
- at least 2 samples per group

## Normalization

When `--normalize TRUE`, the script applies `vegan::decostand()` before UMAP.

### Hellinger Transformation
The default `hellinger` method:
1. converts raw abundance to relative abundance
2. applies square-root transformation

This is commonly used for ecological community data because it reduces dominance effects and improves Euclidean-space analyses.

## Reproducibility

Reproducibility is controlled by:
- CLI parameter `--seed`
- `set.seed()` in the main entry script
- method-level seed reuse in both t-SNE and UMAP workflows

With the same input and parameters, the script is designed to produce the same outputs across repeated runs in the same software environment.

## Outputs

### Coordinate Tables
The script writes:
- `table/tsne_coordinates.csv`
- `table/umap_coordinates.csv`

Each file contains:
- `SampleID`
- low-dimensional coordinates (`X1`, `X2`)
- group annotation columns

### Visualization
The script generates PDF scatter plots:
- `plot/tsne_plot.pdf`
- `plot/umap_plot.pdf`

Each plot is:
- colored by group
- optional group ellipses
- axis labeled for the selected embedding method

### Analysis Metadata
The script also writes:
- `data/session_info.txt`
- `data/analysis_data.rda`

These files capture the runtime environment plus the aligned matrix, sample metadata, color map, and analysis parameters used for the run.
