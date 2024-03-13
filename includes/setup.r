################# libraries #################

# data manipulation
library(tidyverse)
library(lubridate)
library(purrr)
library(progress)

# statistics
library(moments)
library(forecast)
library(topsis)

# models
library(rugarch)
library(tseries)
library(MSGARCH)

# plotting
library(ggplot2)
library(grid)
library(gridExtra)

# tables and export
library(knitr)
library(kableExtra)

################# globals #################

primary_color <- "#005322"
calculations_path <- "includes/calculations/"
round_digits <- 4

################# custom functions #################
c_acf_plot <- function(return_list) {
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

c_auto_arima <- function(ts, ...) {
  auto.arima(
    ts,
    stationary = TRUE,
    seasonal = FALSE,
    max.p = 9,
    max.q = 9,
    ...
  )
}

c_kable <- function(
  data, caption,
  escape = FALSE, digits = round_digits,
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

c_list_with_names <- function(names, values) {
  setNames(
    as.list(values),
    names
  )
}

c_markov_get_model_name <- function(model) {
  c(
    model$spec$name[1] %>% str_split_1("_"),
    model$spec$name[2] %>% str_split_1("_")
  )
}

c_markov_get_insignif <- function(model, pull = TRUE) {
  output <-
    model$Inference$MatCoef %>%
    as_tibble(rownames = "param") %>%
    filter(
      `Pr(>|t|)` >= 0.05,
      str_starts(param, "P_", negate = TRUE),
    ) %>%
    mutate(
      is_unfixable = str_replace(param, "^(.*)_\\d$", "\\1") %in% c("alpha0", "alpha1", "alpha2")
    ) %>%
    filter(!is_unfixable)

  if (pull) return(output %>% pull(param))
  else return(output)
}

c_markov_get_params <- function(model, with_probs = TRUE) {
  output <-
    model$Inference$MatCoef %>%
    as_tibble(rownames = "param")

  if (with_probs) return(output)
  else return(output %>% filter(str_starts(param, "P_", negate = TRUE))) 
}

c_paste_tight <- function(...) {
  paste(..., sep = "")
}

c_paste_math_assoc <- function(
  labels, values,
  round = round_digits
) {
  values <- values %>% round(round) %>% unname()
  output <- paste(labels, values, sep = " = ", collapse = ",\\:")
  paste("$", output, "$", sep = "")
}

c_progress_setup <- function(label, total) {
  progress_bar$new(
    total = total,
    format = paste(label, "[:bar] :percent eta :eta"),
    clear = FALSE
  )
}

c_read_rds <- function(name) {
  readRDS(
    paste(
      calculations_path, name, ".rds",
      sep = ""
    )
  )
}

c_save_rds <- function(data, name) {
  saveRDS(
    data,
    paste(
      calculations_path, name, ".rds",
      sep = ""
    )
  )
}

################# configurations #################

# models
models_for_testing <-
  list(
    volatility = c("sGARCH", "eGARCH", "gjrGARCH"),
    distribution = c("norm", "ged", "std", "sstd")
  ) %>%
  expand.grid(stringsAsFactors = FALSE) %>%
  split(seq_len(nrow(.))) %>%
  bind_rows() %>%
  as_tibble()
models_for_testing_names <-
  models_for_testing %>%
  mutate(model_name = c_paste_tight(volatility, " (", distribution, ")")) %>%
  select(model_name) %>%
  c() %>%
  unlist() %>%
  unname()
markov_models_for_testing_indices <-
  models_for_testing_names %>%
  seq_along() %>%
  replicate(2, ., simplify = FALSE) %>%
  expand.grid() %>%
  as_tibble()

# plotting
theme_set(theme_minimal())
theme_fill_uep <- function(...) scale_fill_brewer(palette = "Greens", ...)
theme_color_uep <- function(...) scale_color_brewer(palette = "Greens", ...)
options(
  ggplot2.discrete.fill = theme_fill_uep,
  ggplot2.discrete.colour = theme_color_uep
)
update_geom_defaults(
  "line",
  list(
    color = primary_color
  )
)

# tables
options(
  knitr.kable.NA = "–"
)
