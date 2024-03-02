#### data manipulation ####
library(tidyverse)
library(lubridate)
library(purrr)

#### statistics ####
library(moments)

#### switching models ####
library(MSGARCH)

#### plotting ####
library(ggplot2)
library(gridExtra)
theme_set(theme_minimal())
theme_fill_uep <- function(...) {
  scale_fill_brewer(palette = "Greens", ...)
}
theme_color_uep <- function(...) {
  scale_color_brewer(palette = "Greens", ...)
}
options(
  ggplot2.discrete.fill = theme_fill_uep,
  ggplot2.discrete.colour = theme_color_uep
)
primary_color <- "#005322"
update_geom_defaults(
  "line",
  list(
    color = primary_color
  )
)

#### tables and export ####
library(knitr)
library(kableExtra)
options(
  knitr.kable.NA = "–"
)

#### custom functions ####
custom_markov_plot <- function(data, probs) {
  data %>%
    mutate(
      probs = probs,
      return = abs(return) / max(abs(return), na.rm = TRUE)
    ) %>%
    as_tibble() %>%
    select(Data, return, probs) %>%
    ggplot(aes(Data)) +
      geom_line(aes(y = return), col = "black", alpha = 0.25) +
      geom_area(aes(y = probs), fill = primary_color, alpha = 0.5) +
      labs(
        x = "Data",
        y = "Prawdopodobieństwo reżimu 2"
      ) +
        scale_x_date(
        date_breaks = "6 months",
        date_labels = "%m.%y"
      )
}