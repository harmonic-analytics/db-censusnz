# Setup -------------------------------------------------------------------
source('./data-raw/helpers.R')
library(magrittr)
library(openxlsx)
library(janitor)


# function to clean the header (remove (), dots, etc)
fn_clean_header <- function(headername){
    cleaned_name = headername %>%
        # remove () and inside of ()
        gsub("\\s*\\([^\\)]+\\)","", .) %>%
        # remove ". digit" at the end of the string
        gsub('.[[:digit:]]+$', '', .) %>%
        gsub(",.", ".", .) %>%
        gsub("..", ".", ., fixed = TRUE) %>%
        gsub(".Census", "", ., fixed = TRUE) %>%
        gsub("[.]$", "", .)
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


# storage of the cleaned data
database_clean <- list()

# Importing Data ----------------------------------------------------------
meshblock_dir = './data-raw/meshblock'
database <- readRDS(file = paste0(meshblock_dir, "/all_meshblockdata_list.rds"))


# Clean Dwelling data -----------------------------------------------------
# clean the header
header_name <- database$Dwelling %>%  names()
header_name <- header_name %>%
    stringi::stri_enc_toascii() %>%
    # remove all ()
    gsub("\\s*\\([^\\)]+\\)","", .) %>%
    gsub(",.", ".", .) %>%
    gsub("..", ".", ., fixed = TRUE) %>%
    gsub(".Census", "", ., fixed = TRUE) %>%
    gsub("[.]$", "", .)

# clean the first row
database$Dwelling[1,] <- database$Dwelling[1,] %>%
    stringi::stri_enc_toascii() %>%
    # remove all ()
    gsub("\\s*\\([^\\)]+\\)","", .)  %>%
    gsub('\032', '', .) %>%
    gsub('\n', '', . ,fixed = TRUE) %>%
    gsub('size - ', 'size-', ., fixed = TRUE)

names(database$Dwelling) <- paste(header_name, database$Dwelling[1,], sep = "_")
database$Dwelling <- database$Dwelling[-1,]
names(database$Dwelling)[1] <- 'meshblock'

database$Dwelling %>%  View()

# To longer format
database$Dwelling <- database$Dwelling %>%
    tidyr::pivot_longer(cols = 2:ncol(.),
                        names_to = "variable_group",
                        values_to = "count") %>%
    dplyr::mutate(x = stringr::str_split(variable_group, '_'),
                  x1 = sapply(x, '[[',1),
                  variable = sapply(x, '[[',2),
                  year = substring(x1, 1,4),
                  variable_name = stringr::str_split_fixed(x1, "\\.", 2)[,2]) %>%
    dplyr::select(meshblock, year, variable_name, variable, count)

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

database_clean$Dwelling <- database$Dwelling

# Clean Family data -------------------------------------------------------
fam_header <- database$Family %>%  names()

# separate the data
fam_overall <- database$Family[, c(1,2:4)]
fam_detail <- database$Family[, -(2:4)]

# clean the detailed data first
fam_dt_header <- fam_detail %>% names()
fam_dt_header <- fam_dt_header %>%
    stringi::stri_enc_toascii() %>%
    gsub('(grouped)', 'grouped', ., fixed = TRUE) %>%
    gsub('(total.responses)', 'total.responses', ., fixed = TRUE) %>%
    fn_clean_header()

fam_detail[1,] <- fam_detail[1,] %>%
    gsub("\\s*\\([^\\)]+\\)","",.) %>%
    gsub('\n', '', ., fixed = TRUE)

# join the header and the first row
names(fam_detail) <- paste(fam_dt_header, fam_detail[1,], sep = "_")
fam_detail <- fam_detail[-1,]
names(fam_detail)[1] <- 'meshblock'

# make longer format
fam_detail <- fn_longer(fam_detail)

# cleand the overall data
names(fam_overall)[3:4] <- names(fam_overall)[2]
fam_overall[1,2:4] <- substring(fam_overall[1,2:4], 1,4)
names(fam_overall) <- paste(fam_overall[1,], names(fam_overall), sep =".")
fam_overall <- fam_overall[-1,]
names(fam_overall)[1] <- 'meshblock'
fam_overall <- fam_overall %>%
    tidyr::pivot_longer(cols = 2:ncol(.),
                        names_to = "variable_group",
                        values_to = "count") %>%
    dplyr::mutate(year = substring(variable_group, 1,4),
                  variable_name = substring(variable_group, 6, nchar(.)),
                  variable = NA) %>%
    dplyr::select(meshblock, year, variable_name, variable, count)



# join two data
ncol(fam_overall) == ncol(fam_detail)
df_family <- dplyr::bind_rows(fam_overall, fam_detail)

# final clean
# df_family$variable_name %>%  unique()
# if variable_name finishes with .number, remove the number
df_family$variable_name <- gsub('.[[:digit:]]+', '', df_family$variable_name)

# # replace the database data
# database$Family <- df_family

database_clean$Family <- df_family

# House (similar to family)-------------------------------------------------------------------------
house_header <- database$Household %>%  names()

# separate the data
house_overall <- database$Household[, c(1,2:4)]
house_detail <- database$Household[, -(2:4)]


# clean the detailed data first
house_dt_header <- house_detail %>% names()
house_dt_header <- house_dt_header %>%
    stringi::stri_enc_toascii() %>%
    gsub('(grouped)', 'grouped', ., fixed = TRUE) %>%
    gsub('(total.responses)', 'total.responses', ., fixed = TRUE) %>%
    fn_clean_header()

house_detail[1,] <- house_detail[1,] %>%
    gsub("\\s*\\([^\\)]+\\)","",.) %>%
    gsub('\n', '', ., fixed = TRUE)

# join the header and the first row
names(house_detail) <- paste(house_dt_header, house_detail[1,], sep = "_")
house_detail<- house_detail[-1,]
names(house_detail)[1] <- 'meshblock'

# make longer format
house_detail <- fn_longer(house_detail)

# cleand the overall data
names(house_overall)[3:4] <- names(house_overall)[2]
house_overall[1,2:4] <- substring(house_overall[1,2:4], 1,4)
names(house_overall) <- paste(house_overall[1,], names(house_overall), sep =".")
house_overall <- house_overall[-1,]
names(house_overall)[1] <- 'meshblock'
house_overall <- house_overall%>%
    tidyr::pivot_longer(cols = 2:ncol(.),
                        names_to = "variable_group",
                        values_to = "count") %>%
    dplyr::mutate(year = substring(variable_group, 1,4),
                  variable_name = substring(variable_group, 6, nchar(.)),
                  variable = NA) %>%
    dplyr::select(meshblock, year, variable_name, variable, count)

# join two data
ncol(house_overall) == ncol(house_detail)
df_house <- dplyr::bind_rows(house_overall, house_detail)

# final clean
df_house$variable_name %>%  unique()
# if variable_name finishes with .number, remove the number
df_house$variable_name <- gsub('.[[:digit:]]+', '', df_house$variable_name)

# replace the database data
# database$Household <- df_house

database_clean$Household <- df_house

# Individual part 1 data -------------------------------------------------------------------------
database$Individual_part1 %>%  View()
ind1_header <- database$Individual_part1 %>% names()

# find the first column that have year information
first_col = which(substring(ind1_header, 1, 4) %in% c("2013", "2006", "2018")) %>%  min()
first_col = first_col -1

# separate
df_part1 = database$Individual_part1[, 1:first_col]
df_part1 %>%  head()
df_part2 = database$Individual_part1[, -c(2:first_col)]
df_part2 %>%  head()

# tidy part 1 data
df_part1 %>%  View()
# clean the header
fn_clean_header_short <- function(headername){
    cleaned_name = headername %>%
        # remove the brackets and inside of the brackets
        gsub("\\s*\\([^\\)]+\\)","",.) %>%
        # if ending with ".digit", remove
        gsub('.[[:digit:]]+$', '', .) %>%
        gsub("Census.", "", ., fixed = TRUE)
}
names(df_part1) <- fn_clean_header_short(names(df_part1))

df_part1[1,] <- df_part1[1,] %>% substr(., 1, 4)
names(df_part1) <- paste(df_part1[1,], names(df_part1), sep = "_")
names(df_part1)[1] <- "meshblock"
df_part1 <- df_part1[-1,]

# tidy part 2 data
# df_part2 %>% View()
names(df_part2) <- fn_clean_header(names(df_part2))
df_part2[1,] <- df_part2[1,] %>% gsub("\\s*\\([^\\)]+\\)","",.)
names(df_part2) <- paste(names(df_part2), df_part2[1,], sep = "_")
names(df_part2)[1] <- "meshblock"
df_part2 <- df_part2[-1,]

# longer format

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

df_part1_long <- fn_longer_v2(df_part1, 1)
df_part2_long <- fn_longer_v2(df_part2, 2)

# join two data
ncol(df_part1_long) == ncol(df_part2_long)
df_individual_part1 <- dplyr::bind_rows(df_part1_long, df_part2_long)

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

# -------------------------------------------------------------------------


ind3a_header <- database$`Individual_part3(a)` %>% names()
ind3bheader <- database$`Individual_part3(b)` %>% names()
ind4_header <- database$Individual_part4 %>% names()

substring(house_header, 1, 4) %>% unique()
substring(ind4_header, 1, 4) %>% unique()


# clean the header first
df_test %>%  names()
# remove the brackets
names(data) <- gsub("\\s*\\([^\\)]+\\)","",names(data))
# replace ",." to "."
names(data) <- gsub(",.", ".", names(data))
# replace ".Census." to "_"
names(data) <- gsub(".Census.", "_", names(data))




# get rid of "." and "," and "(8)(18)" things
names(df_test) <- gsub("\\([^\\]]*\\)", "", names(df_test), perl=TRUE)
# get rid of ","
names(df_test) <- gsub(",", "", names(df_test))
# get rid off the full stop at the end
names(df_test) <- sub("[.]$", "", names(df_test))
names(df_test) %>%  unique()

colname <- names(df_test)[2]
category_name  <- gsub('.*/ ?(\\w+)', '\\1', mb_files[1])
category_name <- gsub("\\..*", "", category_name)
col_id <- c(1, grep(colname, names(df_test)))
df_test2 <- df_test[, col_id]
df_test2 %>%  head()
df_test2 <- df_test2 %>%
    janitor::row_to_names(row_number = 1) %>%
    tidyr::pivot_longer(cols = 2:ncol(.),
                        names_to = "variable_group",
                        values_to = "count") %>%
    dplyr::mutate(variable = colname,
                  year = as.numeric(substr(variable, 1, 4)),
                  variable = sub("[0-9]+.?([A-Za-z]+.)", "\\2", colname),
                  variable = gsub("\\.", "_", variable),
                  variable_group = tolower(variable_group),
                  variable_group = gsub(" ", "_", variable_group),
                  category= category_name)

names(df_test2)[1] <- "meshblock"

# as in function
# read the data
mb_files
file_names = gsub('./data-raw/meshblock/', '', mb_files)
file_names = gsub('.xlsx', '', file_names)
mb_len <- length(file_names)

data = read.xlsx(xlsxFile = mb_files[i],
                 sheet = "Meshblock",
                 startRow = 9,  # starting row
                 fillMergedCells = TRUE,  # if there is any merged cells, unmerge
                 na.strings = c("..", "..C"),  # define what is NA
                 colNames = TRUE     # if TRUE, the first row becomes the column name
)

# clean the header first
names(data)
# remove the brackets
names(data) <- gsub("\\s*\\([^\\)]+\\)","",names(data))
# replace ",." to "."
names(data) <- gsub(",.", ".", names(data))
# replace ".Census." to "_"
names(data) <- gsub(".Census.", "_", names(data))

# clean the first row of the data, remove ( )
data[1,] <- gsub("\\s*\\([^\\)]+\\)","",data[1,])
# remove '\n'
data[1,] <- gsub('\n', '', data[1,])
names(data) <- paste(names(data), data[1,], sep = "_")

data2 <- data
data2 <- data2[-1,]
names(data2)[1] <- "meshblock"

clean_data = data2 %>%
    # janitor::row_to_names(row_number = 1) %>%
    # janitor::clean_names() %>%
    tidyr::pivot_longer(cols = 2:ncol(.),
                        names_to = "variable_group",
                        values_to = "count")
df1 <- clean_data %>%
    dplyr::mutate(x = stringr::str_split(clean_data$variable_group, '_'),
                  year = sapply(x, '[[',1),
                  x2 = sapply(x, '[[',2),
                  x3 = sapply(x, '[[',3))
df2 <- df1 %>%
    dplyr::select("meshblock", "year", "x2", "x3", "count") %>%
    dplyr::mutate(x2 = gsub("\\.", "_", x2),
                  x3 = tolower(x3),
                  x3 = gsub(" ", "_", x3))



#########################
class(".–.")
database <- list()

for(i in 1:mb_len){
    # read the data
    data = read.xlsx(xlsxFile = mb_files[i],
                                sheet = "Meshblock",
                                startRow = 9,  # starting row
                                fillMergedCells = TRUE,  # if there is any merged cells, unmerge
                                na.strings = c("..", "..C"),  # define what is NA
                                colNames = TRUE     # if TRUE, the first row becomes the column name
    )

    mb_tidy_data = fn_wrangle_mb_data(data)


}


# make a function to add variables
fn_wrangle_mb_data <- function(data){
    data2 = data
    names(data2) = paste(names(data2), data2[1,], sep = "_")
    data2 = data2[-1, ]
    clean_data = data2 %>%
        # janitor::row_to_names(row_number = 1) %>%
        # janitor::clean_names() %>%
        tidyr::pivot_longer(cols = 2:ncol(.),
                            names_to = "variable_group",
                            values_to = "count") %>%
        dplyr::mutate(variable = colname,
                      year = as.numeric(substr(variable, 1, 4)),
                      variable = sub("[0-9]+.?([A-Za-z]+.)", "\\2", colname),
                      variable = gsub("\\.", "_", variable),
                      variable_group = tolower(variable_group),
                      vg = gsub("_*\\.", "", variable_group))
                      variable_group = gsub(" ", "_", variable_group),
                      category= category_name)
    names(clean_data)[1] <- "meshblock"
}

