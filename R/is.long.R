
#' Is Dataframe In Long Format?
#'
#' @description Make sure the dataset is in long format and that the last two columns are always a named variable and value.
#' @param df The source dataset
#' @export
#' @examples

is.long <- function(df){

  r <- TRUE
  l <- length(names(df))
  n <- names(df)

  if (n[l - 1] != "variable")
    r <- FALSE
  if (n[l] != "value")
    r <- FALSE

  r

}
