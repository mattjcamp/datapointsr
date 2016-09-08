
#' Compare Data Points
#'
#' Returns an object that holds two datasets in data points format, use
#' with functions that compare datapoints
#' @param f a data points object provided by the fulfiller
#' @param q a data points object produced by the qc'er
#' @keywords dataset, utility, QC
#' @export
#' @examples

compare_datapoints <- function(f, q){

  me <- list()

  # MAKE SURE BOTH DATAPOINTS ARE IN THE EXPECTED FORMAT

  verify.datapoints.format <- function(ds) {

    ds_len <- length(names(ds))
    if (names(ds)[ds_len] != "Value")
      stop("compare_datapoints: both f and q must be in DataPoints format (Value missing or in the wrong position)")
    if (names(ds)[ds_len - 1] != "Variable")
      stop("compare_datapoints: both f and q must be in DataPoints format (Variable missing or in the wrong position)")

  }

  verify.datapoints.format(f)
  verify.datapoints.format(q)

  # APPEND KEY

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

f <- datapoints(quakes, c(1,2,5))
q <- f
# q$Next <- "AAA"
d <- compare_datapoints(f, q)
