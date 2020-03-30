test_that("All data areas present", {
  expect_equal(nrow(individual_sa1_2018), 14347200)
  expect_equal(nrow(individual_sa2_2018), 1081920)
  expect_equal(nrow(individual_ward_2018), 118080)
  expect_equal(nrow(individual_lba_2018), 10560)
  expect_equal(nrow(individual_ta_2018), 33120)
  expect_equal(nrow(individual_dhb_2018), 10560)
  expect_equal(nrow(individual_rc_2018), 8640)
})
