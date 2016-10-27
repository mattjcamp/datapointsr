
context("REAL QC SCENERIO WITH WICHE IMPACT ANALYSIS")

library(dplyr)
library(datapointsr)

test_that("check_categories_meta works", {

  load("f.rdata")
  load("q.rdata")

  dp <- data_points(f, q)
  cat_meta <- match_category_metadata(dp)
  expect_true(cat_meta$equal)

  f <-
    f %>%
    select(location, year, wiche_year, variable, value)

  dp <- data_points(f, q)
  cat_meta <- match_category_metadata(dp)
  expect_false(cat_meta$match$equal)

})

test_that("check_categories_content works", {

  load("f.rdata")
  load("q.rdata")

  f <-
    f %>%
    select(location, year, wiche_year, variable, value)

  dp <- data_points(f, q)
  expect_error(match_category_content(dp))

  load("f.rdata")
  dp <- data_points(f, q)
  cat_content <- match_category_content(dp)
  expect_false(cat_content$match$equal)

  dp <- data_points(f, f)
  cat_content <- match_category_content(dp)
  expect_true(cat_content$match$equal)

})

test_that("match_values works", {

  load("f.rdata")
  load("q.rdata")

  dp <- data_points(f, q)
  expect_error(match_values(dp))

  dp <- data_points(f, f)
  values <- match_values(dp)
  expect_true(values$match$equal)

})

test_that("report_match_values works", {

  load("f_values.rdata")
  load("q_values.rdata")

  dp <- data_points(f_values, q_values)
  values <- match_values(dp)
  expect_false(values$match$equal)

  expect_output(report_match_values(dp))

})
