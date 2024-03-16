#### load ####
tables <- c("wig", "pkn", "pko", "ebs", "dom", "sve")
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

#### gather ####
data <-
  map(tables, function(table_name) {
    read.csv(c_paste_tight("data/", table_name, ".csv"), sep = ";") %>%
      as_tibble() %>%
      mutate(across(matches(c("Data")), as_date)) %>%
      mutate(index = table_name)
  }) %>%
  bind_rows()

garchx_periods <- list(
  c("1.03.2017", "1.05.2017", "powstanie Krajowej Administracji Skarbowej w Polsce"),
  c("4.03.2020", "1.06.2020", "wybuch pandemii koronawirusa w Polsce"),
  c("1.10.2020", "15.02.2021", "???"),
  c("1.4.2021", "31.05.2021", "???"),
  c("24.02.2022", "1.05.2022", "początek inwazji rosyjskiej na Ukrainie")
)

data_split <-
  data %>%
    group_by(index) %>%
    nest() %>%
    mutate(data = map(data, function(d) {
      # if (index %in% c("pkn", "dvl", "snt"))
      #   d <- d %>% tail(1000)
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
  map(~ pull(.x, is_crisis) %>% as.numeric)
