
context("HTML MATCHING REPORT MISSING VALUES APPEARANCE")

library(dplyr)
library(datapointsr)

test_that("html_matching_report shows missing values", {

  load("f_matched.rdata")
  load("q_matched.rdata")

  q_matched[5, 5] <- 999

  dp <- data_points(f_matched, q_matched)

  h <- html_matching_report(dp)

  expect_true(stringr::str_detect(h, "<td style=\"text-align:right;\"> 3073957 </td>"))

})
