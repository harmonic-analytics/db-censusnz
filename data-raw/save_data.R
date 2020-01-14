# load packages
library(dplyr)
library(stringr)
library(sf)

# First import census data
source('~/projects/censusnz/data-raw/import_census.R', encoding = 'UTF-8')

# Next import geographic data
source('~/projects/censusnz/data-raw/import_geog.R')

# Combine sa1 census data with geographic data
sa1_2018 <- sa1_2018_temp %>%
  left_join(sa1_geog_temp, by = c("SA1_2018"))

# Save datasets
usethis::use_data(sa1_2018, overwrite = TRUE)
usethis::use_data(sa2_2018, overwrite = TRUE)
usethis::use_data(ward_2018, overwrite = TRUE)
usethis::use_data(akl_lba_2018, overwrite = TRUE)
usethis::use_data(ta_2018, overwrite = TRUE)
usethis::use_data(dhb_2018, overwrite = TRUE)
usethis::use_data(rc_2018, overwrite = TRUE)
