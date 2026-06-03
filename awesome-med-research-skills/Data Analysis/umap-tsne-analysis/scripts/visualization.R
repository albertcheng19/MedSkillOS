check_group_colors <- function(df, group_col, colors) {
  n_group <- length(unique(df[[group_col]]))
  if (length(colors) < n_group) {
    stop("SKILL_INVALID_PARAMETER: colors are fewer than groups")
  }
  invisible(TRUE)
}

should_draw_ellipse <- function(df, group_col, min_points = 4) {
  group_sizes <- table(df[[group_col]])
  if (length(group_sizes) == 0) {
    log_warn("Skipping group ellipses: no groups available for ellipse calculation.")
    return(FALSE)
  }

  smallest_group <- min(group_sizes)
  if (smallest_group < min_points) {
    log_warn(paste(
      "Skipping group ellipses:",
      "at least", min_points, "samples per group are required,",
      paste0("but the smallest group has ", smallest_group, ".")
    ))
    return(FALSE)
  }

  TRUE
}

plot_dim <- function(df, x_col = "X1", y_col = "X2", group_col = "Group",
                     colors = c("#1597A5", "#FFC24B", "#FEB3AE"),
                     point_size = 3, point_alpha = 0.7, point_shape = 21,
                     point_border_color = "black", ellipse = TRUE,
                     ellipse_type = "norm", ellipse_level = 0.95,
                     ellipse_linewidth = 1, ellipse_show_legend = FALSE,
                     vline = TRUE, hline = TRUE, vline_x = 0, hline_y = 0,
                     dashed_lty = "dashed", xlab = "Dim1", ylab = "Dim2",
                     base_size = 12, axis_text_size = 10) {
  check_group_colors(df, group_col, colors)

  p <- ggplot2::ggplot(df, ggplot2::aes(x = .data[[x_col]], y = .data[[y_col]])) +
    ggplot2::theme_bw() +
    ggplot2::geom_point(
      ggplot2::aes(fill = .data[[group_col]]),
      size = point_size,
      color = point_border_color,
      shape = point_shape,
      alpha = point_alpha
    ) +
    ggplot2::labs(x = xlab, y = ylab) +
    ggplot2::scale_fill_manual(values = colors) +
    ggplot2::theme(
      axis.title.x = ggplot2::element_text(size = base_size),
      axis.title.y = ggplot2::element_text(size = base_size, angle = 90),
      axis.text.x = ggplot2::element_text(size = axis_text_size),
      axis.text.y = ggplot2::element_text(size = axis_text_size),
      panel.grid = ggplot2::element_blank()
    )

  if (ellipse && should_draw_ellipse(df, group_col = group_col)) {
    p <- p +
      ggplot2::stat_ellipse(
        ggplot2::aes(color = .data[[group_col]]),
        type = ellipse_type,
        level = ellipse_level,
        linewidth = ellipse_linewidth,
        show.legend = ellipse_show_legend
      ) +
      ggplot2::scale_color_manual(values = colors)
  }

  if (vline) p <- p + ggplot2::geom_vline(xintercept = vline_x, lty = dashed_lty)
  if (hline) p <- p + ggplot2::geom_hline(yintercept = hline_y, lty = dashed_lty)

  p
}
