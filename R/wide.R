
#' Wide
#'
#' Returns a dataset in a wide format
#' @param dp a data points object
#' @keywords dataset, utility, QC
#' @export
#' @examples

wide <- function(dp){

  dp <- data.table::as.data.table(dp)
  len <- length(names(dp)) - 2
  d <- stats::reshape(dp,
                      timevar = "variable",
                      times = "value",idvar = names(dp)[1:len],
                      direction = "wide")
  names(d) <- stringr::str_replace_all(names(d), "value.", "")

  tibble::as_tibble(as.data.frame(d))

}
