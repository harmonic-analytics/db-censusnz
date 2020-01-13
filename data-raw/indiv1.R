## code to prepare `DATASET` dataset goes here

#libraries
library(dplyr)

# download census files
download.file("https://www3.stats.govt.nz/2018census/sa1dataset2018/Statistical%20Area%201%20dataset%20for%20Census%202018%20%E2%80%93%20total%20New%20Zealand%20%E2%80%93%20CSV.zip",
              destfile = "downloads/2018_sa1_census.zip", mode = "wb")
unzip("downloads/2018_sa1_census.zip", exdir = "downloads/")

# import and tidy up census files
indiv1_raw <- read.csv("downloads/Individual_part1_totalNZ-wide_format.csv",
                       stringsAsFactors = FALSE, na.strings = c("C",".."))

# isolate just 2018 data
indiv1 <- indiv1_raw %>%
  filter(Area_Code != "total") %>%
  select(
    Area_code_and_description:Area_Description,
    matches(".*2018.*")
  ) %>%
  mutate(
    PropMale2018 = Census_2018_Sex_1_Male_CURP/Census_2018_Sex_total_Total_CURP,
    PropFemale2018 = Census_2018_Sex_2_Female_CURP/Census_2018_Sex_total_Total_CURP,
    Prop0to4_2018 = Census_2018_Age..5_year_groups_85_over_01_0.4.years_CURP/Census_2018_Age..5_year_groups_85_over_total_Total_CURP,
    Prop5to9_2018 = Census_2018_Age..5_year_groups_85_over_02_5.9.years_CURP/Census_2018_Age..5_year_groups_85_over_total_Total_CURP,
    Prop10to14_2018 = Census_2018_Age..5_year_groups_85_over_03_10.14.years_CURP/Census_2018_Age..5_year_groups_85_over_total_Total_CURP,
    Prop15to19_2018 = Census_2018_Age..5_year_groups_85_over_04_15.19.years_CURP/Census_2018_Age..5_year_groups_85_over_total_Total_CURP,
    Prop20to24_2018 = Census_2018_Age..5_year_groups_85_over_05_20.24.years_CURP/Census_2018_Age..5_year_groups_85_over_total_Total_CURP,
    Prop25to29_2018 = Census_2018_Age..5_year_groups_85_over_06_25.29.years_CURP/Census_2018_Age..5_year_groups_85_over_total_Total_CURP,
    Prop30to34_2018 = Census_2018_Age..5_year_groups_85_over_07_30.34.years_CURP/Census_2018_Age..5_year_groups_85_over_total_Total_CURP,
    Prop35to39_2018 = Census_2018_Age..5_year_groups_85_over_08_35.39.years_CURP/Census_2018_Age..5_year_groups_85_over_total_Total_CURP,
    Prop40to44_2018 = Census_2018_Age..5_year_groups_85_over_09_40.44.years_CURP/Census_2018_Age..5_year_groups_85_over_total_Total_CURP,
    Prop45to49_2018 = Census_2018_Age..5_year_groups_85_over_10_45.49.years_CURP/Census_2018_Age..5_year_groups_85_over_total_Total_CURP,
    Prop50to54_2018 = Census_2018_Age..5_year_groups_85_over_11_50.54.years_CURP/Census_2018_Age..5_year_groups_85_over_total_Total_CURP,
    Prop55to59_2018 = Census_2018_Age..5_year_groups_85_over_12_55.59.years_CURP/Census_2018_Age..5_year_groups_85_over_total_Total_CURP,
    Prop60to64_2018 = Census_2018_Age..5_year_groups_85_over_13_60.64.years_CURP/Census_2018_Age..5_year_groups_85_over_total_Total_CURP,
    Prop65to69_2018 = Census_2018_Age..5_year_groups_85_over_14_65.69.years_CURP/Census_2018_Age..5_year_groups_85_over_total_Total_CURP,
    Prop70to74_2018 = Census_2018_Age..5_year_groups_85_over_15_70.74.years_CURP/Census_2018_Age..5_year_groups_85_over_total_Total_CURP,
    Prop75to79_2018 = Census_2018_Age..5_year_groups_85_over_16_75.79.years_CURP/Census_2018_Age..5_year_groups_85_over_total_Total_CURP,
    Prop80to84_2018 = Census_2018_Age..5_year_groups_85_over_17_80.84.years_CURP/Census_2018_Age..5_year_groups_85_over_total_Total_CURP,
    Prop85andOver_2018 = Census_2018_Age..5_year_groups_85_over_18_85.years.and.over_CURP/Census_2018_Age..5_year_groups_85_over_total_Total_CURP,
    PropEuropean2018 = Census_2018_Ethnicity..grouped_level_1_1_European_CURP/Census_2018_Ethnicity..grouped_level_1_total_Total_CURP,
    PropMaori2018 = Census_2018_Ethnicity..grouped_level_1_2_MÄ.ori_CURP/Census_2018_Ethnicity..grouped_level_1_total_Total_CURP,
    PropPacific2018 = Census_2018_Ethnicity..grouped_level_1_3_Pacific.Peoples_CURP/Census_2018_Ethnicity..grouped_level_1_total_Total_CURP,
    PropAsian2018 = Census_2018_Ethnicity..grouped_level_1_4_Asian_CURP/Census_2018_Ethnicity..grouped_level_1_total_Total_CURP,
    PropME_Latin_Afican2018 = Census_2018_Ethnicity..grouped_level_1_5_Middle.Eastern.Latin.American.African_CURP/Census_2018_Ethnicity..grouped_level_1_total_Total_CURP,
    PropNewZealander2018 = Census_2018_Ethnicity..grouped_level_2_61_New.Zealander_CURP/Census_2018_Ethnicity..grouped_level_1_total_Total_CURP,
    PropOther2018 = (Census_2018_Ethnicity..grouped_level_2_69_Other.Ethnicity.nec_CURP + Census_2018_Ethnicity..grouped_level_1_9_Not.Elsewhere.Included_CURP)/Census_2018_Ethnicity..grouped_level_1_total_Total_CURP
  ) %>%
  rename(
    ResidentPop2018 = Census_2018_CURP,
    CensusNightPop2018 = Census_2018_CNP
  ) %>%
  select (Area_code_and_description, ResidentPop2018, CensusNightPop2018,
                 matches("Prop.*"))

# Split data by geographic areas

usethis::use_data(indiv1, overwrite = TRUE)
