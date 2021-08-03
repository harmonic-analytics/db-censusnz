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
database2 <- readRDS(file = paste0(meshblock_dir, "/meshblockdata_longformat_list.rds"))
database2 %>%  names()
save_data_dir <- "./data"

# functions ---------------------------------------------------------------
# function to separate data by year
split_by_year_fn <- function(data, category_name = "Individual", category_number){
    data = data %>%
        dplyr::mutate(variable_name = gsub("\\.", "_", variable_name)) %>%
        rename("variable_group" = "variable",
               "variable" = "variable_name") %>%
        mutate(category = category_name,
               subcategory = category_number)
    data_sep = data %>%
        group_by(year)
    sep_list = dplyr::group_split(data_sep)
    names(sep_list) = data$year %>% unique
    return(sep_list)
}


# Individual data 1 -------------------------------------------------------
df_ind1 <- database2[["Individual_part1"]]
# have the similar variable to SA1 data
df_ind1$variable_name %>%  unique()
df_ind1 <- df_ind1 %>%
    mutate(variable_name = gsub("\032", "a", variable_name, fixed = TRUE))
a_list <- split_by_year_fn(df_ind1, category_number = "1")

# a_list[["2018"]] %>%  View()


#  individual part 2 ------------------------------------------------------
df_ind2 <- database2[["Individual_part2"]]
df_ind2$variable_name %>%  unique()
b_list <- split_by_year_fn(df_ind2, category_number = "2")
# b_list[["2018"]] %>%  View()


#  individual part 3a ----------------------------------------------------
df_ind3a <- database2[["Individual_part3a"]]
df_ind3a$variable_name %>%  unique()
c_list <- split_by_year_fn(df_ind3a, category_number = "3a")


#  Individual part3b -----------------------------------------------------
df_ind3b <- database2[["Individual_part3b"]]
df_ind3b$variable_name %>%  unique()
d_list <- split_by_year_fn(df_ind3b, category_number = "3b")
# d_list[["2018"]] %>%  View()


# Individual part 4 -------------------------------------------------------
df_ind4 <- database2[["Individual_part4"]]
df_ind4$variable_name %>%  unique()
e_list <- split_by_year_fn(df_ind4, category_number = "4")
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
