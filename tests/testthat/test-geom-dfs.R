test_that("All geometry dataframes are present", {
  expect_equal(nrow(area_hierarchy), 29889)
  expect_equal(nrow(sa1_geoms), 29889)
  expect_equal(nrow(sa2_geoms), 2253)
  expect_equal(nrow(ward_geoms), 245)
  expect_equal(nrow(ta_geoms), 68)
  expect_equal(nrow(rc_geoms), 17)
})
