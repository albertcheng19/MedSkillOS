# Algorithm Details

## Dorothea Database

### Overview
Dorothea is a curated database of transcription factor (TF)-target interactions with confidence scores. It contains:
- **Human data**: 1,395 TFs regulating 17,243 targets (dorothea_hs)
- **Mouse data**: 1,148 TFs regulating 15,055 targets (dorothea_mm)
- **Confidence levels**: A (high), B (medium), C (low), D (very low), E (predicted)
- **Source**: https://github.com/saezlab/dorothea

### Confidence Levels
- **A**: Curated from literature with experimental validation
- **B**: Inferred from reliable computational predictions
- **C**: Lower confidence predictions
- **D/E**: Very low confidence (filtered out in analysis)

The analysis uses only confidence levels A, B, and C for reliable results.

## TF-Target Network Analysis

### Step 1: Input Processing
1. **Gene input**: Accepts comma-separated list or file input
2. **Species matching**: Human (TP53) vs mouse (Tp53) gene symbols
3. **Validation**: Removes empty entries and duplicates

### Step 2: Database Query
1. **Local database priority**: Searches for pre-saved .rds files in order:
   - User-specified path (`--db_path`)
   - Current working directory (`./database/`)
   - Script directory (`scripts/database/`)
   - Project root directory (`database/`)
2. **Fallback**: Loads from Dorothea R package if local files not found
3. **Filtering**: Extracts TF-target pairs where:
   - Target gene matches input gene list
   - Confidence level ∈ {A, B, C}

### Step 3: Network Construction
1. **Edge list**: TF → Target relationships with attributes:
   - `node1`: Transcription factor
   - `node2`: Target gene  
   - `Value`: Number of targets regulated by the TF (TF frequency)
2. **Node list**: All unique TFs and targets with:
   - `node`: Gene symbol
   - `type`: "TF" or "Target"
3. **Graph representation**: Directed graph with TFs as sources, targets as sinks

### Step 4: Statistical Analysis
1. **TF frequency calculation**: Count of targets regulated by each TF
2. **Ranking**: TFs sorted by number of regulated targets (descending)
3. **Filtering**: Only includes relationships with ≥1 target

## Network Visualization

### Layout Algorithms
Multiple layout options available via `--style_layout`:

| Layout | Algorithm | Description |
|--------|-----------|-------------|
| `kk` (legacy alias: `发散(kk)`) | Kamada-Kawai | Force-directed layout minimizing edge crossings |
| `fr` (legacy alias: `发散(fr)`) | Fruchterman-Reingold | Force-directed layout with attractive/repulsive forces |
| `nicely` (legacy alias: `发散(nicely)`) | Automatic | Chooses optimal layout based on graph properties |
| `circle` (legacy alias: `环形(circle)`) | Circular | Arranges nodes on a circle |
| `sphere` (legacy alias: `球体(sphere)`) | Spherical | 3D sphere layout projected to 2D |
| `star` (legacy alias: `环绕(star)`) | Star | Central node with others arranged around |
| `grid` (legacy alias: `点阵(grid)`) | Grid | Arranges nodes in a grid pattern |
| `randomly` (legacy alias: `随机(randomly)`) | Random | Random node positions |

### Visual Encoding
1. **Node colors**:
   - TF nodes: Red (#E64B35)
   - Target nodes: Blue (#4DBBD5)
2. **Node shapes**: Customizable via `--point_shape` parameter
3. **Edge styling**:
   - Color: Configurable via `--line_color`
   - Type: Solid or dashed via `--line_type`
   - Arrow: Directed edges show regulation direction
4. **Labels**: Optional node labels with configurable font size

### Aesthetic Mappings
The visualization supports multiple aesthetic mappings:

#### Edge Mappings (optional)
- `edge_alpha`: Transparency based on edge weight
- `edge_colour`: Color based on edge weight  
- `edge_width`: Thickness based on edge weight
- `edge_linetype`: Line type based on edge weight

#### Node Mappings (default)
- `fill`: Color by node type (TF/Target)
- `shape`: Shape by node type (TF/Target)

## Technical Implementation

### R Packages Used
- **dorothea**: TF-target interaction database
- **tidygraph**: Graph data structure and manipulation
- **ggraph**: Grammar of graphics for networks
- **tidyverse**: Data manipulation and visualization
- **openxlsx**: Excel file I/O
- **optparse**: Command-line argument parsing
- **showtext**: Font rendering for PDF output

### Random Seed
- Fixed random seed (`--seed 42`) ensures reproducible layouts
- Affects: Random layout algorithm, label positioning, random sampling

### Output Formats
1. **Excel file**: Contains edge and node data sheets
2. **PDF plot**: Publication-ready network visualization
3. **R data**: Complete analysis environment for reproducibility
4. **Session info**: Package versions and system information

## Limitations and Assumptions

### Database Coverage
- Dorothea covers only known TF-target relationships
- Many genes may have no known regulating TFs in the database
- Confidence levels A/B/C provide reliable but not exhaustive coverage

### Gene Symbol Requirements
- Requires official gene symbols (HGNC for human, MGI for mouse)
- Does not automatically convert aliases or previous symbols
- Case-sensitive for species distinction

### Network Interpretation
- Shows direct TF-target relationships only
- Does not infer indirect regulation or pathway context
- Binary relationships (present/absent) without strength quantification
