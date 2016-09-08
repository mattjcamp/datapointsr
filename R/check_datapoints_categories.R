
#' Check Data Points Categories
#'
#' Returns an object that holds two datasets in data points format, use
#' with functions that compare datapoints
#' @param f a data points object provided by the fulfiller
#' @param q a data points object produced by the qc'er
#' @keywords dataset, utility, QC
#' @export
#' @examples

check_datapoints_categories <- function(datapoints.compare){

  me <- list()

  # MAKE SURE datapoints.compare IS IN THE EXPECTED FORMAT

  # CHECK CLASS

  if (!"DataPoints_Compare" %in% class(datapoints.compare))
    stop("datapoints.compare must be DataPoints_Compare object")

  me$report <- "Check Categories"

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

  me

}

f <- quakes
q <- quakes
f$Sigma <- "999"
f$G <- "Good"
q <- q[order(q$long), ]
q[56, 3] <- 1234
q$New_Cat <- "MEOW"
f <- datapoints(f, c(1,2,5,6,7))
q <- datapoints(q, c(1,2,5,6))
d <- compare_datapoints(f, q)

check.cat <- check_datapoints_categories(d)
check.cat
