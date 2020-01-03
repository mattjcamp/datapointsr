
#' Filter
#'
#' Filters data points
#' @param d data points or dataframe
#' @keywords dataset
#' @export

filter <- function(d, ...){

  if ("data_points" %in% class(d)) {

    me <- list()
    me$a <- dplyr::filter(d$a, ...)
    me$b <- dplyr::filter(d$b, ...)

  } else {
    me <- dplyr::filter(d, ...)
  }

  me

}
