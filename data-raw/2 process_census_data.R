### Script to prepare census data
### Matt Lie
### Last Updated: 19 Mar 2020

# Helpers -----------------------------------------------------------------
source('./data-raw/helpers.R')
extract_variables <- function(x, var_list) {
  for (var_name in var_list) {
    if (substring(x, 1, nchar(var_name)) == var_name) {
      return (var_name)
    }
  }
  return (NA)
}

# Load Packages -----------------------------------------------------------
library(tidyverse)

# Importing Data ----------------------------------------------------------
download_dir = './data-raw/downloads'
census_files = list.files(path = './data-raw/downloads', pattern  = '*.csv')
file_names = gsub('_totalNZ.*', '', census_files)

database <- list()
for (i in 1:length(census_files))
  database[[file_names[i]]] <-
  readr::read_csv(
    file = paste0(download_dir, '/', census_files[i]),
    guess_max = 100000,
    na = c('C', '..', '*')
  ) %>%
  dplyr::distinct(database)

# Clean and Join Individual Data ------------------------------------------
invisible(
  individual <- database$Individual_part1
  %>% dplyr::left_join(database$Individual_part2, by = c("Area_code_and_description", "Area_code", "Area_description"))
  %>% dplyr::left_join(database$Individual_part3a, by = c("Area_code_and_description", "Area_code", "Area_description"))
  %>% dplyr::left_join(database$Individual_part3b, by = c("Area_code_and_description", "Area_code", "Area_description"))
  %>% tidyr::pivot_longer(cols = -c("Area_code_and_description", "Area_code", "Area_description"))
)

# Separate the name into var and match
invisible(
  individual <- individual
  %>% dplyr::mutate(name = name %>% stringi::stri_enc_toascii() %>% gsub('\032', 'a', .))
  %>% dplyr::mutate(year = substring(name, nchar('Census_') + 1, nchar('Census_') + 4))
  %>% dplyr::mutate(name = substring(name, nchar('Census_') + 6))
)

(
  variable_names <- individual
  %>% dplyr::select(name)
  %>% dplyr::distinct()
)

variable_names$variable = lapply(X = variable_names$name, FUN = extract_variables, var_list = individual_variables)

(
  variable_names <- variable_names
  %>% dplyr::mutate(variable_group = substring(name, nchar(variable) + 2))
  %>% tidyr::unnest(variable)
)

individual <- dplyr::left_join(individual, variable_names, by = 'name')

# Add sorting capability for different geographic areas
individual <- individual %>%
  dplyr::mutate(geog_area = dplyr::case_when(
    nchar(Area_code) == 7 ~ 'SA1',
    nchar(Area_code) == 6 ~ 'SA2',
    nchar(Area_code) == 5 & stringr::str_sub(Area_description, start = -4) == 'Ward' ~ 'Ward',
    nchar(Area_code) == 5 & stringr::str_sub(Area_description, start = -4) == 'Area' ~ 'LBA',
    nchar(Area_code) == 3 ~ 'TA',
    nchar(Area_code) == 2 & stringr::str_sub(Area_description, start = -6) == 'Region' ~ 'RC',
    nchar(Area_code) == 2 & stringr::str_sub(Area_description, start = -6) != 'Region' ~ 'DHB',
    Area_description == 'Total NZ (Local Board Area (Auckland Region))' ~ 'LBA',
    Area_description == 'Total NZ (Statistical Area 1)' ~ 'SA1',
    Area_description == 'Total NZ (Statistical Area 2)' ~ 'SA2',
    Area_description == 'Total NZ (Ward)' ~ 'Ward',
    Area_description == 'Total NZ (Territorial Authority)' ~ 'TA',
    Area_description == 'Total NZ (Regional Council)' ~ 'RC',
    Area_description == 'Total NZ (District Health Board)' ~ 'DHB',
    TRUE ~ stringr::str_sub(Area_description, start = nchar('Total NZ (') + 1, end = -2)
  ))

# Remove some columns we don't need
invisible(
  individual <- individual
  %>% dplyr::select(geog_area,
                    Area_code,
                    Area_description,
                    year,
                    variable,
                    variable_group,
                    count = value)
)

# Create a table of the number of entries per area and per year
invisible(
  entries_count <- individual
  %>% dplyr::group_by(geog_area, year)
  %>% dplyr::tally()
  %>% tidyr::pivot_wider(id_cols = geog_area, names_from = year, values_from = n)
)

# Post Processing ---------------------------------------------------------
invisible(
  individual <- individual
  %>% dplyr::rename_all(list(~tolower(.)))
  %>% dplyr::mutate_at(c("variable", "variable_group"), ~tolower(.))
)

# Save --------------------------------------------------------------------
individual_2018 <- dplyr::filter(individual, year == 2018)

individual_ward_2018 = individual_2018 %>%
  dplyr::filter(geog_area == 'Ward') %>%
  dplyr::select(-c(year, geog_area)) %>%
  dplyr::rename(WARD_2018_CODE = area_code, WARD_2018_NAME = area_description)
usethis::use_data(individual_ward_2018, overwrite = TRUE)

individual_lba_2018 = individual_2018 %>%
  dplyr::filter(geog_area == 'LBA') %>%
  dplyr::select(-c(year, geog_area)) %>%
  dplyr::rename(LBA_2018_CODE = area_code, LBA_2018_NAME = area_description)
usethis::use_data(individual_lba_2018, overwrite = TRUE)

individual_ta_2018 = individual_2018 %>%
  dplyr::filter(geog_area == 'TA') %>%
  dplyr::select(-c(year, geog_area)) %>%
  dplyr::rename(TA_2018_CODE = area_code, TA_2018_NAME = area_description)
usethis::use_data(individual_ta_2018, overwrite = TRUE)

individual_dhb_2018 = individual_2018 %>%
  dplyr::filter(geog_area == 'DHB') %>%
  dplyr::select(-c(year, geog_area)) %>%
  dplyr::rename(DHB_2018_CODE = area_code, DHB_2018_NAME = area_description)
usethis::use_data(individual_dhb_2018, overwrite = TRUE)

individual_rc_2018 = individual_2018 %>%
  dplyr::filter(geog_area == 'RC') %>%
  dplyr::select(-c(year, geog_area)) %>%
  dplyr::rename(RC_2018_CODE = area_code, RC_2018_NAME = area_description)
usethis::use_data(individual_rc_2018, overwrite = TRUE)

individual_sa1_2018 = individual_2018 %>%
  dplyr::filter(geog_area == 'SA1') %>%
  dplyr::select(-c(year, geog_area)) %>%
  dplyr::rename(SA1_2018_CODE = area_code, SA1_2018_NAME = area_description)
usethis::use_data(individual_sa1_2018, overwrite = TRUE)

individual_sa2_2018 = individual_2018 %>%
  dplyr::filter(geog_area == 'SA2') %>%
  dplyr::select(-c(year, geog_area)) %>%
  dplyr::rename(SA2_2018_CODE = area_code, SA2_2018_NAME = area_description)
usethis::use_data(individual_sa2_2018, overwrite = TRUE)


# Post processing ---------------------------------------------------------
## Standardise column names

