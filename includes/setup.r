#### data manipulation ####
library(tidyverse)
library(lubridate)
library(purrr)

#### statistics ####
library(moments)
library(forecast)

#### models ####
library(MSGARCH)

#### plotting ####
library(ggplot2)
library(grid)
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

#### other globals ####
CALCULATIONS_PATH <- "includes/calculations/"
ROUND_DIGITS <- 4

#### custom functions ####
custom_acf_plot <- function(return_list) {
  plots <- lapply(
    seq_along(return_list),
    function(i, data) {
      returns <- data[[i]]
      lags <- 20
      size <- 1

      return(list(
        returns %>%
          ggAcf(lags, size = size) +
          labs(
            title = element_blank(),
            y = element_blank(),
            x = element_blank()
          ),
        returns %>%
          ggPacf(lags, size = size) +
          labs(
            title = element_blank(),
            y = element_blank(),
            x = element_blank()
          ),
        returns^2 %>%
          ggAcf(lags, size = size) +
            labs(
              title = element_blank(),
              y = element_blank(),
              x = element_blank()
            )
      ))
    },
    data = return_list
  ) %>% unlist(recursive = FALSE)

  row_titles <- tables_full_names
  column_titles <- c("ACF", "PACF", "ACF (x²)")

  grid.draw(rbind(
    tableGrob(t(column_titles), rows = ""),
    cbind(
      tableGrob(row_titles),
      arrangeGrob(grobs = plots, ncol = length(column_titles)),
      size = "last"
    ),
    size = "last"
  ))
}

custom_auto_arima <- function(ts, ...) {
  auto.arima(
    ts,
    stationary = TRUE,
    seasonal = FALSE,
    max.p = 9,
    max.q = 9,
    ...
  )
}

custom_kable <- function(
  data, caption,
  escape = FALSE, digits = ROUND_DIGITS,
  ...
) {
  kable(
    data,
    format = "latex",
    booktabs = TRUE,
    caption = caption,
    escape = escape,
    digits = digits,
    ...
  ) %>%
    kable_styling()
}

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

custom_paste_tight <- function(...) {
  paste(..., sep = "")
}

custom_paste_math_assoc <- function(
  labels, values,
  round = ROUND_DIGITS
) {
  values <- values %>% round(round) %>% unname()
  output <- paste(labels, values, sep = " = ", collapse = ",\\:")
  paste("$", output, "$", sep = "")
}

custom_read_rds <- function(name) {
  readRDS(
    paste(
      CALCULATIONS_PATH, name, ".rds",
      sep = ""
    )
  )
}

custom_save_rds <- function(data, name) {
  saveRDS(
    data,
    paste(
      CALCULATIONS_PATH, name, ".rds",
      sep = ""
    )
  )
}
