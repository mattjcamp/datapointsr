
#' Find Duplicate Keys
#'
#' Finds rows that are duplicated based on the supplied keys
#' @description Finds rows that are duplicated based on the supplied keys.
#' Returns all duplicate rows in descending order based on num_dups. num_dups
#' is appended to the end of the dataset.
#' @param ds The source dataset
#' @param keys vector of keys in character format
#' @keywords dataset
#' @export

find_dups <- function(ds, keys) {

  k <-
    ds %>%
    group_by(across(all_of(keys))) %>%
    count() %>%
    filter(n > 1) %>%
    rename(num_dups = n)

  ds %>%
    inner_join(k) %>%
    arrange(desc(num_dups))

}
