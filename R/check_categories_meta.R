
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

  if (!"DataPoints_Compare" %in% class(dc))
    stop("dc must be DataPoints_Compare object")

  me$report <- "CHECK CATEGORY META"

  test <- compare(names(dc$f), names(dc$q))
  if (test$equal)
    me$status <- "Category meta matches 100%"

  if (!test$equal) {

    num.cat.f <- length(names(dc$f)) - 4
    num.cat.q <- length(names(dc$q)) - 4
    names.f <- names(dc$f)[1:num.cat.f]
    names.q <- names(dc$q)[1:num.cat.q]

    if (num.cat.f != num.cat.q)
      me$Num_of_Categories <- "f and q do not have the same number of categories"

    cat.not.in.f <- names.q[!(names.q %in% names.f)]
    if (length(cat.not.in.f) > 0)
      me$Categories_Not_In_F_But_In_Q <- cat.not.in.f

    cat.not.in.q <- names.f[!(names.f %in% names.q)]
    if (length(cat.not.in.q) > 0)
      me$Categories_Not_In_Q_But_In_F <- cat.not.in.q

    # CHECK ORDER OF CATEGORIES IF NUMBER IS THE SAME
    # AND THERE IS NO OVERLAP

    # CHECK CLASS AND MODE IF THE CATEGORIES ARE THE SAME

  }

  me

}
