## code to prepare `DATASET` dataset goes here

#libraries
library(dplyr)
library(stringr)

# download census files
#download.file("https://www3.stats.govt.nz/2018census/sa1dataset2018/Statistical%20Area%201%20dataset%20for%20Census%202018%20%E2%80%93%20total%20New%20Zealand%20%E2%80%93%20CSV.zip",
#              destfile = "downloads/2018_sa1_census.zip", mode = "wb")
#unzip("downloads/2018_sa1_census.zip", exdir = "downloads/")

# import and tidy up census files
indiv1_raw <- read.csv("downloads/Individual_part1_totalNZ-wide_format.csv",
                       stringsAsFactors = FALSE, na.strings = c("C",".."))

# isolate just 2018 data
indiv1 <- indiv1_raw %>%
  filter(Area_Code != "total") %>%
  select(
    Area_Code,
    Area_Description,
    matches(".*2018.*")
  ) %>%
  mutate(
    PROP_MALE_2018 = Census_2018_Sex_1_Male_CURP/Census_2018_Sex_total_Total_CURP,
    PROP_FEMALE_2018 = Census_2018_Sex_2_Female_CURP/Census_2018_Sex_total_Total_CURP,
    PROP_0_TO_4_2018 = Census_2018_Age..5_year_groups_85_over_01_0.4.years_CURP/Census_2018_Age..5_year_groups_85_over_total_Total_CURP,
    PROP_5_TO_9_2018 = Census_2018_Age..5_year_groups_85_over_02_5.9.years_CURP/Census_2018_Age..5_year_groups_85_over_total_Total_CURP,
    PROP_10_TO_14_2018 = Census_2018_Age..5_year_groups_85_over_03_10.14.years_CURP/Census_2018_Age..5_year_groups_85_over_total_Total_CURP,
    PROP_15_TO_19_2018 = Census_2018_Age..5_year_groups_85_over_04_15.19.years_CURP/Census_2018_Age..5_year_groups_85_over_total_Total_CURP,
    PROP_20_TO_24_2018 = Census_2018_Age..5_year_groups_85_over_05_20.24.years_CURP/Census_2018_Age..5_year_groups_85_over_total_Total_CURP,
    PROP_25_TO_29_2018 = Census_2018_Age..5_year_groups_85_over_06_25.29.years_CURP/Census_2018_Age..5_year_groups_85_over_total_Total_CURP,
    PROP_30_TO_34_2018 = Census_2018_Age..5_year_groups_85_over_07_30.34.years_CURP/Census_2018_Age..5_year_groups_85_over_total_Total_CURP,
    PROP_35_TO_39_2018 = Census_2018_Age..5_year_groups_85_over_08_35.39.years_CURP/Census_2018_Age..5_year_groups_85_over_total_Total_CURP,
    PROP_40_TO_44_2018 = Census_2018_Age..5_year_groups_85_over_09_40.44.years_CURP/Census_2018_Age..5_year_groups_85_over_total_Total_CURP,
    PROP_45_TO_49_2018 = Census_2018_Age..5_year_groups_85_over_10_45.49.years_CURP/Census_2018_Age..5_year_groups_85_over_total_Total_CURP,
    PROP_50_TO_54_2018 = Census_2018_Age..5_year_groups_85_over_11_50.54.years_CURP/Census_2018_Age..5_year_groups_85_over_total_Total_CURP,
    PROP_55_TO_59_2018 = Census_2018_Age..5_year_groups_85_over_12_55.59.years_CURP/Census_2018_Age..5_year_groups_85_over_total_Total_CURP,
    PROP_60_TO_64_2018 = Census_2018_Age..5_year_groups_85_over_13_60.64.years_CURP/Census_2018_Age..5_year_groups_85_over_total_Total_CURP,
    PROP_65_TO_69_2018 = Census_2018_Age..5_year_groups_85_over_14_65.69.years_CURP/Census_2018_Age..5_year_groups_85_over_total_Total_CURP,
    PROP_70_TO_74_2018 = Census_2018_Age..5_year_groups_85_over_15_70.74.years_CURP/Census_2018_Age..5_year_groups_85_over_total_Total_CURP,
    PROP_75_TO_79_2018 = Census_2018_Age..5_year_groups_85_over_16_75.79.years_CURP/Census_2018_Age..5_year_groups_85_over_total_Total_CURP,
    PROP_80_TO_84_2018 = Census_2018_Age..5_year_groups_85_over_17_80.84.years_CURP/Census_2018_Age..5_year_groups_85_over_total_Total_CURP,
    PROP_85_AND_OVER_2018 = Census_2018_Age..5_year_groups_85_over_18_85.years.and.over_CURP/Census_2018_Age..5_year_groups_85_over_total_Total_CURP,
    PROP_EUROPEAN_2018 = Census_2018_Ethnicity..grouped_level_1_1_European_CURP/Census_2018_Ethnicity..grouped_level_1_total_Total_CURP,
    PROP_MAORI_2018 = Census_2018_Ethnicity..grouped_level_1_2_MÄ.ori_CURP/Census_2018_Ethnicity..grouped_level_1_total_Total_CURP,
    PROP_PACIFIC_2018 = Census_2018_Ethnicity..grouped_level_1_3_Pacific.Peoples_CURP/Census_2018_Ethnicity..grouped_level_1_total_Total_CURP,
    PROP_ASIAN_2018 = Census_2018_Ethnicity..grouped_level_1_4_Asian_CURP/Census_2018_Ethnicity..grouped_level_1_total_Total_CURP,
    PROP_ME_LATIN_AFRICAN_2018 = Census_2018_Ethnicity..grouped_level_1_5_Middle.Eastern.Latin.American.African_CURP/Census_2018_Ethnicity..grouped_level_1_total_Total_CURP,
    PROP_NEW_ZEALANDER_2018 = Census_2018_Ethnicity..grouped_level_2_61_New.Zealander_CURP/Census_2018_Ethnicity..grouped_level_1_total_Total_CURP,
    PROP_OTHER_ETHNICITY_2018 = (Census_2018_Ethnicity..grouped_level_2_69_Other.Ethnicity.nec_CURP + Census_2018_Ethnicity..grouped_level_1_9_Not.Elsewhere.Included_CURP)/Census_2018_Ethnicity..grouped_level_1_total_Total_CURP
  ) %>%
  rename(
    RESIDENT_POP_2018 = Census_2018_CURP,
    CENSUS_NIGHT_POP_2018 = Census_2018_CNP
  ) %>%
  select(Area_Code,
         Area_Description,
         RESIDENT_POP_2018,
         CENSUS_NIGHT_POP_2018,
         matches("PROP.*")
  )

