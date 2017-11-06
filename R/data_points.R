
#' Contains Both Datasets
#'
#' Returns an object that holds two datasets in data points format, use
#' with functions that compare datapoints
#' @param f a data points object provided by the fulfiller
#' @param q a data points object produced by the qc analyst
#' @export

data_points <- function(f, q){

  me <- list()

  if (!(is.long(f) & is.long(q)))
    stop("data_points: Both f and q must be in long format with the last two columns named variable and value")

  me$f <- tibble::as_tibble(f)
  me$q <- tibble::as_tibble(q)

  class(me) <- append(class(me), "data_points")

  me

}

