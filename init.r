{
  #### engage calculation environment ####
  source("includes/setup.r")
  source("includes/data.r")

  #### rerun calculations ####
  source("includes/calculations.r")

  #### build document ####
  bookdown::render_book()
}
