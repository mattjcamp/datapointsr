
context("CHECK PRESENT QC MATCH")

source("make_test_datasets.R")

dc <- compare_datapoints(f_long, q_long)
html <- present_qc_match_report(dc, "Long Quakes")

test_that("present_qc_match_reports works", {
  expect_equal(is.null(html), FALSE)
})

