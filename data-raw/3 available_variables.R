## code to prepare `available_variables` dataset goes here
devtools::load_all()
path <- system.file("available_variables.csv", package = "db.censusnz")
available_variables <- read.csv(path) %>% tibble::as_tibble()
usethis::use_data(available_variables, overwrite = TRUE)
