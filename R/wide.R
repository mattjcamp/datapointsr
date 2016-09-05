
#' Wide
#'
#' Returns a dataset in a wide format
#' @keywords dataset, utility, QC
#' @export
#' @examples
#'
#' BUILD DATAPOINTS OBJECT FOR THE BUILT IN QUAKES DATASET

wide <- function(df){
    len <- length(df) - 2
    d <- reshape(df,
                 timevar = "Variable",
                 times = "Value",
                 idvar = names(d)[1:len],
                 direction = "wide")
    names(d) <- str_replace_all(names(d), "Value.", "")

    d
}
