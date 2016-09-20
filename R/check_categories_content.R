
#' Check Category Content
#'
#' Compares the rows of categories in two datapoints
#' @param dc output from the compare_datapoints function
#' @keywords dataset, utility, QC
#' @export
#' @examples

check_categories_content <- function(dc){

  library(reshape)
  library(dplyr)

  me <- list()

  # CHECK dc CLASS

  if (!"compare_datapoints" %in% class(dc))
    stop("dc must be compare_datapoints object")

  # MAKE SURE THE CATEGORY METADATA MATCHES BEFORE
  # ATTEMPTING TO MATCH THE CONTENT

  cat.meta <- check_categories_meta(dc)

  if (!cat.meta$match) {
    me$match <- FALSE
    me$report <- "MAKE SURE THE CATAGORY METADATA MATCHES BEFORE ATTEMPTING TO MATCH CONTENT"
    me$cat.meta <- cat.meta
  } else {

    f <- dc$f
    q <- dc$q

    # CHECK FOR DUPLICATES

    fcat <- f$key_cat_var
    if (length(fcat) != length(unique(fcat)))
      me$warning <- "f datapoints has duplicate category-variable rows"

    qcat <- q$key_cat_var
    if (length(qcat) != length(unique(qcat)))
      me$warning <- "q datapoints has duplicate category-variable rows"

    # CHECK FOR MATCHING CONTENT

    common_cat_keys <- sqldf::sqldf("

      SELECT F.key_cat_var
      FROM f F
      JOIN q Q
        ON F.key_cat_var = Q.key_cat_var")$key_cat_var

    f_cat_keys <- f$key_cat_var[!f$key_cat_var %in% common_cat_keys]
    q_cat_keys <- q$key_cat_var[!q$key_cat_var %in% common_cat_keys]

    in_f_but_not_q <- filter(f, key_cat_var %in% f_cat_keys)
    in_q_but_not_f <- filter(q, key_cat_var %in% q_cat_keys)

    nrow_f <- nrow(in_f_but_not_q)
    nrow_q <- nrow(in_q_but_not_f)

    if (nrow_f == 0 & nrow_q == 0) {
      me$match <- TRUE
    } else {
      me$match <- FALSE
      col.len <- length(names(f)) - 3
      if (nrow_q > 0)
        me$in_q_but_not_f <- in_q_but_not_f[, 1:col.len]
      if (nrow_f > 0)
        me$in_f_but_not_q <- in_f_but_not_q[, 1:col.len]
    }

  }

  class(me) <- append(class(me),"check_categories_content")

  me

}
