
context("DATA FORMATS")

library(testthat)
library(tidyverse)
library(wicher)
library(datapointsr)

# REFERENCE DATA

d <- wiche_enrollments %>%
  filter(year %in% 2001:2010,
         grade == "g",
         race == "all",
         location == "us") %>%
  mutate(variable = sprintf("count_%s", sector),
         value = n) %>%
  select(year, location, variable, value) %>%
  wide()

test_that("WIDE TO LONG", {

  f <- d %>% long(1:2)
  expect_length(f$year, 30)

  f <- d %>% long(c("year", "location"))
  expect_length(f$year, 30)

})

test_that("LONG TO WIDE", {

  f <- d %>% long(1:2)
  f <- f %>% wide()
  expect_length(f$year, 10)

})

test_that("WIDE TO LONG WORKS WITH ONE COLUMN", {

  f <- d %>% select(year) %>% long(1)
  expect_length(f$variable, 10)

})

