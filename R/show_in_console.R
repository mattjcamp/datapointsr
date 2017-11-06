#' Show Match in Console
#'
#' Summarizes the results of a match QC
#' @param matched_data_points match_dp match_data_points object populated with matching information.
#' @export
#'
show_in_console <- function(matched_data_points){

  if (!"match_data_points" %in% class(matched_data_points))
    stop("show_in_console: matched_data_points must be a match_data_points object")

  if (matched_data_points$match$equal)
      if (matched_data_points$match_meta$equal)
        m <- "The content and metadata in both datasets matches completely."
      else
        m <- "The metadata in these datasets is off, but the content does match."
  else
    m <- "The datasets are mismatched..."

  m

}
