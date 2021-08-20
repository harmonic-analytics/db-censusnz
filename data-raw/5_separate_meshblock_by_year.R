### Tidy meshblock data
### Aim: to have the same format as SA_1 data


# Setup -------------------------------------------------------------------
source('./data-raw/helpers.R')
library(dplyr)
library(tidyr)
library(stringr)
library(stringi)
library(magrittr)
library(openxlsx)
library(janitor)


# Importing Data ----------------------------------------------------------
meshblock_dir = './data-raw/meshblock'
database <- readRDS(file = paste0(meshblock_dir, "/meshblockdata_longformat_list.rds"))
database %>%  names()
save_data_dir <- "./data"
# join data to get the same variable name as in dictionary
df_mesh_vars <- read.csv('./data/meshblock_var.csv',
                         header=TRUE,
                         stringsAsFactors = FALSE)


# functions ---------------------------------------------------------------

# function to have the same variable as in dictionary
fn_correct_variables <- function(data, subcategory){
    newdata = data %>%
        mutate(variable_name = gsub("\\.", "_", variable_name),
               subcategory_m = subcategory)
    names(newdata)[3:4] = c("variable", "variable_name")
    fina_data = newdata %>%
        left_join(df_mesh_vars, by = "variable") %>%
        dplyr::select(meshblock, year, variable_dictionary,
                      variable_name, count, subcategory_m)
}

# function to separate data by year
split_by_year_fn <- function(data){
    data_sep = data %>%
        group_by(year)
    sep_list = dplyr::group_split(data_sep)
    names(sep_list) = unlist(sapply(sep_list,'[[',2) ) %>% unique()
    return(sep_list)
}

# Individual data 1 -------------------------------------------------------
df_ind1 <- database[["Individual_part1"]]
# have the similar variable to SA1 data
df_ind1$variable_name %>%  unique()
df_ind1 <- df_ind1 %>%
    mutate(variable_name = gsub("\032", "a", variable_name, fixed = TRUE))
df_ind1 <- fn_correct_variables(df_ind1, "1")

a_list <- split_by_year_fn(df_ind1)

# a_list[["2018"]] %>%  View()


#  individual part 2 ------------------------------------------------------
df_ind2 <- database[["Individual_part2"]]
df_ind2$variable_name %>%  unique()
df_ind2 <- fn_correct_variables(df_ind2, "2")

b_list <- split_by_year_fn(df_ind2)
# b_list[["2018"]] %>%  View()

#  individual part 3a ----------------------------------------------------
df_ind3a <- database[["Individual_part3a"]]
df_ind3a$variable_name %>%  unique()
df_ind3a <- fn_correct_variables(df_ind3a, "3a")

c_list <- split_by_year_fn(df_ind3a)


#  Individual part3b -----------------------------------------------------
df_ind3b <- database[["Individual_part3b"]]
df_ind3b$variable_name %>%  unique()
df_ind3b <- fn_correct_variables(df_ind3b, "3b")

d_list <- split_by_year_fn(df_ind3b)
# d_list[["2018"]] %>%  View()


# Individual part 4 -------------------------------------------------------
df_ind4 <- database[["Individual_part4"]]
df_ind4$variable_name %>%  unique()
df_ind4 <- fn_correct_variables(df_ind4, "4")

e_list <- split_by_year_fn(df_ind4)
# e_list[["2018"]] %>%  View()

# organise the data by year -----------------------------------------------
# a_list %>%  names()
# b_list %>%  names()
# c_list %>%  names()
# d_list %>%  names()
# e_list %>%  names()

df_2006 <- a_list[["2006"]]
df_2013 <- bind_rows(a_list[["2013"]], b_list[["2013"]]) %>%
    bind_rows(c_list[["2013"]]) %>%
    bind_rows(d_list[["2013"]]) %>%
    bind_rows(e_list[["2013"]])
df_2018 <- bind_rows(a_list[["2018"]], b_list[["2018"]]) %>%
    bind_rows(c_list[["2018"]]) %>%
    bind_rows(d_list[["2018"]]) %>%
    bind_rows(e_list[["2018"]])


#  save -------------------------------------------------------------------
# df_2006 %>% str()
# setdiff(df_2013$variable %>% unique(), df_2018$variable %>% unique())
# setdiff(df_2018$variable %>% unique(), df_2013$variable %>% unique())

save(df_2006, file = paste0(save_data_dir, "/MESH_2006.rda"))
save(df_2013, file = paste0(save_data_dir, "/MESH_2013.rda"))
save(df_2018, file = paste0(save_data_dir, "/MESH_2018.rda"))
