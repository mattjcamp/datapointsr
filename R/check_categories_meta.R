
#' Check Meta Categories
#'
#' Compares the types of categories in datapoints
#' @param a datapoints.compare object
#' @keywords dataset, utility, QC
#' @export
#' @examples

check_categories_meta <- function(datapoints.compare){

  me <- list()

  # MAKE SURE datapoints.compare IS IN THE EXPECTED FORMAT

  # CHECK CLASS

  if (!"DataPoints_Compare" %in% class(datapoints.compare))
    stop("datapoints.compare must be DataPoints_Compare object")

  me$report <- "Check Category Metadata"

  num.cat.f <- length(names(datapoints.compare$f)) - 4
  num.cat.q <- length(names(datapoints.compare$q)) - 4
  names.f <- names(datapoints.compare$f)[1:num.cat.f]
  names.q <- names(datapoints.compare$q)[1:num.cat.q]

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

  me

}
