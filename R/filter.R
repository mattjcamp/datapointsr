
#' Filter
#'
#' Filters data points
#' @param d data points, compare_datapoints or dataframe object
#' @keywords dataset, utility, QC
#' @export
#' @examples

filter <- function(d, ...){

  if ("data.points" %in% class(d)) {

    me <- list()
    me$f <- dplyr::filter(d$f, ...)
    me$q <- dplyr::filter(d$q, ...)

  } else {
    me <- dplyr::filter(d, ...)
  }

  me

}
