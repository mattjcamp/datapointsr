
context("MATCH DATA POINTS")

library(testthat)
library(tidyverse)
library(wicher)
library(datapointsr)

# REFERENCE DATA

d <- wiche_graduate_projections %>%
  filter(year %in% 2001:2010,
         grade == "g",
         race == "all",
         location == "us") %>%
  mutate(variable = sprintf("count_%s", sector),
         value = n) %>%
  select(year, location, variable, value) %>%
  wide()

test_that("FINDS EXACT MATCH", {

  # FULFILLER AND QC DATA

  f <- d
  q <- d

  # DATA POINTS FORMATS

  f <- f %>% long(1:2)
  q <- q %>% long(1:2)

  dp <- data_points(f, q)
  m <- match_data_points(dp)

  # TEST MATCH RESULTS

  expect_true(m$match$equal)

})

test_that("FINDS MISMATCHED VALUES", {

  # FULFILLER AND QC DATA

  f <- d
  q <- d

  # INSERT NOISE

  f[3, 4] <- f[3, 4] + sample(1:100, 1)
  f[7, 5] <- f[7, 5] + sample(1:1000, 1)

  # DATA POINTS FORMATS

  f <- f %>% long(1:2)
  q <- q %>% long(1:2)

  dp <- data_points(f, q)
  m <- match_data_points(dp)

  # TEST MATCH RESULTS

  expect_false(m$match$equal)

})

test_that("FINDS MISLABELED CATEGORY VALUES", {

  # FULFILLER AND QC DATA

  f <- d
  q <- d

  # INSERT NOISE

  f[8, 2] <- "usa"

  # DATA POINTS FORMATS

  f <- f %>% long(1:2)
  q <- q %>% long(1:2)

  dp <- data_points(f, q)
  m <- match_data_points(dp)

  # TEST MATCH RESULTS

  expect_false(m$match$equal)

})

test_that("FINDS MISSING CATEGORIES", {

  # FULFILLER AND QC DATA

  f <- d
  q <- d

  # INSERT NOISE

  f$location <- NULL

  # DATA POINTS FORMATS

  f <- f %>% long(1)
  q <- q %>% long(1:2)

  dp <- data_points(f, q)
  m <- match_data_points(dp)

  # TEST MATCH RESULTS

  expect_false(m$match_meta$equal)

})

test_that("FINDS MISMATCHED CATEGORY METADATA", {

  # FULFILLER AND QC DATA

  f <- d
  q <- d

  # INSERT NOISE

  f$year <- as.character(f$year)

  # DATA POINTS FORMATS

  f <- f %>% long(1:2)
  q <- q %>% long(1:2)

  dp <- data_points(f, q)
  m <- match_data_points(dp)

  # TEST MATCH RESULTS

  expect_false(m$match_meta$equal)

})
