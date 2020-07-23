## code to prepare `available_variables` dataset goes here

# Setup -------------------------------------------------------------------
source('./data-raw/helpers.R')
library(magrittr)
try(tictoc::tic("load data time:")); devtools::load_all(); try(tictoc::toc())

# Save --------------------------------------------------------------------
path <- system.file("available_variables.csv", package = "db.censusnz")
(
  available_variables <- read.csv(path)
  %>% tibble::as_tibble()
  %>% dplyr::mutate_if(is.character, stringi::stri_enc_toascii)
)
use_data(available_variables)
