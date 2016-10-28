
#' Check All Values
#'
#' Compares the rows of values in two datapoints
#' @param dp output from the compare_datapoints function
#' @keywords QC, matching
#' @export
#' @examples

match_values <- function(dp){

  if (!"data.points" %in% class(dp))
    stop("match_values: dp must be data.points object")

  f <- dp$f
  q <- dp$q

  # VERIFY META DATA

  match_meta <- match_category_metadata(dp)

  if (!match_meta$equal)
    stop("match_values: Category metadata must match before you can try to match categories")

  # VERIFY CATEGORIES

  match_cat <- match_categories(dp)

  if (!match_cat$equal)
    stop("match_values: Categories must match before you can try to match values.")

  f <-
    f %>%
    arrange_(names(f))
  q <-
    q %>%
    arrange_(names(q))

  testthat::compare(f, q)

}
