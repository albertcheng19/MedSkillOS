#!/usr/bin/env Rscript

compute_layout <- function(graph, layout_type) {
  switch(
    layout_type,
    kk = igraph::layout_with_kk(graph),
    fr = igraph::layout_with_fr(graph),
    circle = igraph::layout_in_circle(graph),
    igraph::layout_nicely(graph)
  )
}
