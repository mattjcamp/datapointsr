
#' SQL Filter
#'
#' Filters data points
#' @param d data points, compare_datapoints or dataframe object
#' @keywords dataset, utility, QC
#' @export
#' @examples
#'
#' USE WIDE WITH DATAPOINTS
#'
#' datapoints(quakes, c(1,2,5)) %>%
#' filter_sql() %>%
#' head()
#'

filter_sql <- function(d, filter){

  library(coderr)
  library(sqldf)

  if ("compare_datapoints" %in% class(d)) {
    check_meta <- check_categories_meta(d)

    f <- d$f
    q <- d$q

    col.len <- length(names(f)) - 3

    rf <- sqldf(sprintf("

      SELECT %s, 'F' AS Dataset
      FROM f
      WHERE %s
      ORDER BY %s", code_vector_to_csv_list(names(f)[1:col.len], FALSE, FALSE),
                    filter,
                    code_vector_to_csv_list(names(f)[1:col.len], FALSE, FALSE)))

    col.len <- length(names(f)) - 3

    rq <- sqldf(sprintf("

      SELECT %s, 'Q' AS Dataset
      FROM q
      WHERE %s
      ORDER BY %s", code_vector_to_csv_list(names(q)[1:col.len], FALSE, FALSE),
                    filter,
                    code_vector_to_csv_list(names(q)[1:col.len], FALSE, FALSE)))

    if (check_meta$match) {
      records <- rbind(rf, rq)
    } else {

      records <- list()
      records$f <- rf
      records$q <- rq

    }

  } else {
    records <- sqldf(sprintf("SELECT * FROM d WHERE %s", filter))
  }

  records

}
