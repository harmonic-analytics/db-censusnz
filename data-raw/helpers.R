# Functions ---------------------------------------------------------------

.use_data_as_string = function(data, file_name, ...) {
  file_path <- usethis::proj_path("data", file_name, ext = "rda")
  dir.create(dirname(file_path), showWarnings = FALSE, recursive = TRUE)
  save <- purrr::partial(base::save, file = file_path, compress = "bzip2", compression_level = 1, version = 3, ...)
  assign(file_name, data)
  invisible(save(list = c(file_name)))
}

use_data_as_string = function(data, file_name, ...) {
  file_path <- usethis::proj_path("data", file_name, ext = "rda")
  dir.create(dirname(file_path), showWarnings = FALSE, recursive = TRUE)
  save <- purrr::partial(base::save, file = file_path, compress = "bzip2", compression_level = 1, version = 3, ...)
  assign(file_name, data)
  invisible(save(list = c(file_name)))
}


extract_variables <- function(x, var_list) {
  for (var_name in var_list) {
    if (substring(x, 1, nchar(var_name)) == var_name) {
      return (var_name)
    }
  }
  return (NA)
}

use_data <- function(...){
  file_name <- match.call(expand.dots = TRUE)[[2]]
  file_path <- usethis::proj_path("data", file_name, ext = "rda")
  dir.create(dirname(file_path), showWarnings = FALSE, recursive = TRUE)
  save <- purrr::partial(base::save, file = file_path, compress = "bzip2", compression_level = 1, version = 3)
  invisible(save(...))
}

save_geog_year <- function(geog_region, yr, data) {
  upper_geog <- toupper(geog_region)
  data_id <- paste(upper_geog, yr, sep="_")
  col_code <- paste(data_id, "CODE", sep="_")
  col_name <- paste(data_id, "NAME", sep="_")

  data %>%
    dplyr::filter(geog_area == geog_region) %>%
    dplyr::select(-c(year, geog_area)) %>%
    dplyr::rename(!!col_code:= area_code, !!col_name:= area_description) %>%
    use_data_as_string(file_name = data_id)
}

# Variables ---------------------------------------------------------------
individual_variables = c("usually_resident_population_count",
  "census_night_population_count",
  "Unit_record_data_source",
  "Sex",
  "Age_5_year_groups",
  "median_age_CURP",
  "Age_broad_groups",
  "Age_5_year_groups_by_sex",
  "Years_at_usual_residence",
  "Usual_residence_five_years_ago_indicator",
  "Usual_residence_one_year_ago_indicator",
  "Birthplace_NZ_overseas",
  "Birthplace_broad_geographic_areas",
  "Years_since_arrival_in_NZ",
  "Ethnicity_grouped_total_responses",
  "Languages_total_responses",
  "Maori_descent",
  "Religious_affiliation_total_response",
  "Smoking_status",
  "Difficulty_seeing",
  "Difficulty_hearing",
  "Difficulty_walking",
  "Difficulty_remembering",
  "Difficulty_washing",
  "Difficulty_communicating",
  "Legally_registered_relationship",
  "Partnership_status",
  "Individual_home_ownership",
  "Number_of_children_born",
  "Highest_qualification",
  "Study_participation",
  "Grouped_personal_income",
  "Total_personal_income",
  "Sources_of_personal_income_total_responses",
  "Travel_to_education_by_usual_residence_address",
  "Travel_to_education_by_education_address",
  "Work_and_labour_force_status",
  "Status_in_employment",
  "Occupation_by_usual_residence_address",
  "Occupation_by_workplace_address",
  "Industry_by_usual_residence_address",
  "Industry_by_workplace_address",
  "Hours_worked_per_week",
  "Travel_to_work_by_usual_residence_address",
  "Travel_to_work_by_workplace_address",
  "Unpaid_activities_total_responses")
