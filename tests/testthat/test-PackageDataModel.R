context("unit test for PackageDataModel")

testthat::setup({
    assign("test_env", testthat::test_env(), envir = parent.frame())
    assign("Census", PackageDataModel, envir = test_env)
    testthat::local_mock(install_gitlab = function(...) invisible(), .env = "remotes", .local_envir = test_env)
})

# General -----------------------------------------------------------------
test_that("PackageDataModel can not be instantiated", {
    attach(test_env)
    withr::local_envvar(c("GITLAB_PAT" = ""), .local_envir = test_env)
    expect_error(Census$new())
})

test_that("PackageDataModel can be instantiated", {
    attach(test_env)
    withr::local_envvar(c("GITLAB_PAT" = "xxx"), .local_envir = test_env)
    expect_type(test_env$census <- Census$new(), "environment")
})

# Establish database connection -------------------------------------------
test_that("PackageDataModel$establish_connection works", {
    expect_true("DataModel" %in% class(test_env$census$establish_connection()))
})

# Get Variable Names ------------------------------------------------------
test_that("PackageDataModel$get_variables works", {
    expect_silent(variables <- test_env$census$get_variables())
    expect_true("data.frame" %in% class(variables))
    expect_setequal(colnames(variables), c("geography", "variable", "category", "subcategory", "concept"))
    expect_gt(nrow(variables), 0)
})

# Get Census data ---------------------------------------------------------
test_that("PackageDataModel$get_data works", {
    expect_silent(result <- test_env$census$get_data(geography = "RC", variables = c("maori_descent", "smoking_status")))
    expect_true("data.frame" %in% class(result))
    expect_true(all(c("geoid", "land_type", "name", "variable", "variable_group", "count") %in% colnames(result)))
    expect_false(any(duplicated(result %>% dplyr::select(-land_type))))
})

test_that("PackageDataModel$get_data doesn't work", {
    expect_error(test_env$census$get_data(geography = "non-existing-geography", variables = c("maori_descent", "smoking_status")))
    expect_error(test_env$census$get_data(geography = "SA1", variables = "non-existing-variable"))
})

