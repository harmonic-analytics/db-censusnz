test_that('Check all geographic levels are present', {
  expect_s3_class(get_geoms('sa1_geoms'), c('sf', 'data.frame'))
  expect_s3_class(get_geoms('sa2_geoms'), c('sf', 'data.frame'))
  expect_s3_class(get_geoms('ward_geoms'), c('sf', 'data.frame'))
  expect_s3_class(get_geoms('ta_geoms'), c('sf', 'data.frame'))
  expect_s3_class(get_geoms('sa1_geoms'), c('sf', 'data.frame'))
})

test_that('Check all geographic levels are present', {
  expect_s3_class(get_geoms('sa1_geoms', clipped = TRUE), c('sf', 'data.frame'))
  expect_s3_class(get_geoms('sa2_geoms', clipped = TRUE), c('sf', 'data.frame'))
  expect_s3_class(get_geoms('ward_geoms', clipped = TRUE), c('sf', 'data.frame'))
  expect_s3_class(get_geoms('ta_geoms', clipped = TRUE), c('sf', 'data.frame'))
  expect_s3_class(get_geoms('sa1_geoms', clipped = TRUE), c('sf', 'data.frame'))
})

test_that('Check that get_geoms fails when area is not in correct list', {
  expect_error(get_geoms('not in list'))
})
