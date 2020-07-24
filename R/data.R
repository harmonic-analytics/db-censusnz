#' Data on Individuals from NZ Census 2018 at Statistical Area 1 Level
#'
#' A dataset containing the responses on individuals from the 2018 NZ Census
#' at the Statistical Area 1 level.
#'
#' @format A data frame with 14347200 rows and 5 variables:
#' \describe{
#'   \item{SA1_2018_CODE}{SA1 Code}
#'   \item{SA1_2018_NAME}{Name of the SA1}
#'   \item{variable}{Variable from Census}
#'   \item{variable_group}{Groups for the variable from Census}
#'   \item{count}{Number of people in the particular variable-group}
#'   ...
#' }
#' @source \url{https://www.stats.govt.nz/information-releases/statistical-area-1-dataset-for-2018-census-updated-march-2020}
"SA1"

#' Data on Individuals from NZ Census 2018 at Statistical Area 2 Level
#'
#' A dataset containing the responses on individuals from the 2018 NZ Census
#' at the Statistical Area 2 level.
#'
#' @format A data frame with 1081920 rows and 5 variables:
#' \describe{
#'   \item{SA2_2018_CODE}{SA2 Code}
#'   \item{SA2_2018_NAME}{Name of the SA2}
#'   \item{variable}{Variable from Census}
#'   \item{variable_group}{Groups for the variable from Census}
#'   \item{count}{Number of people in the particular variable-group}
#'   ...
#' }
#' @source \url{https://www.stats.govt.nz/information-releases/statistical-area-1-dataset-for-2018-census-updated-march-2020}"
"SA2"

#' Data on Individuals from NZ Census 2018 at Ward Level
#'
#' A dataset containing the responses on individuals from the 2018 NZ Census
#' at the Ward level.
#'
#' @format A data frame with 118080 rows and 5 variables:
#' \describe{
#'   \item{WARD_2018_CODE}{Ward Code}
#'   \item{WARD_2018_NAME}{Name of the Ward}
#'   \item{variable}{Variable from Census}
#'   \item{variable_group}{Groups for the variable from Census}
#'   \item{count}{Number of people in the particular variable-group}
#'   ...
#' }
#' @source \url{https://www.stats.govt.nz/information-releases/statistical-area-1-dataset-for-2018-census-updated-march-2020}
"WARD"

#' Data on Individuals from NZ Census 2018 at Local Board Authority Level
#'
#' A dataset containing the responses on individuals from the 2018 NZ Census
#' at the Local Board Authority level.
#'
#' @format A data frame with 10560 rows and 5 variables:
#' \describe{
#'   \item{LBA_2018_CODE}{Local Board Authority Code}
#'   \item{LBA_2018_NAME}{Name of the Local Board Authority}
#'   \item{variable}{Variable from Census}
#'   \item{variable_group}{Groups for the variable from Census}
#'   \item{count}{Number of people in the particular variable-group}
#'   ...
#' }
#' @source \url{https://www.stats.govt.nz/information-releases/statistical-area-1-dataset-for-2018-census-updated-march-2020}
'LBA'

#' Data on Individuals from NZ Census 2018 at Territorial Authority Level
#'
#' A dataset containing the responses on individuals from the 2018 NZ Census
#' at the Territorial Authority level.
#'
#' @format A data frame with 33120 rows and 5 variables:
#' \describe{
#'   \item{TA_2018_CODE}{Territorial Authority Code}
#'   \item{TA_2018_NAME}{Name of the Territorial Authority}
#'   \item{variable}{Variable from Census}
#'   \item{variable_group}{Groups for the variable from Census}
#'   \item{count}{Number of people in the particular variable-group}
#'   ...
#' }
#' @source \url{https://www.stats.govt.nz/information-releases/statistical-area-1-dataset-for-2018-census-updated-march-2020}
'TA'

#' Data on Individuals from NZ Census 2018 at District Health Board Level
#'
#' A dataset containing the responses on individuals from the 2018 NZ Census
#' at the District Health Board level.
#'
#' @format A data frame with 10560 rows and 5 variables:
#' \describe{
#'   \item{DHB_2018_CODE}{District Health Board Code}
#'   \item{DHB_2018_NAME}{Name of the District Health Board}
#'   \item{variable}{Variable from Census}
#'   \item{variable_group}{Groups for the variable from Census}
#'   \item{count}{Number of people in the particular variable-group}
#'   ...
#' }
#' @source \url{https://www.stats.govt.nz/information-releases/statistical-area-1-dataset-for-2018-census-updated-march-2020}
'DHB'

#' Data on Individuals from NZ Census 2018 at Regional Council Level
#'
#' A dataset containing the responses on individuals from the 2018 NZ Census
#' at the Regional Council level.
#'
#' @format A data frame with 8640 rows and 5 variables:
#' \describe{
#'   \item{RC_2018_CODE}{Regional Council Code}
#'   \item{RC_2018_NAME}{Name of the Regional Council}
#'   \item{variable}{Variable from Census}
#'   \item{variable_group}{Groups for the variable from Census}
#'   \item{count}{Number of people in the particular variable-group}
#'   ...
#' }
#' @source \url{https://www.stats.govt.nz/information-releases/statistical-area-1-dataset-for-2018-census-updated-march-2020}
'RC'

#' Hierarchy of geographical areas for 2018 NZ Census
#'
#' A dataset containing the hierarchy of geographic areas for SA1s from the 2018 NZ Census.
#'
#' @format A data frame with 29889 rows and 8 variables:
#' \describe{
#'   \item{SA1_2018_NAME}{Name of SA1}
#'   \item{SA2_2018_CODE}{Code of SA2}
#'   \item{SA2_2018_NAME}{Name of SA2}
#'   \item{TA_2018_CODE}{Code of Territorial Authority}
#'   \item{TA_2018_NAME}{Name of Territorial Authority}
#'   \item{RC_2018_CODE}{Code of Regional Council}
#'   \item{RC_2018_NAME}{Name of Regional Council}
#'   \item{LANDWATER_NAME}{Landwater category of the SA1}
#'   ...
#' }
#' @source \url{https://datafinder.stats.govt.nz/data/category/annual-boundaries/2018}
'area_hierarchy'

#' A dictionary of the available variables
#' @references \href{https://www.stats.govt.nz/information-releases/statistical-area-1-dataset-for-2018-census-updated-march-2020}{Available Variables}
"DICTIONARY"
