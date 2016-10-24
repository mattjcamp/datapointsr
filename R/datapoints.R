
#' Data Points
#'
#' This object makes it easier to look at datasets
#' @param df The source dataset
#' @param category.cols The columns used to filter the dataset
#' @keywords dataset, utility, QC
#' @export
#' @examples
#'
#' BUILD DATAPOINTS OBJECT FOR THE BUILT IN QUAKES DATASET
#'
#' d <- datapoints(quakes, c(1,2,5))
#'

datapoints <- function(df,
                       category.cols){

  library(data.table)

  d <- as.data.table(df)
  num_columns <- length(names(d))
  all.cols <- 1:num_columns
  measure.vars <- all.cols[!all.cols %in% category.cols]

  d <- melt(data = d,
            id.vars = category.cols,
            measure.vars = measure.vars)

  names(d)[length(d) - 1] <- "variable"
  names(d)[length(d)] <- "value"

  library(dplyr)

  tbl_df(as.data.frame(d))

}
