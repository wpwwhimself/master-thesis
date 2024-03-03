#### setup ####
source("includes/setup.r")
source("includes/data.r")

#### ARMA ####
map(
  returns_split,
  ~ custom_auto_arima(.x)
) %>%
  custom_save_rds("arma_aic")
map(
  returns_split,
  ~ custom_auto_arima(.x, ic = "bic")
) %>%
  custom_save_rds("arma_bic")

#### markov ####
arma <- custom_read_rds("arma_aic")

#### ! HEAVY FUNCTION ! ####
# gameplan
# 1. wyciągnąć reszty z modelu średniej
# 2. wstawić je do garcha
# 3. ...
# 4. profit?
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
    function(Var1, Var2){
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
    }
  ) %>%
    custom_save_rds(
      custom_paste_tight(
        "markov_", table_name
      )
    )
}
