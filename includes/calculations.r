#### setup ####
source("includes/setup.r")
source("includes/data.r")


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
for (i in seq_along(tables)) {
  pmap(
    models_for_testing_indices,
    ~ CreateSpec(
      variance.spec = list(model = c(
        models_for_testing[..1, ]$volatility,
        models_for_testing[..2, ]$volatility
      )),
      distribution.spec = list(distribution = c(
        models_for_testing[..1, ]$distribution,
        models_for_testing[..2, ]$distribution
      )),
      switch.spec = list(do.mix = FALSE, K = NULL)
    ) %>%
      FitML(
        get(tables[i]) %>%
          pull(return) %>%
          na.omit()
      )
  ) %>%
    saveRDS(paste(
      "includes/calculations/markov_",
      tables[i],
      ".rds",
      collapse = ""
    ))
}
