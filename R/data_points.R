
#' Contains Both Datasets
#'
#' Returns an object that holds two datasets in data points format, use
#' with functions that compare datapoints
#' @param a a data points object provided by the fulfiller in the first dataset
#' @param b a data points object produced by the qc analyst in the second dataset
#' @export

data_points <- function(a, b){

  me <- list()

  if (!(is.long(a) & is.long(b)))
    stop("data_points: Both a and b must be in long format with the last two columns named variable and value")

  me$a <- tibble::as_tibble(a)
  me$b <- tibble::as_tibble(b)

  class(me) <- append(class(me), "data_points")

  me

}

