
#' Show Variables
#'
#' Shows the variables in two datapoints
#' @param dp data.points object
#' @keywords QC, matching
#' @export
#' @examples

show_variables <- function(dp){

  if (!"data.points" %in% class(dp))
    stop("show_categories: dp must be data.points object")

  match_meta <- match_category_metadata(dp)

  if (!match_meta$equal)
    stop(sprintf("show_variables: Category metadata must match before you can try to match category content."))

  l <- length(names(dp$f)) - 1
  f <- dp$f[, 1:l]
  q <- dp$q[, 1:l]

  f <- f %>%
    dplyr::distinct() %>%
    dplyr::arrange_(names(f))

  q <- q %>%
    dplyr::distinct() %>%
    dplyr::arrange_(names(f))

  match <- testthat::compare(f,q)

  in_f <- dplyr::setdiff(f, q)
  in_q <- dplyr::setdiff(q, f)

  me <- list()
  me$match <- match
  if (nrow(in_f) > 0)
    me$in_f <- in_f
  if (nrow(in_q) > 0)
    me$in_q <- in_q

  me

}
