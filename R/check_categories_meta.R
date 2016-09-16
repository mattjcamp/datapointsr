
#' Check Meta Categories
#'
#' Compares the types of categories in datapoints
#' @param dc output from the compare_datapoints function
#' @keywords dataset, utility, QC
#' @export
#' @examples

check_categories_meta <- function(dc){

  me <- list()

  # MAKE SURE dc IS IN THE EXPECTED FORMAT

  # CHECK CLASS

  if (!"compare_datapoints" %in% class(dc))
    stop("dc must be compare_datapoints object")

  me$report <- "CHECK CATEGORY META"

  test <- compare(names(dc$f), names(dc$q))
  if (test$equal) {

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
      mode.f <- mode(names.f)
      mode.q <- mode(names.q)
      class.f <- class(names.f)
      class.q <- class(names.q)

      d <- data.frame(COL_F = names.f,
                      COL_Q = names.q,
                      MODE_F = mode.f,
                      MODE_Q = mode.q,
                      CLASS_F = class.f,
                      CLASS_Q = class.q)
      d <- d %>% mutate(MATCH = COL_F == COL_Q & MODE_F == MODE_Q & CLASS_F == CLASS_Q)
      me$Category_Comparison <- d

    }

  }

  class(me) <- append(class(me),"check_categories_meta")

  me

}
