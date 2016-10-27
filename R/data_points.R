
#' Data Points
#'
#' Returns an object that holds two datasets in data points format, use
#' with functions that compare datapoints
#' @param f a data points object provided by the fulfiller
#' @param q a data points object produced by the qc'er
#' @keywords QC, matching
#' @export
#' @examples

data_points <- function(f, q){

  me <- list()

  if (!(is.data.points(f) & is.data.points(q)))
    stop("data_points: Both f and q must be in data.points format")

  # PACKAGE AND RETURN

  me$f <- f
  me$q <- q

  class(me) <- append(class(me),"data.points")

  me

}

