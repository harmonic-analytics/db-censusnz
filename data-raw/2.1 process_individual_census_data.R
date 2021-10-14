### Script to prepare individual census data
### Matt Lie / Michael Soffe
### Last Updated: 13 September 2021
#' compression_level = 1 | load time -> 25 sec
#' compression_level = 6 | load time -> 99 sec

# Setup -------------------------------------------------------------------
source('./data-raw/helpers.R')
library(magrittr)

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
  dplyr::distinct()

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
  individual_variable_names <- individual
  %>% dplyr::select(name)
  %>% dplyr::distinct()
)

individual_variable_names$variable = lapply(X = individual_variable_names$name, FUN = extract_variables, var_list = individual_variables)

(
  individual_variable_names <- individual_variable_names
  %>% dplyr::mutate(variable_group = substring(name, nchar(variable) + 2))
  %>% tidyr::unnest(variable)
)

individual <- dplyr::left_join(individual, individual_variable_names, by = 'name')

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

# 2006, 2013 and 2018 data
individual_2006 <- dplyr::filter(individual, year == 2006)
individual_2013 <- dplyr::filter(individual, year == 2013)
individual_2018 <- dplyr::filter(individual, year == 2018)

geogs = c("Ward", "LBA", "TA", "DHB", "RC", "SA1", "SA2")

for (geo in geogs){
  save_geog_year(geo, "individual", 2006, individual_2006)
  save_geog_year(geo, "individual", 2013, individual_2013)
  save_geog_year(geo, "individual", 2018, individual_2018)
}
