#### setup ####
source("includes/setup.r")
source("includes/data.r")

#### ARMA ####
map(
  returns_split,
  ~ c_auto_arima(.x)
) %>%
  c_save_rds("arma_aic")
map(
  returns_split,
  ~ c_auto_arima(.x, ic = "bic")
) %>%
  c_save_rds("arma_bic")

#### markov ####
arma <- c_read_rds("arma_aic")

for (table_name in tables) {
  pb <- progress_bar$new(
    total = nrow(markov_models_for_testing_indices),
    format = paste("Fitting", table_name, "[:bar] :percent eta :eta"),
    clear = FALSE
  )

  series <-
    arma[[table_name]] %>%
    residuals()

  pmap(
    markov_models_for_testing_indices,
    possibly(
      function(Var1, Var2) {
        pb$tick()

        CreateSpec(
          variance.spec = list(model = c(
            markov_models_for_testing[Var1, ]$volatility,
            markov_models_for_testing[Var2, ]$volatility
          )),
          distribution.spec = list(distribution = c(
            markov_models_for_testing[Var1, ]$distribution,
            markov_models_for_testing[Var2, ]$distribution
          )),
          switch.spec = list(do.mix = FALSE, K = NULL)
        ) %>%
          FitML(series)
      },
      otherwise = NULL
    )
  ) %>%
    c_save_rds(
      c_paste_tight(
        "markov_", table_name
      )
    )
}
