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
arma_max_lag <- 9
data_range <- c("1.01.2019", "1.06.2022")

################# custom functions #################
c_acf_plot <- function(returns_split) {
  lapply(
    returns_split,
    function(returns, i) {
      lags <- 20
      size <- 2

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
        #   ),
        # returns^2 %>%
        #   ggAcf(lags, size = size) +
        #   labs(
        #     title = element_blank(),
        #     y = element_blank(),
        #     x = element_blank()
          )
      ))
    }
  ) %>%
    unlist(recursive = FALSE) %>%
    c_plot(
      tables_full_names,
      c("ACF", "PACF", "ACF (x²)")[1:2]
    )
}

c_auto_arima <- function(ts, ...) {
  auto.arima(
    ts,
    stationary = TRUE,
    seasonal = FALSE,
    max.p = arma_max_lag,
    max.q = arma_max_lag,
    ...
  )
}

c_format_pval <- function(pval) {
  format.pval(pval, eps = 1e-4)
}

c_get_arma_name <- function(model) {
  coefs <- model$arma[c(1, 2)]

  if (Reduce(`&`, coefs == c(0, 0)))
    return("biały szum")

  c_paste_tight(
    if_else(coefs[1] > 0, "AR", ""),
    if_else(coefs[2] > 0, "MA", ""),
    "(",
    paste(coefs[coefs > 0], collapse = ", "),
    ")"
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

c_plot <- function(plots, row_titles, column_titles) {
  grid.draw(rbind(
    tableGrob(t(column_titles), rows = "", theme = ttheme_minimal()),
    cbind(
      tableGrob(row_titles, theme = ttheme_minimal()),
      arrangeGrob(grobs = plots, ncol = length(column_titles)),
      size = "last"
    ),
    size = "last"
  ))
}

c_pred_plot <- function(pred_vol, past_vol) {
  join_lists <- function(.x, .y) {
    if(is.list(.x)) map2(.x, .y, join_lists)
    else c(.x, .y)
  }

  t <- -(n_behind - 1):(n_ahead)

  lapply(
    join_lists(
      transpose(past_vol),
      transpose(pred_vol)
    ),
    function(models, i) {
      return(list(
        models$markov %>%
          tibble(t = t, value = .) %>%
          ggplot(aes(x = t, y = value)) +
            geom_line() +
            geom_vline(xintercept = 0, linetype = 2, alpha = 0.5) +
            labs(
              title = element_blank(),
              y = element_blank(),
              x = element_blank()
            ),
        models$garchx %>%
          tibble(t = t, value = .) %>%
          ggplot(aes(x = t, y = value)) +
            geom_line() +
            geom_vline(xintercept = 0, linetype = 2, alpha = 0.5) +
            labs(
              title = element_blank(),
              y = element_blank(),
              x = element_blank()
            )
      ))
    },
  ) %>%
    unlist(recursive = FALSE) %>%
    c_plot(
      tables_full_names,
      c("m. Markowa", "GARCH-X")
    )
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
  knitr.kable.NA = "–",
  digits = 4,
  scipen = 1
)

# dictionaries
model_params <- c(
  series = "Szer. czas.",
  model = "Model",
  regime = "Reżim",
  ar1 = "$a_1$",
  ar2 = "$a_2$",
  ar3 = "$a_3$",
  ma1 = "$b_1$",
  ma2 = "$b_2$",
  ma3 = "$b_3$",
  omega = "$\\omega$",
  alpha0 = "$\\omega$",
  alpha1 = "$\\alpha$",
  beta = "$\\beta$",
  beta1 = "$\\beta$",
  gamma1 = "$\\gamma$",
  alpha2 = "$\\gamma$",
  vxreg1 = "$\\lambda$",
  shape = "$\\nu$",
  nu = "$\\nu$",
  skew = "$\\xi$",
  xi = "$\\xi$"
)
