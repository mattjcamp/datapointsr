
#' Find Duplicate Keys
#'
#' Finds rows that are duplicated based on the supplied keys
#' @description Finds rows that are duplicated based on the supplied keys
#' @param ds The source dataset
#' @param keys vector of keys in character format
#' @keywords dataset
#' @export

find_dups <- function(ds, keys) {
  ds %>%
    group_by(across(all_of(keys))) %>%
    count() %>%
    filter(n > 1)
}
