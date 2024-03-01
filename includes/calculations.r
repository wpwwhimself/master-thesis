#### setup ####
source("includes/setup.r")
source("includes/data.r")


#### markov ####
# tworzy wszystkie kombinacje modeli dla jednego wariantu
models_for_testing <-
  list(
    volatility = c("sGARCH", "eGARCH"),
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
    FitML(wig20 %>% pull(return) %>% na.omit()) #TODO przeprowadzić dla wszystkich serii
) %>%
  saveRDS(models, "includes/calculations/markov_wig20.rds")
