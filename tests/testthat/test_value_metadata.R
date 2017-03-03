
context("VALUE METADATA")

library(dplyr)
library(datapointsr)

test_that("show_values", {

  load("f_matched.rdata")
  load("q_matched.rdata")
  q_matched$value <- as.character(q_matched$value)

  dp <- data_points(f_matched, q_matched)


})
