
#' Wide
#'
#' Returns a dataset in a wide format
#' @param dp a data points object
#' @keywords dataset, utility, QC
#' @export
#' @examples
#'
#' USE WIDE WITH DATAPOINTS
#'
#' datapoints(quakes, c(1,2,5)) %>%
#' wide() %>%
#' head()
#'
#'

wide <- function(dp){

  library(data.table)
  library(stringr)
  library(dplyr)

  dp <- as.data.table(dp)
  len <- length(names(dp)) - 2
  d <- reshape(dp,
               timevar = "variable",
               times = "value",idvar = names(dp)[1:len],
               direction = "wide")
  names(d) <- str_replace_all(names(d), "value.", "")

  tbl_df(as.data.frame(d))

}
