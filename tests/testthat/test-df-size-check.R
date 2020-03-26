test_that("All data areas present", {
  expect_equal(nrow(individual_sa1_2018), 14347200)
  expect_equal(nrow(individual_sa2_2018), 2939216)
  expect_equal(nrow(individual_ward_2018), 320784)
  expect_equal(nrow(individual_lba_2018), 28688)
  expect_equal(nrow(individual_ta_2018), 89976)
  expect_equal(nrow(individual_dhb_2018), 28688)
  expect_equal(nrow(individual_rc_2018), 23472)
})
