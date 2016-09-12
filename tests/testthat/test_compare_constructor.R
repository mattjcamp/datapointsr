library(testthat)

context("Data Points QC Objects")

# TEST FUNCTIONS WITH QUAKES DATASET

f <- quakes
q <- quakes

# MAKE DIFFERENT NUMBERS OF CATEGORIES

f$Sigma <- "999"
f$G <- "Good"
q$New_Cat <- "MEOW"

# CHANGE DATA POINT CONTENT

q <- q[order(q$long), ]
q[56, 3] <- 1234
f <- f[c(1:35,39:1000),]

# ASSIGN DATAPOINTS OBJECTS

f <- datapoints(f, c(1,2,5,6,7))
q <- datapoints(q, c(1,2,5,6))

# COMPARE DATAPOINTS OBJECT

d <- compare_datapoints(f, q)

test_that("compare_datapoints adds keys correctly", {
  n <- names(d$f)
  expect_equal(length(n), 10)
  expect_equal(n[10], "key")
  expect_equal(n[9], "key_cat_var")
  expect_equal(n[8], "key_cat")
  expect_equal(d$f[1, 8], "-38.59175.736999Good")
  expect_equal(d$f[1, 9], "-38.59175.736999Gooddepth")
  expect_equal(d$f[1, 10], "-38.59175.736999Gooddepth162.0")
})

# CHECK CATEGORY META (DATA TYPES, NAMES)

check.cat <- check_categories_meta(d)

test_that("check_categories_meta finds category metadata mismatches", {
  expect_equal(check.cat$report, "Check Category Metadata")
  expect_equal(check.cat$Num_of_Categories, "f and q do not have the same number of categories")
  expect_equal(check.cat$Categories_Not_In_F_But_In_Q, "New_Cat")
  expect_equal(check.cat$Categories_Not_In_Q_But_In_F, c("Sigma", "G"))
})

