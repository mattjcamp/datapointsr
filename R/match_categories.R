
#' Match Category Content
#'
#' Compares the rows of categories in two datapoints
#' @param dp a datapoints object with f and q datasets
#' @keywords QC, matching
#' @export
#' @examples

match_categories <- function(dp){

  if (!"data.points" %in% class(dp))
    stop("match_categories: dp must be data.points object")

  match_meta <- match_category_metadata(dp)

  if (!match_meta$equal)
    stop(sprintf("match_categories: Category metadata must match before you can try to match category content."))

  l <- length(names(dp$f)) - 2
  f <- dp$f[, 1:l]
  q <- dp$q[, 1:l]

  f <- f %>%
    dplyr::distinct() %>%
    dplyr::arrange_(names(f))

  q <- q %>%
    dplyr::distinct() %>%
    dplyr::arrange_(names(f))

  testthat::compare(f,q)

}
