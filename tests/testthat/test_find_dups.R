
context("FIND_DUPS")

library(testthat)
library(tidyverse)
#library(datapointsr)

# TESTING DATA

ds  <-tibble(
  x = c(1,2,2,2,3,4,4)
  , y = 1:7
  , z = c("AA", "BB", "CC", "DD", "EE","FF", "TT")
)

test_that("FINDS DUPLICATE KEYS", {

  d <-
    find_dups(ds, keys = "x")

  expect_equal(
    d %>%
      count() %>%
      as.numeric(), 5
  )

})
