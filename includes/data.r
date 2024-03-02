#### load ####
tables <- c("wig20", "pkn", "pko", "ebs", "dvl", "snt")
tables_full_names <- setNames(
  c(
    "WIG20",
    "PKN Orlen",
    "PKO BP",
    "11 bit studios",
    "Develia",
    "Synektik"
  ),
  tables
)
for (i in seq_along(tables)) {
  assign(
    tables[i],
    read.csv(paste("data/", tables[i], ".csv", sep = ""), sep = ";") %>%
      mutate(return = log(Zamkniecie / lag(Zamkniecie)) * 100) %>%
      mutate(across(matches(c("Data")), as_date)) %>%
      mutate(index = tables[i])
  )
}

#### gather ####
data <- bind_rows(wig20, pkn, pko, ebs, dvl, snt) %>% as_tibble()
returns_split <-
  data %>%
    group_by(index) %>%
    nest() %>%
    mutate(data = map(data, ~.x %>% pull(return))) %>%
    deframe()
# names(returns_split) <- tables
