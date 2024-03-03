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
# tworzy wszystkie kombinacje modeli dla jednego wariantu
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
  mutate(model_name = paste(volatility, distribution)) %>%
  select(model_name) %>%
  c() %>%
  unlist() %>%
  unname()

# indeksuje w/w warianty i tworzy pary tych modeli
models_for_testing_indices <-
  models_for_testing_names %>%
  seq_along() %>%
  replicate(2, ., simplify = FALSE) %>%
  expand.grid() %>%
  as_tibble()

#### ! HEAVY FUNCTION ! ####
# gameplan
# 1. wyciągnąć współczynniki z arma
# 2. wstawić je do createspec
# 3. ...
# 4. profit?
for (i in seq_along(tables)) {
  message(paste("Now processing:", tables[i]))

  arma[[tables[i]]] %>%
    coef() %>%
    CreateSpecs(
      variance.spec = list(model = c("sGARCH", "sGARCH")),
      distribution.spec = list(model = c("norm", "norm")),
      mean.spec = list()
    )
    print()
  # pmap(
  #   models_for_testing_indices,
  #   ~ CreateSpec(
  #     variance.spec = list(model = c(
  #       models_for_testing[..1, ]$volatility,
  #       models_for_testing[..2, ]$volatility
  #     )),
  #     distribution.spec = list(distribution = c(
  #       models_for_testing[..1, ]$distribution,
  #       models_for_testing[..2, ]$distribution
  #     )),
  #     switch.spec = list(do.mix = FALSE, K = NULL)
  #   ) %>%
  #     FitML(
  #       get(tables[i]) %>%
  #         pull(return) %>%
  #         na.omit()
  #     )
  # ) %>%
  #   saveRDS(custom_paste_tight(
  #     "includes/calculations/markov_",
  #     tables[i],
  #     ".rds"
  #   ))
}
