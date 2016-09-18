
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

    library(reshape)
    library(dplyr)

    len <- length(names(dp)) - 2
    d <- reshape::reshape(dp,
                          timevar = "Variable",
                          times = "Value",
                          idvar = names(dp)[1:len],
                          direction = "wide")
    names(d) <- stringr::str_replace_all(names(d), "Value.", "")

    d
}