# Split data by geographic areas

# SA1 data
sa1_2018 <- indiv1 %>%
  filter(str_length(Area_Code) == 7) %>%
  rename(SA1_2018 = Area_Code) %>%
  select(-Area_Description)

# SA2 data
sa2_2018 <- indiv1 %>%
  filter(str_length(Area_Code) == 6) %>%
  rename(SA2_2018 = Area_Code, SA2_NAME = Area_Description)

# Wards
ward_2018 <- indiv1 %>%
  filter((str_length(Area_Code) == 5) & str_sub(Area_Description, start = -4) == "Ward") %>%
  rename(WARDS_2018 = Area_Code, WARD_NAME = Area_Description)

# Auckland local boards
akl_lba_2018 <- indiv1 %>%
  filter((str_length(Area_Code) == 5) & str_sub(Area_Description, start = -4) == "Area") %>%
  rename(LBA_2018 = Area_Code, AKL_LBA_NAME = Area_Description)

# Territorial authorities
ta_2018 <- indiv1 %>%
  filter((str_length(Area_Code) == 3)) %>%
  rename(TA_2018 = Area_Code, TA_NAME = Area_Description)

# District Health Board Areas
dhb_2018 <- indiv1 %>%
  filter((str_length(Area_Code) == 2) & !str_sub(Area_Description, start = -6) == "Region") %>%
  rename(DHB_2018 = Area_Code, DHB_NAME = Area_Description)

# Regional Council Areas
rc_2018 <- indiv1 %>%
  filter((str_length(Area_Code) == 2) & str_sub(Area_Description, start = -6) == "Region") %>%
  rename(RC_2018 = Area_Code, RC_NAME = Area_Description)

# Save data for future use
#usethis::use_data(indiv1, overwrite = TRUE)
usethis::use_data(sa1_2018, overwrite = TRUE)
usethis::use_data(sa2_2018, overwrite = TRUE)
usethis::use_data(ward_2018, overwrite = TRUE)
usethis::use_data(akl_lba_2018, overwrite = TRUE)
usethis::use_data(ta_2018, overwrite = TRUE)
usethis::use_data(dhb_2018, overwrite = TRUE)
usethis::use_data(rc_2018, overwrite = TRUE)
