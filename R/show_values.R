
#' Show Values
#'
#' Shows the values in two datapoints
#' @param dp data.points object
#' @keywords QC, matching
#' @export
#' @examples

show_values <- function(dp){

  me <- list()

  if (!"data.points" %in% class(dp))
    stop("show_values: dp must be data.points object")

  f <- dp$f
  q <- dp$q

  # VERIFY META DATA

  match_meta <- match_category_metadata(dp)

  if (!match_meta$equal)
    stop("show_values: Category metadata must match before you can try to match categories")

  # VERIFY CATEGORIES

  match_cat <- match_categories(dp)

  if (!match_cat$equal)
    stop("show_values: Categories must match before you can try to match values.")

  # VERIFY VALUE METADATA

  if (class(f$value) != class(q$value))
    stop("show_values: Value metadata must match before attempting to match values.")

  f <-
    f %>%
    dplyr::arrange_(names(f))
  q <-
    q %>%
    dplyr::arrange_(names(q))

  me$match <- testthat::compare(f, q)

  me$summary_f <- summary(dp$f)
  me$summary_q <- summary(dp$q)

  if (is.numeric(f$value) & is.numeric(q$value)) {

    me$d <-
      dplyr::inner_join(f, q, names(f)[1:length(names(f)) - 1]) %>%
      dplyr::mutate(diff = value.x - value.y,
                    match = ifelse(diff != 0, "n", "y")) %>%
      dplyr::rename(f_value = value.x,
                    q_value = value.y)

    mis_matched <- dplyr::filter(me$d, match == "n")
    if (nrow(mis_matched) > 0)
      me$mis_matched <- mis_matched

  } else {

    me$d <-
      dplyr::inner_join(f, q, names(f)[1:length(names(f)) - 1]) %>%
      dplyr::mutate(diff = stringr::str_c(value.x, "::",  value.y),
                    match = ifelse(value.x != value.y, "n", "y")) %>%
      dplyr::rename(f_value = value.x,
                    q_value = value.y)

    mis_matched <- dplyr::filter(me$d, match == "n")
    if (nrow(mis_matched) > 0)
      me$mis_matched <- mis_matched

  }

  me

}
