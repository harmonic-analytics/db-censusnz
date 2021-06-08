# Setup -------------------------------------------------------------------
source('./data-raw/helpers.R')
library(magrittr)
library(openxlsx)
library(janitor)

# Importing Data ----------------------------------------------------------
# meshblock_dir = './data-raw/meshblock'
mb_files = list.files(path = './data-raw/meshblock', pattern  = '*.xlsx',
                      full.names = TRUE)

# try just one data
df_test <- read.xlsx(xlsxFile = mb_files[1],
                     sheet = "Meshblock",
                     startRow = 9,  # starting row
                     fillMergedCells = TRUE,  # if there is any merged cells, unmerge
                     na.strings = c("..", "..C"),  # define what is NA
                     colNames = TRUE     # if TRUE, the first row becomes the column name
)

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
