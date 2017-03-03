
context("REAL QC SCENERIO WITH WICHE IMPACT ANALYSIS")

library(dplyr)
library(datapointsr)

test_that("match_category_metadata works", {

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
  expect_false(cat_meta$equal)

})

test_that("show_category_metadata works", {

  load("f.rdata")
  load("q.rdata")

  dp <- data_points(f, q)
  cat_meta <- show_category_metadata(dp)
  expect_true(cat_meta$match$equal)

})

test_that("match_categories works", {

  load("q.rdata")
  load("f.rdata")
  dp <- data_points(f, q)
  cat_content <- match_categories(dp)
  expect_false(cat_content$equal)

  dp <- data_points(f, f)
  cat_content <- match_categories(dp)
  expect_true(cat_content$equal)

})

test_that("show_categories works", {

  load("f.rdata")
  load("q.rdata")

  dp <- data_points(f, q)
  cat_content <- show_categories(dp)
  expect_false(cat_content$match$equal)

})

test_that("match_values works", {

  load("f.rdata")
  load("q.rdata")

  dp <- data_points(f, q)
  expect_error(match_values(dp))

  dp <- data_points(f, f)
  values <- match_values(dp)
  expect_true(values$equal)

  load("f_values.rdata")
  load("q_values.rdata")

  dp <- data_points(f_values, q_values)
  values <- show_values(dp)

})

test_that("html_matching_report works", {

  load("f_values.rdata")
  load("q_values.rdata")

  dp <- data_points(f_values, q_values)
  values <- match_values(dp)
  expect_false(values$equal)

  html <- html_matching_report(dp)

  load("f_matched.rdata")
  load("q_matched.rdata")

  dp <- data_points(f_matched, q_matched)
  values <- match_values(dp)
  expect_true(values$equal)

  html <- html_matching_report(dp)

})
