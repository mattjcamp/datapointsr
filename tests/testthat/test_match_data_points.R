
context("DIFF")

library(testthat)
library(tidyverse)
#library(datapointsr)

# TESTING DATA

ds1  <-tibble(
  x = 1:5
  , y = 1:5
  , z = c("A", "B", "C", "D", "E")
  )

ds2  <-tibble(
  x = 1:5
  , y = 1:5
  , z = c("A", "B", "C", "D", "E")
)

ds3  <-tibble(
  x = 1:5
  , y = c(1:3, 7, 5)
  , z = c("A", "B", "C", "D", "E")
)

ds4  <-tibble(
  x = 1:5
  , y = 1:5
  , z = c("A", "Z", "C", "D", "E")
)

ds5  <-tibble(
  x = 1:5
  , y = c(1:3, 7, 5)
  , z = c("A", "Z", "C", "D", "E")
)

ds6  <-tibble(
  x = 2:5
  , y = 2:5
  , z = c("B", "C", "D", "E")
)

ds7  <-tibble(
  x = 2:5
  , y = c(2:3, 7, 5)
  , z = c("Z", "C", "D", "E")
)

test_that("FINDS EXACT MATCH", {

  m <-
    diff(
      dataset1 = ds1
      , dataset2 = ds2
      , vars = c("x", "y", "z")
      , keys = "x"
      )

  expect_equal(
    m %>%
      filter(match) %>%
      count() %>%
      as.numeric(), 10
    )

})

test_that("FINDS ONE OFF ERROR", {

  m <-
    diff(
      dataset1 = ds1
      , dataset2 = ds3
      , vars = 1:3
      , keys = 1
    )

  expect_equal(
    m %>%
      filter(!match) %>%
      count() %>%
      as.numeric(), 1
  )

})

test_that("FINDS MISSING ROW", {

  m <-
    diff(
      dataset1 = ds1
      , dataset2 = ds6
      , vars = 1:3
      , keys = 1
    )

  expect_equal(
    m %>%
      filter(is == "only_in_a") %>%
      count() %>%
      as.numeric(), 2
  )

})

ds1 <- tibble(
  x = 1:5
  , y = 1:5
  , z = c("A", "B", "C", "D", "E")
)

ds2 <- tibble(
  x = 1:5
  , y = c(1:3, 7, 5)
  , z = c("A", "B", "C", "D", "E")
)

m <-
  diff(
       dataset1 = ds1
       , dataset2 = ds3
       , vars = c("x", "y", "z")
       , keys = c("x")
  )
