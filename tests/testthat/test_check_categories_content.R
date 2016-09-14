library(testthat)
library(DataPoints)

context("CATEGORY CONTENT MATCH FUNCTION TESTS")

source("make_test_datasets.R")

dc <- compare_datapoints(f_long, q_long)
dc <- compare_datapoints(f_short_matched, q_short_matched)

check.cat <- check_categories_content(dc)

test_that("check_categories_content finds category content mismatches", {
  expect_equal(check.cat$match, FALSE)
})

dc <- compare_datapoints(f_short_1, q_short_1)
check.cat <- check_categories_content(dc)

test_that("check_categories_content finds category content finds missing rows in q", {
  expect_equal(check.cat$match, FALSE)
})

