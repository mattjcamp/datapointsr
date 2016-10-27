#' Present Results of a Value Match
#'
#' Returns a HTML formated report detailing the results of a QC Match
#' Analysis
#' @param dp is a compare_datapoints objects containing both the f and q datapoints
#' @param qc_title the title that you would like to appear in the QC match report
#' @keywords QC
#' @export
#' @examples

report_match_values <- function(dp, qc_title = ""){

  if (!"data.points" %in% class(dp))
    stop("match_category_content: dp must be data.points object")

  # TEST THREE LEVELS OF MATCHING

  match <- match_values(dp)

  if (match$match$equal) {

    # PUT SUCCESS TEXT HERE

    html <- sprintf("<div id = 'status_passed'><strong><big><big>%s</big></big></strong><br>", qc_title)
    html <- sprintf("%s<strong>Values are 100% Matched</strong><br>", html)
    v <- 1:nrow(dp$f)
    s <- sample(v, 15, replace = TRUE)
    tab <- knitr::kable(match$side_by_side_f_q[s,], format = "html")
    html <- sprintf("%s<strong>Sanity Check: Randomly Selected Values </strong><br>%s", html, tab)
    html <- sprintf("%s</div>", html)

  } else {

    # PUT SUCCESS TEXT HERE

    html <- sprintf("<div id = 'status_failed'><strong><big><big>%s</big></big></strong><br>", qc_title)
    html <- sprintf("%s<strong>Values are Not Matching</strong><br>", html)
    tab <- knitr::kable(head(match$mis_matched), format = "html")
    html <- sprintf("%s<strong>Check out these mismatched values </strong><br>%s", html, tab)
    html <- sprintf("%s</div>", html)


  }


  html

}
