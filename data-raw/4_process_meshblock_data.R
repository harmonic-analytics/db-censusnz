# Setup -------------------------------------------------------------------
source('./data-raw/helpers.R')
library(dplyr)
library(tidyr)
library(stringr)
library(stringi)
library(magrittr)
library(openxlsx)
library(janitor)

# function to clean the header (remove (), dots, etc)
fn_clean_header <- function(headername){
    cleaned_name = headername %>%
        stringi::stri_enc_toascii() %>%
        # remove () and inside of ()
        gsub("\\s*\\([^\\)]+\\)","", .) %>%
        # remove ". digit" at the end of the string
        gsub('.[[:digit:]]+$', '', .) %>%
        gsub(",.", ".", .) %>%
        gsub("..", ".", ., fixed = TRUE) %>%
        gsub(".Census", "", ., fixed = TRUE) %>%
        gsub("[.]$", "", .)
}

# clean the header, short version
fn_clean_header_short <- function(headername){
    cleaned_name = headername %>%
        stringi::stri_enc_toascii() %>%
        # remove the brackets and inside of the brackets
        gsub("\\s*\\([^\\)]+\\)","",.) %>%
        # if ending with ".digit", remove
        gsub('.[[:digit:]]+$', '', .) %>%
        gsub("Census.", "", ., fixed = TRUE)
}

# function to make longer format
fn_longer <- function(data){
    data %>%
        tidyr::pivot_longer(cols = 2:ncol(data),
                            names_to = "variable_group",
                            values_to = "count") %>%
        dplyr::mutate(x = stringr::str_split(variable_group, '_'),
                      x1 = sapply(x, '[[',1),
                      variable = sapply(x, '[[',2),
                      year = substring(x1, 1,4),
                      variable_name = stringr::str_split_fixed(x1, "\\.", 2)[,2]) %>%
        dplyr::select(meshblock, year, variable_name, variable, count)
}

fn_longer_v2 <- function(data, datapart){
    if(datapart ==1){
        data %>%
            tidyr::pivot_longer(cols = 2:ncol(.),
                                names_to = "variable_group",
                                values_to = "count") %>%
            dplyr::mutate(year = substring(variable_group, 1,4),
                          variable_name = substring(variable_group, 6, nchar(.)),
                          variable = NA) %>%
            dplyr::select(meshblock, year, variable_name, variable, count)
    }else{
        data %>%
            tidyr::pivot_longer(cols = 2:ncol(data),
                                names_to = "variable_group",
                                values_to = "count") %>%
            dplyr::mutate(x = stringr::str_split(variable_group, '_'),
                          x1 = sapply(x, '[[',1),
                          variable = sapply(x, '[[',2),
                          year = substring(x1, 1,4),
                          variable_name = stringr::str_split_fixed(x1, "\\.", 2)[,2]) %>%
            dplyr::select(meshblock, year, variable_name, variable, count)
    }
}

# storage of the cleaned data
database_clean <- list()

# Importing Data ----------------------------------------------------------
meshblock_dir = './data-raw/meshblock'
database <- readRDS(file = paste0(meshblock_dir, "/all_meshblockdata_list.rds"))

# Clean Dwelling data -----------------------------------------------------
dwell_header <- database$Dwelling %>%  names()
dwell_header <- fn_clean_header(dwell_header)

# clean the first row
database$Dwelling[1,] <- database$Dwelling[1,] %>%
    stringi::stri_enc_toascii() %>%
    # remove all ()
    gsub("\\s*\\([^\\)]+\\)","", .)  %>%
    gsub('\032', '', .) %>%
    gsub('\n', '', . ,fixed = TRUE) %>%
    gsub('size - ', 'size-', ., fixed = TRUE)

names(database$Dwelling) <- paste(dwell_header, database$Dwelling[1,], sep = "_")
database$Dwelling <- database$Dwelling[-1,]
names(database$Dwelling)[1] <- 'meshblock'

# To longer format
df_dwelling_long <- fn_longer_v2(database$Dwelling, 2)

# save it to new list
database_clean$Dwelling <- df_dwelling_long

# # impute confidential data
# database$Dwelling$variable_name %>%  unique()
# test2 = database$Dwelling %>%
#     mutate(c_as_na = ifelse(count == "..C", NA, count),
#            c_as_na = as.numeric(c_as_na)) %>%
#     filter(variable_name == "occupied.private.dwelling.type") %>%
#     dplyr::select(-count)  %>%
#     tidyr::pivot_wider(names_from = variable,
#                 values_from = c_as_na)
#
# # find the col number
# start_col = 4
# end_col = which(names(test2) == "Total") - 1
# test2 %>%
#     mutate(row_sum = rowSums(test2[, c(start_col:end_col)], na.rm = TRUE),
#            diff = Total - row_sum,
#            n_na = apply(test2[, c(start_col:end_col)], 1, function(x) sum(is.na(x))),
#            imp = diff/n_na) %>%  View()

