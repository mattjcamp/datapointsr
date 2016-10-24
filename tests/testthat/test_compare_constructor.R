
context("COMPARE DATAPOINTS CONSTRUCTOR TESTS")

source("make_test_datasets.R")

dc <- compare_datapoints(f_long, q_long)

test_that("compare_datapoints adds keys correctly", {

  f <- as.data.frame(dc$f)
  n <- names(dc$f)
  expect_equal(length(n), 10)
  expect_equal(n[10], "key")
  expect_equal(n[9], "key_cat_var")
  expect_equal(n[8], "key_cat")
  expect_equal(f[1, 8], "-38.59175.736999Good")
  expect_equal(f[1, 9], "-38.59175.736999Gooddepth")
  expect_equal(f[1, 10], "-38.59175.736999Gooddepth162.0")
})

check.cat <- check_categories_meta(dc)

test_that("check_categories_meta finds category metadata mismatches", {
  expect_equal(check.cat$report, "CHECK CATEGORY META")
  expect_equal(check.cat$Num_of_Categories, "f and q do not have the same number of categories")
  expect_equal(check.cat$Categories_Not_In_F_But_In_Q, "New_Cat")
  expect_equal(check.cat$Categories_Not_In_Q_But_In_F, c("Sigma", "G"))
})

dc <- compare_datapoints(f_short_matched, q_short_matched)
check.cat <- check_categories_meta(dc)

test_that("check_categories_meta finds category metadata matches", {
  expect_equal(check.cat$match, TRUE)
})
