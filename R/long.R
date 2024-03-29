
#' Convert Data Frame to Data Points Format
#'
#' Makes it easier to look at datasets by putting a statistical table into a common format
#' @description as.data.points returns a melted data frame in tibble format. The last two
#' columns are always a named variable and value. variable is a character type and would be
#' a column header in a tidy dataframe. The preceding columns are all categories that you
#' can select from.
#' @param df The source dataset
#' @param category.cols The columns used to filter the dataset
#' @keywords dataset, utility, QC
#' @export

long <- function(df, category_cols){

  df <-
    df %>%
    mutate(across(everything(), as.character))

  if (!is.numeric(category_cols))
    category_cols <- match(category_cols, names(df))

  d <- data.table::as.data.table(df)
  num_columns <- length(names(d))

  if(num_columns != 1) {

    all.cols <- 1:num_columns
    measure.vars <- all.cols[!all.cols %in% category_cols]

    d <- data.table::melt(data = d,
                          id.vars = category_cols,
                          measure.vars = measure.vars)

    names(d)[length(d) - 1] <- "variable"
    names(d)[length(d)] <- "value"

    d <- tibble::as_tibble(as.data.frame(d))
    d$variable <- as.character(d$variable)

  } else {

    d <- d %>%
      mutate(variable = "datapointsr_id",
             value = "id")

    d <- tibble::as_tibble(as.data.frame(d))

  }

  d

}
