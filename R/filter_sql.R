
#' SQL Filter
#'
#' Filters data points
#' @param dp a data points object
#' @keywords dataset, utility, QC
#' @export
#' @examples
#'
#' USE WIDE WITH DATAPOINTS
#'
#' datapoints(quakes, c(1,2,5)) %>%
#' filter_sql() %>%
#' head()
#'

filter_sql <- function(dp, filter){
  sqldf(sprintf("SELECT * FROM dp WHERE %s", filter))
}
