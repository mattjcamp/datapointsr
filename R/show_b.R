#' Show B Mismatched Data Points
#'
#' @description pulls out a dataframe that shows only values that appeared in the 2nd(b) dataset
#' @param match_dp match_data_points object populated with matching information.
#' @export

show_b  <- function(match_dp){

  if (!"match_data_points" %in% class(match_dp))
    stop("show_mismatched_data_points: dp must be match_data_points object")

  match_dp$ds %>% filter(is == "only_in_b", !match)

}

