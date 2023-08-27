
#' Compare Two Datasets
#'
#' Takes two datasets and compares them looking for common values in the two
#' based on common keys. The datasets should be two different version of the
#' same type of dataset with common variables and keys.
#' @param dataset1 first dataset to compare
#' @param dataset2 second dataset to compre
#' @param vars list of variables that you want to compare. The list can be the
#' column names in quotes or the number positions.
#' @param keys key fields the two datasets have in common. Can be the column
#' names in an array with quotes or the number positions. The key must be
#' selected in the vars list as well and the numeric position must correspond to
#' the position in the vars select list. It's easier to use the text description
#' here.
#' @param clean apply datapointsr clean function to strip out NULLS, NAS, and
#' round numbers to 1 decimal place
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
#' m <-
#'   diff(
#'       dataset1 = ds1
#'       , dataset2 = ds3
#'       , vars = c("x", "y", "z")
#'       , keys = c("x")
#'  )
#'
#'   m
#'
#' @export

diff <- function(dataset1, dataset2, vars, keys, clean = TRUE) {

  library(tidyverse)

  if(clean){
    dataset1 <- dataset1 %>% clean()
    dataset2 <- dataset2 %>% clean()
  }

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

  print(m$ds %>% group_by(is, match) %>% count())

  m$ds

}
