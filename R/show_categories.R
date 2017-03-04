
#' Match Category Content
#'
#' Compares the rows of categories in two datapoints
#' @param dp a datapoints object with f and q datasets
#' @keywords QC, matching
#' @export
#' @examples

show_categories <- function(dp){

  if (!"data.points" %in% class(dp))
    stop("show_categories: dp must be data.points object")

  match_meta <- match_category_metadata(dp)
  if (!match_meta$equal)
    me$message <- "show_categories: Categories metadata must match before you can match value content"
  else {

    l_f <- length(names(dp$f)) - 1
    l_q <- length(names(dp$q)) - 1

    f <-
      dp$f[, 1:l_f] %>%
      ungroup()

    q <-
      dp$q[, 1:l_q] %>%
      ungroup()

    n_f <- names(f)
    n_q <- names(q)

    f <-
      f %>%
      dplyr::distinct() %>%
      dplyr::arrange_(n_f)

    q <-
      q %>%
      dplyr::distinct() %>%
      dplyr::arrange_(n_q)

    match <- testthat::compare(f,q)

    in_f <- dplyr::setdiff(f, q)
    in_q <- dplyr::setdiff(q, f)

    me <- list()
    me$match <- match
    if (nrow(in_f) > 0)
      me$in_f <- in_f
    if (nrow(in_q) > 0)
      me$in_q <- in_q
  }

  me

}
