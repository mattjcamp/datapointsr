
#' Wide Data Points Format
#'
#' Returns a \link[datapointsr]{long} dataset as wide format
#' @param df a \link[datapointsr]{long} format dataframe
#' @export
#' @examples

wide <- function(df){

  df <- data.table::as.data.table(df)
  len <- length(names(df)) - 2
  d <- stats::reshape(df,
                      timevar = "variable",
                      times = "value",idvar = names(df)[1:len],
                      direction = "wide")
  names(d) <- stringr::str_replace_all(names(d), "value.", "")

  tibble::as_tibble(as.data.frame(d))

}
