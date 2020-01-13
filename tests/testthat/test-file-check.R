test_that("Source URL Exists", {
  expect_true(RCurl::url.exists('https://www3.stats.govt.nz/2018census/sa1dataset2018/Statistical%20Area%201%20dataset%20for%20Census%202018%20%E2%80%93%20total%20New%20Zealand%20%E2%80%93%20CSV.zip'))
})


