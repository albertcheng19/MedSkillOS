# Visualization Parameters

These parameters control the appearance of the TF-target network visualization plot.

## Quick Reference

| Short | Long | Type | Default | Description |
|-------|------|------|---------|-------------|
| `-w` | `--width` | numeric | 12 | Figure width in inches |
| `-e` | `--height` | numeric | 10 | Figure height in inches |
| | `--family` | character | `Arial` | Font family for text |
| | `--label` | character | `node` | Label mapping type: `node` for node labels, `none` for no labels |
| | `--label_size` | character | `20pt` | Label font size |
| | `--legend_position` | character | `bottom` | Legend position: `bottom` or `right` |
| | `--line_color` | character | `#7E8B8E` | Line color (hex code) |
| | `--line_type` | character | `solid` | Line type: `solid` or `dashed` |
| | `--mapping_link_alpha` | character | `none` | Edge alpha mapping: `Value` or `none` (no mapping) |
| | `--mapping_link_color` | character | `none` | Edge color mapping: `Value` or `none` (no mapping) |
| | `--mapping_link_size` | character | `none` | Edge width mapping: `Value` or `none` (no mapping) |
| | `--mapping_link_type` | character | `none` | Edge type mapping: `Value` or `none` (no mapping) |
| | `--mapping_node_color` | character | `type` | Node color mapping: `type` (TF/Target) or `none` (no mapping) |
| | `--mapping_node_type` | character | `type` | Node shape mapping: `type` (TF/Target) or `none` (no mapping) |
| | `--point_color` | character | `#2E889D` | Node border color (hex code) |
| | `--point_fill` | character | `#2E879A` | Node fill color (hex code) |
| | `--point_shape` | character | `circle,square,diamond,triangle,triangle_down` | Node shapes: comma-separated list |
| | `--style_layout` | character | `sphere` | Layout style: `sphere`, `kk`, `fr`, `nicely`, `circle`, `star`, `grid`, `randomly` |
| | `--style_line` | character | `straight` | Line shape style: `straight` or `curve` |
| | `--theme_size` | character | `30pt` | Base theme font size |
| | `--title` | character | empty | Chart title |
| | `--title_x` | character | empty | X-axis title |

---

## Detailed Description

### Plot Dimensions

- **`--width`**, **`--height`**: Control the size of the output PDF in inches. Default is 12×10 inches.

### Text and Fonts

- **`--family`**: Font family for all text elements (labels, titles, legend).
- **`--label`**: Controls which nodes are labeled: `node` labels all nodes, `none` shows no labels.
- **`--label_size`**: Font size for node labels (supports "pt" units).
- **`--theme_size`**: Base font size for theme elements.

### Colors and Styling

- **`--line_color`**, **`--line_type`**: Control the appearance of edges (connections between nodes).
- **`--point_color`**, **`--point_fill`**: Border and fill colors for nodes.
- **`--point_shape`**: Shape of nodes (comma-separated list, will be recycled if fewer shapes than nodes).

### Layout and Structure

- **`--style_layout`**: Graph layout algorithm:
  - `sphere`: 3D spherical layout
  - `kk`: Kamada-Kawai layout
  - `fr`: Fruchterman-Reingold layout  
  - `nicely`: Automatic layout selection
  - `circle`, `star`, `grid`, `randomly`: Other layout options
- **`--style_line`**: Edge shape: `straight` for straight lines, `curve` for curved arcs.

### Mapping Options

Mapping parameters control how visual attributes are mapped to data values:

- **`--mapping_link_alpha`**, **`--mapping_link_color`**, **`--mapping_link_size`**, **`--mapping_link_type`**: Map edge attributes to the `Value` column (TF-target relationship count) or use `none` for uniform styling.
- **`--mapping_node_color`**, **`--mapping_node_type`**: Map node attributes to `type` (TF vs Target) or use `none` for uniform styling.

### Titles and Labels

- **`--title`**: Main chart title.
- **`--legend_position`**: Position of the legend (`bottom` or `right`).
- **`--title_x`**: X-axis title (rarely used for network plots).

---

## Examples

### Default Styling
```bash
Rscript scripts/main.R \
  --gene "TP53,MYC,EGFR" \
  --species human \
  --output_dir ./output
```

### Custom Styling
```bash
Rscript scripts/main.R \
  --gene "TP53,MYC,EGFR" \
  --species human \
  --output_dir ./output \
  --width 14 --height 8 \
  --style_layout circle \
  --line_color "#FF6B6B" \
  --point_color "#4ECDC4" \
  --title "TF Regulatory Network"
```

### Minimal Labels
```bash
Rscript scripts/main.R \
  --gene "TP53,MYC,EGFR" \
  --species human \
  --output_dir ./output \
  --label none \
  --legend_position right
```