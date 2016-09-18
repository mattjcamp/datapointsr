
context("CHECK CATEGORY META TESTS")

source("make_test_datasets.R")

dc <- compare_datapoints(f_long, q_long)

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

dc <- compare_datapoints(f_short_out_of_order, q_short_out_of_order)
check.cat <- check_categories_meta(dc)

test_that("check_categories_meta finds category metadata matches", {
  expect_equal(check.cat$match, FALSE)
})
