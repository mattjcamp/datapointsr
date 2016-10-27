
#' Match Category Meta Data
#'
#' Compares the types of categories in datapoints
#' @param dp output from the compare_datapoints function
#' @keywords QC, matching
#' @export
#' @examples

match_category_metadata <- function(dp){

  library(testthat)

  if (!"data.points" %in% class(dp))
    stop("dp must be data.points object")

  l_f <- length(names(dp$f)) - 1
  f <- data.frame(list(names = names(dp$f)[1:l_f],
                       classes = sapply(dp$f,class)[1:l_f],
                       modes = sapply(dp$f, mode)[1:l_f]))

  l_q <- length(names(dp$q)) - 1
  q <- data.frame(list(names = names(dp$q)[1:l_q],
                       classes = sapply(dp$q,class)[1:l_q],
                       modes = sapply(dp$q, mode)[1:l_q]))

  match <- testthat::compare(f, q)

  if (match$equal) {

    match

  } else {

    me <- list()
    me$match <- match
    me$f <- f
    me$q <- q

    me

  }

}
