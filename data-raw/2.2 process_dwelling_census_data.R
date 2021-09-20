### Script to prepare dwellings census data
### Michael Soffe
### Last Updated: 13 September 2021

# Setup -------------------------------------------------------------------
source('./data-raw/helpers.R')
library(magrittr)

# Importing Data ----------------------------------------------------------
dwelling = readr::read_csv(
    file = './data-raw/downloads/Dwellings_totalNZ-wide_format_updated_16-7-20.csv',
    guess_max = 100000,
    na = c('C', '..', '*')
    ) %>%
    dplyr::distinct()

# # Clean Dwelling Data ------------------------------------------
dwelling = dwelling %>%
    tidyr::pivot_longer(cols = -c("Area_code_and_description", "Area_code", "Area_description")) %>%
    dplyr::mutate(name = name %>% stringi::stri_enc_toascii() %>% gsub('\032', 'a', .)) %>%
    dplyr::mutate(year = substring(name, nchar('Census_') + 1, nchar('Census_') + 4)) %>%
    dplyr::mutate(name = substring(name, nchar('Census_') + 6))

(
    dwelling_variable_names <- dwelling
    %>% dplyr::select(name)
    %>% dplyr::distinct()
)

dwelling_variable_names$variable = lapply(X = dwelling_variable_names$name, FUN = extract_variables, var_list = dwelling_variables)

(
    dwelling_variable_names <- dwelling_variable_names
    %>% dplyr::mutate(variable_group = substring(name, nchar(variable) + 2))
    %>% tidyr::unnest(variable)
)

dwelling <- dplyr::left_join(dwelling, dwelling_variable_names, by = 'name')

# Add sorting capability for different geographic areas
dwelling <- dwelling %>%
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
    dwelling <- dwelling
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
    dwelling_entries_count <- dwelling
    %>% dplyr::group_by(geog_area, year)
    %>% dplyr::tally()
    %>% tidyr::pivot_wider(id_cols = geog_area, names_from = year, values_from = n)
)

# Post Processing ---------------------------------------------------------
invisible(
    dwelling <- dwelling
    %>% dplyr::rename_all(list(~tolower(.)))
    %>% dplyr::mutate_at(c("variable", "variable_group"), ~tolower(.))
)

# Save --------------------------------------------------------------------

# 2006, 2013 and 2018 data
dwelling_2006 <- dplyr::filter(dwelling, year == 2006)
dwelling_2013 <- dplyr::filter(dwelling, year == 2013)
dwelling_2018 <- dplyr::filter(dwelling, year == 2018)

geogs = c("Ward", "LBA", "TA", "DHB", "RC", "SA1", "SA2")

for (geo in geogs){
    save_geog_year(geo, "dwelling", 2006, dwelling_2006)
    save_geog_year(geo, "dwelling", 2013, dwelling_2013)
    save_geog_year(geo, "dwelling", 2018, dwelling_2018)
}


