test_that("All data areas present", {
  # 2018 census
  expect_equal(nrow(SA1_2018), 14347200)
  expect_equal(nrow(SA2_2018), 1081920)
  expect_equal(nrow(WARD_2018), 118080)
  expect_equal(nrow(LBA_2018), 10080)
  expect_equal(nrow(TA_2018), 33120)
  expect_equal(nrow(DHB_2018), 10560)
  expect_equal(nrow(RC_2018), 8640)
  # 2013 census
  expect_equal(nrow(SA1_2013), 12434240)
  expect_equal(nrow(SA2_2013), 937664)
  expect_equal(nrow(WARD_2013), 102336)
  expect_equal(nrow(LBA_2013), 8736)
  expect_equal(nrow(TA_2013), 28704)
  expect_equal(nrow(DHB_2013), 9152)
  expect_equal(nrow(RC_2013), 7488)
  # 2006 census
  expect_equal(nrow(SA1_2006), 12195120)
  expect_equal(nrow(SA2_2006), 919632)
  expect_equal(nrow(WARD_2006), 100368)
  expect_equal(nrow(LBA_2006), 8568)
  expect_equal(nrow(TA_2006), 28152)
  expect_equal(nrow(DHB_2006), 8976)
  expect_equal(nrow(RC_2006), 7344)

  expect_equal(nrow(area_hierarchy_2018), 29889)
})
