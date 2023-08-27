
context("CLEAN DATASET")

library(testthat)
library(tidyverse)
#library(datapointsr)

# TESTING DATA

ds <- tibble(
  x = 1:5,
  y = 1:5,
  z = c("A", "B", "NULL", "D", "NAS"),
  a = c(NA, "NULLL", "C", "NA", "E"),
  b = c(3.14159, 2.71828, NA, 999, 1.0)
  )

test_that("NULL IS REMOVED", {

  d <-
    ds %>%
    clean()

  expect_equal(
    d$z[3], ""
    )

})

