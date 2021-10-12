test_that("All data areas present", {
  # 2018 census
    # Individual
    expect_equal(nrow(INDIVIDUAL_SA1_2018), 14347200)
    expect_equal(nrow(INDIVIDUAL_SA2_2018), 1081920)
    expect_equal(nrow(INDIVIDUAL_WARD_2018), 118080)
    expect_equal(nrow(INDIVIDUAL_LBA_2018), 10080)
    expect_equal(nrow(INDIVIDUAL_TA_2018), 33120)
    expect_equal(nrow(INDIVIDUAL_DHB_2018), 10560)
    expect_equal(nrow(INDIVIDUAL_RC_2018), 8640)
    # Dwelling
    expect_equal(nrow(DWELLING_SA1_2018), 2540650)
    expect_equal(nrow(DWELLING_SA2_2018), 191590)
    expect_equal(nrow(DWELLING_WARD_2018), 20910)
    expect_equal(nrow(DWELLING_LBA_2018), 1785)
    expect_equal(nrow(DWELLING_TA_2018), 5865)
    expect_equal(nrow(DWELLING_DHB_2018), 1870)
    expect_equal(nrow(DWELLING_RC_2018), 1530)
    # Household
    expect_equal(nrow(HOUSEHOLD_SA1_2018), 1374940)
    expect_equal(nrow(HOUSEHOLD_SA2_2018), 103684)
    expect_equal(nrow(HOUSEHOLD_WARD_2018), 11316)
    expect_equal(nrow(HOUSEHOLD_LBA_2018), 966)
    expect_equal(nrow(HOUSEHOLD_TA_2018), 3174)
    expect_equal(nrow(HOUSEHOLD_DHB_2018), 1012)
    expect_equal(nrow(HOUSEHOLD_RC_2018), 828)

  # 2013 census
    # Individual
    expect_equal(nrow(INDIVIDUAL_SA1_2013), 12434240)
    expect_equal(nrow(INDIVIDUAL_SA2_2013), 937664)
    expect_equal(nrow(INDIVIDUAL_WARD_2013), 102336)
    expect_equal(nrow(INDIVIDUAL_LBA_2013), 8736)
    expect_equal(nrow(INDIVIDUAL_TA_2013), 28704)
    expect_equal(nrow(INDIVIDUAL_DHB_2013), 9152)
    expect_equal(nrow(INDIVIDUAL_RC_2013), 7488)
    # Dwelling
    expect_equal(nrow(DWELLING_SA1_2013), 1315160)
    expect_equal(nrow(DWELLING_SA2_2013), 99176)
    expect_equal(nrow(DWELLING_WARD_2013), 10824)
    expect_equal(nrow(DWELLING_LBA_2013), 924)
    expect_equal(nrow(DWELLING_TA_2013), 3036)
    expect_equal(nrow(DWELLING_DHB_2013), 968)
    expect_equal(nrow(DWELLING_RC_2013), 792)
    # Household
    expect_equal(nrow(HOUSEHOLD_SA1_2013), 1374940)
    expect_equal(nrow(HOUSEHOLD_SA2_2013), 103684)
    expect_equal(nrow(HOUSEHOLD_WARD_2013), 11316)
    expect_equal(nrow(HOUSEHOLD_LBA_2013), 966)
    expect_equal(nrow(HOUSEHOLD_TA_2013), 3174)
    expect_equal(nrow(HOUSEHOLD_DHB_2013), 1012)
    expect_equal(nrow(HOUSEHOLD_RC_2013), 828)

  # 2006 census
    # Individual
    expect_equal(nrow(INDIVIDUAL_SA1_2006), 12195120)
    expect_equal(nrow(INDIVIDUAL_SA2_2006), 919632)
    expect_equal(nrow(INDIVIDUAL_WARD_2006), 100368)
    expect_equal(nrow(INDIVIDUAL_LBA_2006), 8568)
    expect_equal(nrow(INDIVIDUAL_TA_2006), 28152)
    expect_equal(nrow(INDIVIDUAL_DHB_2006), 8976)
    expect_equal(nrow(INDIVIDUAL_RC_2006), 7344)
    # Dwelling
    expect_equal(nrow(DWELLING_SA1_2006), 1315160)
    expect_equal(nrow(DWELLING_SA2_2006), 99176)
    expect_equal(nrow(DWELLING_WARD_2006), 10824)
    expect_equal(nrow(DWELLING_LBA_2006), 924)
    expect_equal(nrow(DWELLING_TA_2006), 3036)
    expect_equal(nrow(DWELLING_DHB_2006), 968)
    expect_equal(nrow(DWELLING_RC_2006), 792)
    # Household
    expect_equal(nrow(HOUSEHOLD_SA1_2006), 1374940)
    expect_equal(nrow(HOUSEHOLD_SA2_2006), 103684)
    expect_equal(nrow(HOUSEHOLD_WARD_2006), 11316)
    expect_equal(nrow(HOUSEHOLD_LBA_2006), 966)
    expect_equal(nrow(HOUSEHOLD_TA_2006), 3174)
    expect_equal(nrow(HOUSEHOLD_DHB_2006), 1012)
    expect_equal(nrow(HOUSEHOLD_RC_2006), 828)

  expect_equal(nrow(area_hierarchy_2018), 29889)
  expect_equal(nrow(available_variables), 1071)

  # are there 4 category types inc NA
  expect_equal(length(unique(available_variables$category)), 4)
})
