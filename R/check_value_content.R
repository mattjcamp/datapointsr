
#' Check Value Content
#'
#' Compares the rows of values in two datapoints
#' @param dc output from the compare_datapoints function
#' @keywords dataset, utility, QC
#' @export
#' @examples

check_value_content <- function(dc){

  library(reshape)
  library(dplyr)
  library(sqldf)

  me <- list()

  # CHECK dc CLASS

  if (!"compare_datapoints" %in% class(dc))
    stop("dc must be compare_datapoints object")

  # MAKE SURE THE CATEGORY CONTENT MATCHES BEFORE
  # ATTEMPTING TO MATCH THE CONTENT

  cat.match <- check_categories_content(dc)

  if (!cat.match$match) {
    me$match <- FALSE
    me$report <- "MAKE SURE THE CATAGORIES MATCHES BEFORE ATTEMPTING TO MATCH VALUE ROW CONTENT"
    me$cat.match <- cat.match
  } else {

    f <- dc$f
    q <- dc$q

    # CHECK FOR DUPLICATES

    fkey <- f$key
    if (length(fkey != length(unique(fkey))))
      me$warning <- "f datapoints has duplicate rows"

    qkey <- q$key
    if (length(qkey != length(unique(qkey))))
      me$warning <- "q datapoints has duplicate rows"

    # CHECK FOR MATCHING CONTENT

    common_keys <- sqldf::sqldf("

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
      me$match <- TRUE
    } else {
      me$match <- FALSE
      col.len <- length(names(f)) - 3

      side_by_side_f_q <- sqldf("

        SELECT F.*, F.Value AS Value_F, Q.Value AS Value_Q
        FROM f F
        JOIN q Q
          ON F.key_cat_var = Q.key_cat_var")

      side_by_side_f_q$Value <- NULL
      side_by_side_f_q$key <- NULL
      side_by_side_f_q$key_cat <- NULL
      side_by_side_f_q$key_cat_var <- NULL

      side_by_side_f_q <- side_by_side_f_q %>%
        mutate(Diff = as.numeric(Value_F) - as.numeric(Value_Q)) %>%
        mutate(Match = ifelse(Diff == 0, TRUE, FALSE))

      me$side_by_side_f_q <- side_by_side_f_q

    }

  }

  class(me) <- append(class(me),"check_value_content")

  me

}
