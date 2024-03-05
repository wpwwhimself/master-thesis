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

# fitting
for (table_name in tables) {
  pb <- c_progress_setup(
    paste("Fitting", table_name),
    nrow(markov_models_for_testing_indices)
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

# optimizing
markov_chosen_ids <- list(
  "wig20" = c(2, 8),
  "pkn" = c(1, 2),
  "pko" = c(7, 2),
  "ebs" = c(11, 4),
  "dvl" = c(6, 4),
  "snt" = c(10, 6)
)
markov_chosen_big_id <-
  markov_chosen_ids %>%
  map(
    ~ markov_models_for_testing_indices %>%
      mutate(id = seq_len(nrow(markov_models_for_testing_indices))) %>%
      filter(Var1 == .x[1], Var2 == .x[2]) %>%
      pull(id)
  )

pb <- c_progress_setup("Checking", length(tables))
map(
  tables,
  function(table_name) {
    pb$tick()
    model <- c_read_rds(
      c_paste_tight(
        "markov_", table_name
      )
    )[[markov_chosen_big_id[[table_name]]]]

    params_to_remove <- c_markov_get_insignif(model)

    if (length(params_to_remove) > 0) {
      model <-
        CreateSpec(
          variance.spec = list(model = c(
            markov_models_for_testing[
              markov_chosen_ids[[table_name]][1],
            ]$volatility,
            markov_models_for_testing[
              markov_chosen_ids[[table_name]][2],
            ]$volatility
          )),
          distribution.spec = list(distribution = c(
            markov_models_for_testing[
              markov_chosen_ids[[table_name]][1],
            ]$distribution,
            markov_models_for_testing[
              markov_chosen_ids[[table_name]][2],
            ]$distribution
          )),
          switch.spec = list(do.mix = FALSE, K = NULL),
          constraint.spec = list(
            fixed = c_list_with_names(
              params_to_remove,
              rep(0, length(params_to_remove))
            )
          )
        ) %>%
          FitML(
            arma[[table_name]] %>%
              residuals()
          )
    }

    return(model)
  }
) %>%
  setNames(tables) %>%
  c_save_rds("markov_fitting")

# final
map(
  tables,
  function(table_name) {
    model <- c_read_rds(
      c_paste_tight(
        "markov_", table_name
      )
    )[[markov_chosen_big_id[[table_name]]]]

    return(model)
  }
) %>%
  setNames(tables) %>%
  c_save_rds("markov")
