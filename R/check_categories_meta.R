
#' Check Meta Categories
#'
#' Compares the types of categories in datapoints
#' @param dc output from the compare_datapoints function
#' @keywords dataset, utility, QC
#' @export
#' @examples

check_categories_meta <- function(dc){

  library(dplyr)
  library(compare)

  me <- list()

  if (!"compare_datapoints" %in% class(dc))
    stop("dc must be compare_datapoints object")

  me$report <- "CHECK CATEGORY META"

  test1 <- compare(names(dc$f), names(dc$q))
  len_f <- length(names(dc$f)) - 4
  len_q <- length(names(dc$q)) - 4
  len <- len_f

  f_c <- sapply(dc$f, class)[1:len_f]
  q_c <- sapply(dc$q, class)[1:len_f]
  test2 <- compare(f_c, q_c)

  if (test1$result == TRUE & test2$result == TRUE) {

    me$match <- TRUE

  } else {

    f <- dc$f
    q <- dc$q

    me$match <- FALSE
    num.cat.f <- length(names(f)) - 4
    num.cat.q <- length(names(q)) - 4
    names.f <- names(f)[1:num.cat.f]
    names.q <- names(q)[1:num.cat.q]

    if (num.cat.f != num.cat.q) {

      me$Num_of_Categories <- "f and q do not have the same number of categories"

      cat.not.in.f <- names.q[!(names.q %in% names.f)]
      if (length(cat.not.in.f) > 0)
        me$Categories_Not_In_F_But_In_Q <- cat.not.in.f

      cat.not.in.q <- names.f[!(names.f %in% names.q)]
      if (length(cat.not.in.q) > 0)
        me$Categories_Not_In_Q_But_In_F <- cat.not.in.q

    } else {

      me$Num_of_Categories <- "f and q do have the same number of categories but they are out of order or don't match"
      d <- data.frame(list(COL_F = names.f,
                           COL_Q = names.q,
                           CLASS_F = f_c[1:len],
                           CLASS_Q = q_c[1:len]))
      me$Category_Comparison <- d

    }

  }

  me

}
