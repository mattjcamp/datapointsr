
#' Data Points
#'
#' This object makes it easier to look at datasets
#' @param df The source dataset
#' @keywords dataset, utility, QC
#' @export
#' @examples
#' d <- DataPoints(quakes, c(1,2,5))

DataPoints <- function(df,
                       category.cols = NULL,
                       cleaning.function = NULL){

  library(reshape)
  library(dplyr)
  library(stringr)

  # CONSTRUCTOR

  d <- df

  if (!is.null(cleaning.function))
    d <- cleaning.function(d)

  if (!is.null(category.cols)) {

    num_columns <- length(names(d))
    all.cols <- 1:num_columns
    measure.vars <- all.cols[!all.cols %in% category.cols]

    d <- melt(data = d,
              id.vars = category.cols,
              measure.vars = measure.vars)

    names(d)[length(d) - 1] <- "Variable"
    names(d)[length(d)] <- "Value"

  }

  # PACKAGE IN A LIST

  me <- list()

  # METHODS

  me$variables <- function()distinct(d, Variable)$Variable
  me$long <- function(variables = NULL, sql.filter = NULL){
    if (!is.null(sql.filter))
      d <- sqldf(sprintf("SELECT * FROM d WHERE %s", sql.filter))
    if (!is.null(variables))
      d[d$Variable %in% variables, ]
    else
      d
  }
  me$wide <- function(select = NULL, sql.filter = NULL){
    len <- length(d) - 2
    d <- reshape(d,
                 timevar = "Variable",
                 times = "Value",
                 idvar = names(d)[1:len],
                 direction = "wide")
    names(d) <- str_replace_all(names(d), "Value.", "")
    if (!is.null(sql.filter))
      d <- sqldf(sprintf("SELECT * FROM d WHERE %s", sql.filter))
    if (!is.null(select))
      d <- d[, select]
    d
  }

  # REGISTER CLASS

  class(me) <- append(class(me), "Data.Points")

  me

}
