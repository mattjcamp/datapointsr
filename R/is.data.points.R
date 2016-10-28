#' Is Data Frame in Data Points Format?
#'
#' @description Check to see if the last two columns are always a named variable and value.
#' variable is a character type and would be a column header in a tidy dataframe. The preceding
#' columns are all categories that you can select from.
#' @param df The source dataset
#' @keywords QC, matching
#' @export
#' @examples

is.data.points <- function(df){

  r <- TRUE
  l <- length(names(df))
  n <- names(df)

  if (n[l - 1] != "variable")
    r <- FALSE
  if (n[l] != "value")
    r <- FALSE

  r

}