# test %>%
#     group_by(meshblock, year, variable_name) %>%
#     mutate(total = max(c_as_na, na.rm = TRUE),
#            a = sum(c_as_na, na.rm = TRUE),
#            b = a - total,
#            leftover = total - b,
#            cell_n = n()-1) %>%





# test = database$Dwelling[1:15,]
# test %>%
#     mutate(c_as_na = ifelse(count == "..C", NA, count),
#            c_as_na = as.numeric(c_as_na),
#            non_total = ifelse(variable == "Total", "Yes", "No")) %>%
#     group_by(year, variable_name) %>%
#     mutate(aa = )


# Clean Family data -------------------------------------------------------
# database$Family %>% View()
fam_header <- database$Family %>%  names()

# separate the data
fam_overall <- database$Family[, c(1,2:4)]
fam_detail <- database$Family[, -(2:4)]

# clean the detailed data first
fam_dt_header <- fam_detail %>% names()
fam_dt_header <- fam_dt_header %>%
    fn_clean_header() %>%
    gsub('(grouped)', 'grouped', ., fixed = TRUE) %>%
    gsub('(total.responses)', 'total.responses', ., fixed = TRUE)
fam_detail[1,] <- fam_detail[1,] %>%
    gsub("\\s*\\([^\\)]+\\)","",.) %>%
    gsub('\n', '', ., fixed = TRUE) %>%
    gsub(" - ", "-", ., fixed = TRUE)

# join the header and the first row
names(fam_detail) <- paste(fam_dt_header, fam_detail[1,], sep = "_")
fam_detail <- fam_detail[-1,]
names(fam_detail)[1] <- 'meshblock'

# make longer format
df_fam_detailed_long <- fn_longer_v2(fam_detail, 2)

# cleand the overall data
names(fam_overall)[3:4] <- names(fam_overall)[2]
fam_overall[1,2:4] <- substring(fam_overall[1,2:4], 1,4)
names(fam_overall) <- paste(fam_overall[1,], names(fam_overall), sep =".")
fam_overall <- fam_overall[-1,]
names(fam_overall)[1] <- 'meshblock'
df_fam_overall_long <- fn_longer_v2(fam_overall, 1)

# join two data
if(ncol(df_fam_overall_long) == ncol(df_fam_detailed_long)){
    df_family <- dplyr::bind_rows(df_fam_overall_long, df_fam_detailed_long)
}else{
    stop("Cannot bind rows")
}

database_clean$Family <- df_family

# House (similar to family)-------------------------------------------------------------------------
house_header <- database$Household %>%  names()

# separate the data
house_overall <- database$Household[, c(1,2:4)]
house_detail <- database$Household[, -(2:4)]

# clean the detailed data first
house_dt_header <- house_detail %>% names()
house_dt_header <- house_dt_header %>%
    gsub('(grouped)', 'grouped', ., fixed = TRUE) %>%
    gsub('(total.responces)', 'total.responses', ., fixed = TRUE) %>%
    fn_clean_header()
# clean the first row
house_detail[1,] <- house_detail[1,] %>%
    gsub("\\s*\\([^\\)]+\\)","",.) %>%
    gsub('\n', '', ., fixed = TRUE) %>%
    gsub(' - ', '-', . , fixed = TRUE) %>%
    gsub('$500 -$599', '$500-$599', ., fixed = TRUE) %>%
    trimws(., "both")

# join the header and the first row
names(house_detail) <- paste(house_dt_header, house_detail[1,], sep = "_")
house_detail <- house_detail[-1,]
names(house_detail)[1] <- 'meshblock'

# make longer format
df_house_detail_long <- fn_longer_v2(house_detail, 2)


# cleand the overall data
names(house_overall)[3:4] <- names(house_overall)[2]
house_overall[1,2:4] <- substring(house_overall[1,2:4], 1,4)
names(house_overall) <- paste(house_overall[1,], names(house_overall), sep =".") %>%
    gsub(",.", ".", ., fixed = TRUE)
names(house_overall)[1] <- 'meshblock'
house_overall <- house_overall[-1,]
df_house_overall_long <- fn_longer_v2(house_overall, 1)

# join two data
# names(df_house_overall_long) == names(df_house_detail_long)
df_house <- dplyr::bind_rows(df_house_overall_long, df_house_detail_long)

# replace the database data
# database$Household <- df_house

database_clean$Household <- df_house

# Individual part 1 data -------------------------------------------------------------------------
# database$Individual_part1 %>%  View()
ind1_header <- database$Individual_part1 %>% names()

# find the first column that have year information
first_col = which(substring(ind1_header, 1, 4) %in% c("2013", "2006", "2018")) %>%  min()
first_col = first_col -1

