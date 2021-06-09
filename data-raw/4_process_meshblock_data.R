# Setup -------------------------------------------------------------------
source('./data-raw/helpers.R')
library(magrittr)
library(openxlsx)
library(janitor)

# Importing Data ----------------------------------------------------------
meshblock_dir = './data-raw/meshblock'
mb_files = list.files(path = meshblock_dir, pattern  = '*.xlsx',
                      full.names = FALSE)
file_names = gsub('.xlsx', '', mb_files)

# read the data in - took a while, about 8 mins
start <- Sys.time()
database <- list()
for (i in 1:length(mb_files))
    database[[file_names[i]]] <-
    read.xlsx(xlsxFile = paste(meshblock_dir, mb_files[i], sep="/"),
              sheet = "Meshblock",
              startRow = 9,  # starting row
              fillMergedCells = TRUE,  # if there is any merged cells, unmerge
              na.strings = c("..", "..C", "*"),  # define what is NA
              colNames = TRUE     # if TRUE, the first row becomes the column name
    )
end <- Sys.time()
end-start


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

