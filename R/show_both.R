#' Show Mismatched Data Points
#'
#' Look at mismatched data points.
#'
#' @description pulls out a dataframe that shows only values that are in both datasets but are mismatched
#' @param match_dp match_data_points object populated with matching information.
#' @export

show_both <- function(match_dp){

  if (!"match_data_points" %in% class(match_dp))
    stop("show_mismatched_data_points: dp must be match_data_points object")

  match_dp$ds %>% filter(is == "in_both", !match)

}

