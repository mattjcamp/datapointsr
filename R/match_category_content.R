
#' Match Category Content
#'
#' Compares the rows of categories in two datapoints
#' @param dp a datapoints object with f and q datasets
#' @keywords QC, matching
#' @export
#' @examples

match_category_content <- function(dp){

  library(testthat)

  if (!"data.points" %in% class(dp))
    stop("match_category_content: dp must be data.points object")

  match_meta <- match_category_metadata(dp)

  if (!is.null(match_meta$match$equal))
    stop(sprintf("match_category_content: Category metadata must match before you can try to match category content. Here is the attempt to match on metadata: %s",
                 match_meta$match$message))

  l <- length(names(dp$f)) - 2
  f <- dp$f[, 1:l]
  q <- dp$q[, 1:l]

  f <- f %>%
    dplyr::distinct() %>%
    dplyr::arrange_(names(f))

  q <- q %>%
    dplyr::distinct() %>%
    dplyr::arrange_(names(f))

  match <- compare(f,q)

  if (!is.null(match$equal)) {

    in_f <- dplyr::setdiff(f, q)
    in_q <- dplyr::setdiff(q, f)

    me <- list()
    me$match <- match
    if (nrow(in_f) > 0)
      me$in_f <- in_f
    if (nrow(in_q) > 0)
      me$in_q <- in_q

    me

  } else {

    match

  }

}
