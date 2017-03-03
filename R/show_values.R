
#' Show Values
#'
#' Shows the values in two datapoints
#' @param dp data.points object
#' @keywords QC, matching
#' @export
#' @examples

show_values  <- function(dp){

  if (!"data.points" %in% class(dp))
    stop("show_categories: dp must be data.points object")

  me <- list()

  match_cat <- match_categories(dp)
  if (!match_cat$equal)
    me$message <- "show_variables: Categories must match before you can match value content"
  else {

    f <- dp$f
    q <- dp$q

    library(tidyverse)

    n <- length(names(f)) - 1
    n <- names(f)[1:n]

    common <- inner_join(f, q, by = n) %>%
      mutate(in_dataset = "common") %>%
      select(in_dataset, everything()) %>%
      rename(value.f = value.x,
             value.q = value.y)

    only_in_f <- anti_join(f, q, by = n) %>%
      mutate(in_dataset = "only_in_f") %>%
      select(in_dataset, everything()) %>%
      rename(value.f = value) %>%
      mutate(value.q = NA)

    only_in_q <- anti_join(q, f, by = n) %>%
      mutate(in_dataset = "only_in_q",
             value.f = NA) %>%
      rename(value.q = value) %>%
      select(in_dataset, everything(), value.f, value.q)

    d <- bind_rows(common, only_in_f, only_in_q) %>%
      mutate(match = value.f == value.q)

    match <- testthat::compare(f, q)

    me$match <- match
    me$d <- d

    me

  }

  me

}
