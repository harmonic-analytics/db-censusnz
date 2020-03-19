### Script to prepare census data
### Matt Lie
### Last Updated: 19 Mar 2020


# Load Packages -----------------------------------------------------------




# Importing Data ----------------------------------------------------------

download_dir = './data-raw/downloads'
census_files = list.files(path = './data-raw/downloads', pattern  = '*.csv')
file_names = gsub('_totalNZ.*', '', census_files)

for (i in 1:length(census_files)) {
  df_temp = readr::read_csv(file = paste0(download_dir, '/', census_files[i]), guess_max = 100000, na = c('C', '..', '*')) %>% dplyr::distinct()
  assign(x = file_names[i], value = df_temp)
}

# rm(df_temp)

# Clean and Join Individual Data ------------------------------------------

individual = Individual_part1 %>%
  dplyr::left_join(Individual_part2, by = c("Area_code_and_description", "Area_code", "Area_description")) %>%
  dplyr::left_join(Individual_part3a, by = c("Area_code_and_description", "Area_code", "Area_description")) %>%
  dplyr::left_join(Individual_part3b, by = c("Area_code_and_description", "Area_code", "Area_description"))

numeric_vars = dplyr::setdiff(names(individual), c("Area_code_and_description", "Area_code", "Area_description"))

individual = individual %>%
  tidyr::pivot_longer(cols = -c("Area_code_and_description", "Area_code", "Area_description")) %>%
  dplyr::mutate(name = name %>% stringi::stri_enc_toascii() %>% gsub('\032', 'a', .))
#
# test = names(individual)
# test = test %>% stringi::stri_enc_toascii() %>% gsub('\032', 'a', .)
#
#
#
# individual_classes = sapply(individual, class) %>% as.data.frame()
# individual_empties = sapply(individual, function(x) sum(!is.na(x))) %>% as.data.frame()
#
#
# names(individual)[431] %>% stringi::stri_enc_toascii() %>% gsub('\032', 'a',.)
