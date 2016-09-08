
#' Compare Data Points
#'
#' Returns an object that holds two datasets in data points format, use
#' with functions that compare datapoints
#' @param f a data points object provided by the fulfiller
#' @param q a data points object produced by the qc'er
#' @keywords dataset, utility, QC
#' @export
#' @examples
#' f <- quakes
#' q <- quakes
#'
#' q <- q[order(q$long), ]
#' q[56, 3] <- 1234
#'
#' head(f)
#' head(q)
#'
#' f <- datapoints(f, c(1,2,5))
#' q <- datapoints(q, c(1,2,5))
#'
#' head(f)
#' head(q)
#'
#' d <- compare_datapoints(f, q)

compare_datapoints <- function(f, q){

  me <- list()

  # MAKE SURE BOTH DATAPOINTS ARE IN THE EXPECTED FORMAT

  verify.datapoints.format <- function(ds) {

    # CHECK CLASS

    if (!"DataPoints" %in% class(ds))
      stop("Both f and q must be DataPoints objects")

    # CHECK COLUMN NAMES

    ds_len <- length(names(ds))
    if (names(ds)[ds_len] != "Value")
      stop("compare_datapoints: both f and q must be in DataPoints format (Value missing or in the wrong position)")
    if (names(ds)[ds_len - 1] != "Variable")
      stop("compare_datapoints: both f and q must be in DataPoints format (Variable missing or in the wrong position)")

  }

  verify.datapoints.format(f)
  verify.datapoints.format(q)

  # APPEND CATEGORY KEY

  append.cat.key.to <- function(ds) {

    len.names <- length(names(ds)) - 2
    keynames <- paste(names(ds)[1:len.names], collapse = " || ")
    ds <- sqldf(sprintf("SELECT D.*, %s AS key_cat from ds D",
                        keynames))

    ds
  }

  f <- append.cat.key.to(f)
  q <- append.cat.key.to(q)

  # APPEND CATEGORY+VARIABLE KEY

  append.cat.variable.key.to <- function(ds) {

    len.names <- length(names(ds)) - 1
    keynames <- paste(names(ds)[1:len.names], collapse = " || ")
    ds <- sqldf(sprintf("SELECT D.*, %s AS key_cat_var from ds D",
                        keynames))

    ds
  }

  f <- append.cat.variable.key.to(f)
  q <- append.cat.variable.key.to(q)

  # APPEND COMPLETE KEY

  append.key.to <- function(ds) {

    keynames <- paste(names(ds), collapse = " || ")
    ds <- sqldf(sprintf("SELECT D.*, %s AS key from ds D",
                        keynames))

    ds
  }

  f <- append.key.to(f)
  q <- append.key.to(q)

  # ARRANGE

  arrange.datapoints <- function(ds) {

    keynames <- paste(names(ds), collapse = ",")
    ds <- sqldf(sprintf("SELECT * FROM ds ORDER BY %s",
                        keynames))

    ds
  }

  f <- arrange.datapoints(f)
  q <- arrange.datapoints(q)

  # PACKAGE AND RETURN

  me$f <- f
  me$q <- q

  me

}

