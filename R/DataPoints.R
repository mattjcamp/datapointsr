
#' Data Points
#'
#' This object makes it easier to look at datasets
#' @param df The source dataset
#' @param category.cols The columns used to filter the dataset
#' @param cleaning.function A function that will clean and adjust the source dataset so it will work with DataPoints
#' @keywords dataset, utility, QC
#' @export
#' @examples
#'
#' BUILD DATAPOINTS OBJECT FOR THE BUILT IN QUAKES DATASET
#'
#' d <- DataPoints(quakes, c(1,2,5))
#'
#' # LOOK AT THE TOP 5 ROWS IN LONG FORMAT
#'
#' head(d$long())
#'
#'      lat   long stations Variable Value
#'1 -20.42 181.62       41    depth   562
#'2 -20.62 181.03       15    depth   650
#'3 -26.00 184.10       43    depth    42
#'4 -17.97 181.66       19    depth   626
#'5 -20.42 181.96       11    depth   649
#'6 -19.68 184.31       12    depth   195
#'
#' # LOOK AT THE TOP 5 ROWS IN WIDE FORMAT
#'
#' head(d$wide())
#'
#' FILTER THE LONG FORMAT WITH A SQL FILTER
#'
#' under.100 <- d$long(sql.filter = "Value < 100"))

DataPoints <- function(df,
                       category.cols = NULL,
                       cleaning.function = NULL){

  library(reshape)
  library(dplyr)
  library(stringr)
  library(sqldf)

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
