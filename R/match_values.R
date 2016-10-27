
#' Check All Content
#'
#' Compares the rows of values in two datapoints
#' @param dp output from the compare_datapoints function
#' @keywords dataset, utility, QC
#' @export
#' @examples

match_values <- function(dp){

  me <- list()

  if (!"data.points" %in% class(dp))
    stop("match_values: dp must be data.points object")

  f <- dp$f
  q <- dp$q

  # VERIFY META DATA

  match_meta <- match_category_metadata(dp)

  if (!is.null(match_meta$match$equal))
    stop(sprintf("match_values: Category metadata must match before you can try to match category content. Here is the attempt to match on metadata: %s",
                 match_meta$match$message))

  # VERIFY CATEGORIES

  match_categories <- match_category_content(dp)

  if (!match_categories$match$equal)
    stop(sprintf("match_values: Categories must match before you can try to match category content. Here is the attempt to match on categories: %s",
                 match_categories$match$message))















  # ADD KEYS

  add_keys <- function(d) {

    l <- length(names(d))
    d$key <- ""
    d$key_cat_var <- ""

    for (i in 1:l)
      d$key <- str_c(d$key, d[[i]], sep = "_")

    l <- l - 1
    for (i in 1:l)
      d$key_cat_var <- str_c(d$key_cat_var, d[[i]], sep = "_")

    d

  }


  f <- add_keys(f)
  q <- add_keys(q)















  # CHECK FOR DUPLICATES

  fkey <- f$key
  if (length(fkey) != length(unique(fkey))) {
    print("WARNING: f datapoints has duplicate rows")
    f <- dplyr::distinct(f)
  }
  qkey <- q$key
  if (length(qkey) != length(unique(qkey))) {
    print("WARNING: q datapoints has duplicate rows")
    q <- dplyr::distinct(q)
  }

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
    me$match <- testthat::compare(f, q)
  } else {
    me$match <- testthat::compare(f, q)
    col.len <- length(names(f)) - 3

    side_by_side_f_q <- sqldf::sqldf("

      SELECT F.*, F.value AS value_F, Q.value AS value_Q
      FROM f F
      JOIN q Q
        ON F.key_cat_var = Q.key_cat_var")

    side_by_side_f_q$value <- NULL
    side_by_side_f_q$key <- NULL
    side_by_side_f_q$key_cat <- NULL
    side_by_side_f_q$key_cat_var <- NULL

    side_by_side_f_q <-
      side_by_side_f_q %>%
      dplyr::mutate(diff = as.numeric(value_F) - as.numeric(value_Q),
                    match = ifelse(value_F == value_Q, TRUE, FALSE))

    me$side_by_side_f_q <- tibble::as_tibble(side_by_side_f_q)

    mis_matched <- dplyr::filter(me$side_by_side_f_q, match == FALSE)
    if (nrow(mis_matched) > 0)
      me$mis_matched <- dplyr::filter(me$side_by_side_f_q, match == FALSE)

  }

  me

}
