
context("SHOW VALUES TABLE LABELS")

library(dplyr)
library(datapointsr)

test_that("show_values table labels", {

  load("f_values.rdata")
  load("q_values.rdata")

  dp <- data_points(f_values, q_values)
  values <- show_values(dp)

  expect_equal(names(values$mis_matched)[5], "f_value")

})
