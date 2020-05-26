test_that("Check function returns sf dataframe", {
  # Non-clipped
  expect_s3_class(get_sa1_geoms(), c('sf', 'data.frame'))
  expect_s3_class(get_sa2_geoms(), c('sf', 'data.frame'))
  expect_s3_class(get_ward_geoms(), c('sf', 'data.frame'))
  expect_s3_class(get_ta_geoms(), c('sf', 'data.frame'))
  expect_s3_class(get_rc_geoms(), c('sf', 'data.frame'))

  # Clipped
  expect_s3_class(get_sa1_geoms(clipped = TRUE), c('sf', 'data.frame'))
  expect_s3_class(get_sa2_geoms(clipped = TRUE), c('sf', 'data.frame'))
  expect_s3_class(get_ward_geoms(clipped = TRUE), c('sf', 'data.frame'))
  expect_s3_class(get_ta_geoms(clipped = TRUE), c('sf', 'data.frame'))
  expect_s3_class(get_rc_geoms(clipped = TRUE), c('sf', 'data.frame'))
})
