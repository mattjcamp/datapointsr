
context("SHOW VALUES TABLE LABELS")

library(testthat)
library(tidyverse)
library(wicher)
library(datapointsr)

test_that("show_values table labels", {

  q <- wicher::wiche_graduate_projections %>%
    filter(year == 2001,
           grade == "g") %>%
    long(1:7)

  f <- q

  dp <- data_points(f, q)
  values <- show_values(dp)

  expect_equal(names(values$d)[10], "value.f")

})
