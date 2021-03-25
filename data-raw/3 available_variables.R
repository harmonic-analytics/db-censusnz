## code to prepare `available_variables` dataset goes here

# Setup -------------------------------------------------------------------
source('./data-raw/helpers.R')
library(magrittr)
try(tictoc::tic("load data time:")); devtools::load_all(); try(tictoc::toc())

# Prepare -----------------------------------------------------------------
# path <- system.file("dictionary.csv", package = "db.censusnz")
path <- "./data-raw/dictionary.csv"
dictionary <- read.csv(path) %>%
  tibble::as_tibble() %>%
  dplyr::mutate_if(is.character, stringi::stri_enc_toascii)

available_variables <- tibble::tribble(~geography, ~variable)
geographies <- c("DHB", "LBA", "RC", "SA1", "SA2", "TA", "WARD")
for(geography in geographies){
  data <- eval(parse(text = paste0("db.censusnz::", geography, "_2018")))
  available_variables <- dplyr::bind_rows(
    available_variables,
    data %>% dplyr::distinct(variable) %>% tibble::add_column(geography = geography, .before = 0)
  )
}

available_variables <- dplyr::left_join(available_variables, dictionary)

# Save --------------------------------------------------------------------
# Available variables
usethis::use_data(available_variables)

# Area hierarchy
area_hierarchy_2018 = geonz::get_area_hierarchy()
usethis::use_data(area_hierarchy_2018)
