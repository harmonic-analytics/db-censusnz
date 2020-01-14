test_that("All data areas present", {
  expect_equal(nrow(sa1_2018), 29889)
  expect_equal(nrow(sa2_2018), 2253)
  expect_equal(nrow(ward_2018), 245)
  expect_equal(nrow(akl_lba_2018), 21)
  expect_equal(nrow(ta_2018), 68)
  expect_equal(nrow(dhb_2018), 21)
  expect_equal(nrow(rc_2018), 17)
})
