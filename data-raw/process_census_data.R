### Script to prepare census data
### Matt Lie
### Last Updated: 19 Mar 2020


# Load Packages -----------------------------------------------------------




# Importing Data ----------------------------------------------------------

download_dir = './data-raw/downloads'
census_files = list.files(path = './data-raw/downloads', pattern  = '*.csv')
file_names = gsub('_totalNZ.*', '', census_files)

for (i in 1:length(census_files)) {
  df_temp = readr::read_csv(
    file = paste0(download_dir, '/', census_files[i]),
    guess_max = 100000,
    na = c('C', '..', '*')
  ) %>% dplyr::distinct()
  assign(x = file_names[i], value = df_temp)
}

# rm(df_temp)

# Clean and Join Individual Data ------------------------------------------

individual = Individual_part1 %>%
  dplyr::left_join(
    Individual_part2,
    by = c("Area_code_and_description", "Area_code", "Area_description")
  ) %>%
  dplyr::left_join(
    Individual_part3a,
    by = c("Area_code_and_description", "Area_code", "Area_description")
  ) %>%
  dplyr::left_join(
    Individual_part3b,
    by = c("Area_code_and_description", "Area_code", "Area_description")
  ) %>%
  tidyr::pivot_longer(cols = -c("Area_code_and_description", "Area_code", "Area_description"))

# Separate the name into var and match

source('./data-raw/individual_vars.R')

extract_variables <- function(x, var_list) {
  for (var_name in var_list) {
    if (substring(x, 1, nchar(var_name)) == var_name) {
      return (var_name)
    }
  }
  return (NA)
}

individual = individual %>%
  dplyr::mutate(name = name %>% stringi::stri_enc_toascii() %>% gsub('\032', 'a', .)) %>%
  dplyr::mutate(year = substring(name, nchar('Census_') + 1, nchar('Census_') + 4),
                name = substring(name, nchar('Census_') + 6))

var_names = individual %>%
  dplyr::select(name) %>%
  dplyr::distinct()

var_names$variable = lapply(X = var_names$name, FUN = extract_variables, var_list = individual_vars)
var_names = var_names %>%
  dplyr::mutate(var_group = substring(name, nchar(variable) + 2))

individual = individual %>%
  dplyr::left_join(var_names, by = 'name')

# Create the names group, do the lapply on those, along with the var_group extraction, then do a left join back onto the main table


# Set up for names




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
# numeric_vars = dplyr::setdiff(
#   names(individual),
#   c("Area_code_and_description", "Area_code", "Area_description")
# )
