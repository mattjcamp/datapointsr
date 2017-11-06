#' Show Mismatched Data Points
#'
#' @description
#' @param match_dp
#' @export
#' @examples

show_both <- function(match_dp){

  if (!"match_data_points" %in% class(match_dp))
    stop("show_mismatched_data_points: dp must be match_data_points object")

  match_dp$ds %>% filter(is == "in_both", !match)

}

