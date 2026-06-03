# Algorithm Details

## Overview

This skill constructs a ceRNA network around a user-provided key gene list by combining two interaction layers:

1. miRNA-mRNA interactions, filtered to keep only edges targeting the key genes.
2. miRNA-lncRNA interactions, filtered to keep only lncRNAs connected through the retained miRNAs.

The final network is undirected and contains three node types: `mRNA`, `miRNA`, and `lncRNA`.

## Step 1: Parse Key Genes

- Accept either a text file with one gene per line or a comma-separated CLI string.
- Remove blank lines, comment lines starting with `#`, and duplicates.

## Step 2: Select miRNA-mRNA Dataset

Supported modes:

- `combined`: use bundled precomputed intersection across starBase, miRDB, and miRTarBase.
- `starbase`, `mirdb`, `mirtarbase`: use one source directly.
- `starbase+mirdb`, `starbase+mirtarbase`, `mirdb+mirtarbase`: recompute the pairwise interaction overlap.

For pairwise modes, each interaction is represented as the pair `(miRNA, mRNA)`. The retained set is:

```text
intersection = pairs(dataset_1) ∩ pairs(dataset_2)
```

Then keep only interactions where:

```text
mRNA ∈ key_genes
```

## Step 3: Filter miRNA-lncRNA Interactions

Choose one of the bundled starBase lncRNA datasets by strictness level: `High`, `Median`, or `Low`.

Retain only rows where:

```text
miRNA ∈ miRNAs_kept_from_step_2
```

Then count lncRNA occurrence frequency and keep lncRNAs passing:

```text
frequency(lncRNA) >= lncrna_freq_thresh
```

## Step 4: Build Network

Create two edge sets:

- `miRNA -> mRNA`
- `miRNA -> lncRNA`

Merge and deduplicate the two edge sets, then classify nodes by membership:

- `miRNA`: appears as the interaction mediator
- `mRNA`: appears in the retained miRNA-mRNA table
- `lncRNA`: appears only in the retained miRNA-lncRNA table

## Step 5: Degree Calculation

Use an undirected graph and calculate node degree:

```text
degree(v) = number of incident edges connected to node v
```

Degree is stored in `ceRNA_network_nodes.csv` and used to scale node size in the PDF plot.

## Visualization

- Layout is selected from igraph built-in algorithms such as Kamada-Kawai (`kk`) or Fruchterman-Reingold (`fr`).
- Node color is mapped by node type.
- Node size is scaled from degree using min-max normalization when degrees vary.
