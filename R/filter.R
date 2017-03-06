
#' Filter
#'
#' Filters data points
#' @param d data points or dataframe
#' @keywords dataset
#' @export
#' @examples

filter <- function(d, ...){

  if ("data_points" %in% class(d)) {

    me <- list()
    me$f <- dplyr::filter(d$f, ...)
    me$q <- dplyr::filter(d$q, ...)

  } else {
    me <- dplyr::filter(d, ...)
  }

  me

}
