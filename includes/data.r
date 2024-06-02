#### load ####
tables <- c("wig20", "pkn", "pko", "ebs", "dom", "sve")
tables_full_names <- setNames(
  c(
    "WIG20",
    "PKN Orlen",
    "PKO BP",
    "11 bit studios",
    "Dom Development",
    "Synthaverse"
  ),
  tables
)
tables_explainatory <- c("wig", "spx", "dax")

#### gather ####
data <-
  map(c(tables, tables_explainatory), function(table_name) {
    read.csv(c_paste_tight("data/", table_name, ".csv"), sep = ";") %>%
      as_tibble() %>%
      mutate(across(matches(c("Data")), as_date)) %>%
      mutate(index = table_name)
  }) %>%
  bind_rows()

garchx_periods <- list(
  c("4.03.2020", "1.07.2020", "wybuch pandemii koronawirusa w Polsce"),
  c("15.10.2020", "15.02.2021", "początek drugiego lockdownu w Polsce"),
  c("24.02.2022", "15.04.2022", "początek inwazji rosyjskiej na Ukrainie")
) %>%
  Filter(function(v) {
    dmy(v[1]) %within% interval(dmy(data_range[1]), dmy(data_range[2]))
  }, .)

data_split <-
  data %>%
    group_by(index) %>%
    nest() %>%
    mutate(data = map(data, function(d) {
      d %>%
        filter(Data %within% interval(
          dmy(data_range[1]), dmy(data_range[2])
        )) %>%
        mutate(
          return = log(Zamkniecie / lag(Zamkniecie)) * 100,
          is_crisis = Reduce(`|`, map(
            garchx_periods,
            ~ Data %within% interval(dmy(.x[1]), dmy(.x[2]))
          ))
        )
    })) %>%
    deframe()

returns_split <- data_split %>%
  map(~ pull(.x, return))
garchx_externals <- data_split %>%
  map(function(.x) {
    cols <- c(
      list(pull(.x, is_crisis) %>% as.numeric),
      returns_split[tables_explainatory] %>% map(coalesce, 0)
    )

    matrix(unlist(cols), ncol = length(cols))
  })
returns_split <- returns_split[tables]
