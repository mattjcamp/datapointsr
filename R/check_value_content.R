
#' Check Value Content
#'
#' Compares the rows of values in two datapoints
#' @param dc output from the compare_datapoints function
#' @keywords dataset, utility, QC
#' @export
#' @examples

check_value_content <- function(dc){

  library(dplyr)
  library(sqldf)

  me <- list()

  if (!"compare_datapoints" %in% class(dc))
    stop("dc must be compare_datapoints object")

  # MAKE SURE THE CATEGORY CONTENT MATCHES BEFORE
  # ATTEMPTING TO MATCH THE CONTENT

  f <- dc$f
  q <- dc$q

  cat.match <- check_categories_content(dc)

  if (!cat.match$match) {
    me$match <- compare(f, q)
    me$report <- "MAKE SURE CATEGORIES MATCH BEFORE ATTEMPTING TO MATCH VALUE ROW CONTENT"
    me$cat.match <- cat.match
  } else {

    # CHECK FOR DUPLICATES

    fkey <- f$key
    if (length(fkey) != length(unique(fkey))) {
      print("WARNING: f datapoints has duplicate rows")
      f <- distinct(f)
    }
    qkey <- q$key
    if (length(qkey) != length(unique(qkey))) {
      print("WARNING: q datapoints has duplicate rows")
      q <- distinct(q)
    }

    # CHECK FOR MATCHING CONTENT

    common_keys <- sqldf("

      SELECT F.key
      FROM f F
      JOIN q Q
        ON F.key = Q.key")$key

    f_keys <- common_keys[!f$key %in% common_keys]
    q_keys <- common_keys[!q$key %in% common_keys]

    in_f_but_not_q <- filter(f, key %in% f_keys)
    in_q_but_not_f <- filter(q, key %in% q_keys)

    nrow_f <- nrow(in_f_but_not_q)
    nrow_q <- nrow(in_q_but_not_f)

    if (nrow_f == 0 & nrow_q == 0) {
      me$match <- compare(f, q)
    } else {
      me$match <- compare(f, q)
      col.len <- length(names(f)) - 3

      side_by_side_f_q <- sqldf("

        SELECT F.*, F.value AS value_F, Q.value AS value_Q
        FROM f F
        JOIN q Q
          ON F.key_cat_var = Q.key_cat_var")

      side_by_side_f_q$value <- NULL
      side_by_side_f_q$key <- NULL
      side_by_side_f_q$key_cat <- NULL
      side_by_side_f_q$key_cat_var <- NULL

      side_by_side_f_q <- side_by_side_f_q %>%
        mutate(Diff = as.numeric(value_F) - as.numeric(value_Q)) %>%
        mutate(Match = ifelse(value_F == value_Q, TRUE, FALSE))

      me$side_by_side_f_q <- tbl_df(side_by_side_f_q)

    }

  }

  me

}
