## Reading the meshblock data at once and save it as rds.

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

# read the data in - took a while, about 8-9 mins
start <- Sys.time()
database <- list()
for (i in 1:length(mb_files))
    database[[file_names[i]]] <-
    read.xlsx(xlsxFile = paste(meshblock_dir, mb_files[i], sep="/"),
              sheet = "Meshblock",
              startRow = 9,  # starting row
              fillMergedCells = TRUE,  # if there is any merged cells, unmerge
              na.strings = c("..", "*"),  # define what is NA
              colNames = TRUE     # if TRUE, the first row becomes the column name
    )
end <- Sys.time()
end-start

# save the database list
saveRDS(database, file = paste0(meshblock_dir, "/all_meshblockdata_list.rds"))