# separate
ind_part1_overall = database$Individual_part1[, 1:first_col]
ind_part1_overall %>%  head()
ind_part1_detailed = database$Individual_part1[, -c(2:first_col)]
ind_part1_detailed %>%  head()

# tidy part 1 data
# ind_part1_overall %>%  View()
names(ind_part1_overall) <- fn_clean_header_short(names(ind_part1_overall))
ind_part1_overall[1,] <- ind_part1_overall[1,] %>% substr(., 1, 4)
names(ind_part1_overall) <- paste(ind_part1_overall[1,], names(ind_part1_overall), sep = ".")
names(ind_part1_overall)[1] <- "meshblock"
ind_part1_overall <- ind_part1_overall[-1,]

# tidy part 2 data
# ind_part1_detailed %>% View()
names(ind_part1_detailed) <- fn_clean_header(names(ind_part1_detailed))
ind_part1_detailed[1,] <- ind_part1_detailed[1,] %>% gsub("\\s*\\([^\\)]+\\)","",.)
names(ind_part1_detailed) <- paste(names(ind_part1_detailed), ind_part1_detailed[1,], sep = "_")
names(ind_part1_detailed)[1] <- "meshblock"
ind_part1_detailed <- ind_part1_detailed[-1,]

# longer format
ind_part1_overall_long <- fn_longer_v2(ind_part1_overall, 1)
ind_part1_detailed_long <- fn_longer_v2(ind_part1_detailed, 2)

# join two data
all(names(ind_part1_overall_long) == names(ind_part1_detailed_long))
df_individual_part1 <- dplyr::bind_rows(ind_part1_overall_long, ind_part1_detailed_long)

# save
database_clean$Individual_part1 <- df_individual_part1

# Individual part 2 data -------------------------------------------------------------------------
database$Individual_part2 %>% View()
ind2_header <- database$Individual_part2 %>% names()
ind2_header <- fn_clean_header(ind2_header)
database$Individual_part2[1,] <- database$Individual_part2[1,] %>%
    gsub("\\s*\\([^\\)]+\\)","",.) %>%
    gsub("\n", "", ., fixed = TRUE) %>%
    gsub(" - ", "-", ., fixed = TRUE) %>%
    gsub(" / ", "/", ., fixed = TRUE)
names(database$Individual_part2) <- paste(ind2_header, database$Individual_part2[1,], sep = "_")
names(database$Individual_part2)[1] <- "meshblock"
df_individual_part2 <- database$Individual_part2[-1,]
View(df_individual_part2)

df_individual_part2_longer <- fn_longer_v2(df_individual_part2, 2)

# Individual part 3a data -------------------------------------------------------------------------
database$`Individual_part3(a)` %>% View()
ind3a_header <- database$`Individual_part3(a)` %>% names()
ind3a_header <- fn_clean_header(ind3a_header)
database$`Individual_part3(a)`[1,] <- database$`Individual_part3(a)`[1,] %>%
    gsub("\\s*\\([^\\)]+\\)","",.) %>%
    gsub(" - ", "-", ., fixed = TRUE)
names(database$`Individual_part3(a)`) <- paste(ind3a_header, database$`Individual_part3(a)`[1,], sep = "_")
names(database$`Individual_part3(a)`)[1] <- "meshblock"
df_individual_part3a <- database$`Individual_part3(a)`[-1,]
df_individual_part3a_longer <- fn_longer_v2(df_individual_part3a, 2)

# Individual part 3b data -------------------------------------------------------------------------
database$`Individual_part3(b)` %>%  View()
ind3b_header <- database$`Individual_part3(b)` %>% names()
ind3b_header <- fn_clean_header(ind3b_header)
database$`Individual_part3(b)`[1,] <- database$`Individual_part3(b)`[1,] %>%
    gsub("\\s*\\([^\\)]+\\)","",.) %>%
    gsub(" - ", "-", ., fixed = TRUE)
names(database$`Individual_part3(b)`) <- paste(ind3b_header, database$`Individual_part3(b)`[1,], sep = "_")
names(database$`Individual_part3(b)`)[1] <- "meshblock"
df_individual_part3b <- database$`Individual_part3(b)`[-1,]
df_individual_part3b_longer <- fn_longer_v2(df_individual_part3b, 2)

# Individual part 4 data --------------------------------------------------
database$Individual_part4 %>%  View()
ind4_header <- database$Individual_part4 %>% names()
ind4_header <- fn_clean_header(ind4_header)
database$Individual_part4[1,] <- database$Individual_part4[1,] %>%
    gsub("\\s*\\([^\\)]+\\)","",.) %>%
    gsub(" - ", "-", ., fixed = TRUE)
names(database$Individual_part4) <- paste(ind4_header, database$Individual_part4[1,], sep = "_")
names(database$Individual_part4)[1] <- "meshblock"
df_individual_part4 <- database$Individual_part4[-1,]
df_individual_part4_longer <- fn_longer_v2(df_individual_part4, 2)
