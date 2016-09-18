
context("VALUE CONTENT MATCH FUNCTION TESTS")

source("make_test_datasets.R")

dc <- compare_datapoints(f_short_unmatched, q_short_unmatched)

check.val <- check_value_content(dc)

test_that("check_value_content finds value content mismatches", {
  expect_equal(check.val$match, FALSE)
  expect_equal(check.val$side_by_side_f_q[1,8], FALSE)
})

