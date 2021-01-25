library(ggplot2)

plotCentile <- function(result, y, label) {
  return(
    ggplot(data = NULL) +
      annotate('rect', xmin = -5, xmax = 5, ymin = -Inf, ymax = Inf, fill = 'red', alpha = .5) +
      annotate('rect', xmin = -5, xmax = 5, ymin = result$`-2`, ymax = result$`2`, fill = 'orange', alpha = .5) +
      annotate('rect', xmin = -5, xmax = 5, ymin = result$`p3`, ymax = result$`p97`, fill = 'yellow', alpha = .5) +
      annotate('rect', xmin = -5, xmax = 5, ymin = result$`p10`, ymax = result$`p90`, fill = 'green', alpha = .5) +
      geom_hline(yintercept = y, size = 1) +
      coord_flip() +
      scale_x_continuous('', breaks = NULL) +
      scale_y_continuous(
        label,
        breaks = c(result$`-2`, result$p3, result$p10, result$p50, result$p90, result$p97, result$`2`),
        labels = sprintf('%.1f', c(result$`-2`, result$p3, result$p10, result$p50, result$p90, result$p97, result$`2`)),
        minor_breaks = NULL,
        sec.axis = sec_axis(
          ~.,
          breaks = c(result$`-2`, result$p3, result$p10, result$p50, result$p90, result$p97, result$`2`),
          labels = c('-2', 'p3', 'p10', 'p50', 'p90', 'p97', '2')
        )
      ) +
      theme_minimal() +
      theme(panel.grid.major = element_blank())
  )
}
