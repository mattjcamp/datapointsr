
context("PRESENTATION SHOW VERBS")

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

test_that("CONSOLE PRESENTATION LOOKS OK", {

  # FULFILLER AND QC DATA

  f <- d
  q <- d

  # DATA POINTS FORMATS

  f <- f %>% long(1:2)
  q <- q %>% long(1:2)

  dp <- data_points(f, q)
  m <- match_data_points(dp)

  # TEST MATCH RESULTS

  expect_equal(show_in_console(m), "The content and metadata in both datasets matches completely.")

})

test_that("HTML PRESENTATION LOOKS OK", {

  # FULFILLER AND QC DATA

  f <- d
  q <- d

  # DATA POINTS FORMATS

  f <- f %>% long(1:2)
  q <- q %>% long(1:2)

  dp <- data_points(f, q)
  m <- match_data_points(dp)

  # TEST MATCH RESULTS

  expect_equal(stringr::str_trunc(show_as_html(m, "QC Example"), 40), "<div id = 'status_passed'><strong><bi...")

})
