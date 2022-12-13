
#' Compare Two Datasets
#'
#' Takes two datasets and compares them looking for common values in the two
#' based on common keys. The datasets should be two different version of the
#' same type of dataset with common variables and keys.
#' @param dataset1 first dataset to compare
#' @param dataset2 second dataset to compre
#' @param vars list of variables that you want to look at. The list can be the column names in quotes or the number positions.
#' @param keys list of key fields the two datasets have in common that will. . The list can be the column names in quotes or the number positions.
#' be used to join
#' @examples
#' library(tidyverse)
#' library(datapointsr)
#'
#' ds1 <- tibble(
#'   x = 1:5
#'   , y = 1:5
#'   , z = c("A", "B", "C", "D", "E")
#' )
#'
#' ds2 <- tibble(
#'   x = 1:5
#'   , y = c(1:3, 7, 5)
#'   , z = c("A", "B", "C", "D", "E")
#' )
#'
#' m <-
#'   diff(
#'        dataset1 = ds1
#'        , dataset2 = ds3
#'        , vars = 1:3
#'        , keys = 1
#'   )
#'
#'   m
#'
#' @export

diff <- function(dataset1, dataset2, vars, keys) {

  a <-
    dataset1 %>%
    select(all_of(vars)) %>%
    long(keys)

  b <-
    dataset2 %>%
    select(all_of(vars)) %>%
    long(keys)

  dp <- data_points(a, b)
  m <- match_data_points(dp)
  m$ds

}
