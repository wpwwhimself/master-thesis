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

arma <- c_read_rds("arma_aic")

#### markov ####

# fitting
for (table_name in tables) {
  pb <- c_progress_setup(
    paste("Fitting", table_name),
    nrow(models_for_testing)
  )

  series <-
    arma[[table_name]] %>%
    residuals()

  pmap(
    models_for_testing,
    possibly(
      function(volatility, distribution) {
        pb$tick()

        CreateSpec(
          variance.spec = list(model = rep(volatility, 2)),
          distribution.spec = list(distribution = rep(distribution, 2)),
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

#### GARCHX ####

# fitting
tables %>%
  map(function(table_name) {
    pb <- c_progress_setup(
      paste("Fitting", table_name),
      nrow(models_for_testing)
    )

    models_for_testing %>%
      pmap(function(volatility, distribution) {
        pb$tick()

        ugarchspec(
          variance.model = list(
            model = volatility,
            garchOrder = c(1, 1),
            external.regressors = as.matrix(garchx_externals)
          ),
          mean.model = list(
            armaOrder = arma[[table_name]]$arma[1:2],
            include.mean = FALSE
          ),
          distribution.model = distribution
        ) %>%
          ugarchfit(returns_split[[table_name]] %>% na.omit())
      }) %>%
        c_save_rds(
          c_paste_tight(
            "garchx_", table_name
          )
        )
  })
