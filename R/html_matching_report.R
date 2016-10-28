#' Present Results of a Match
#'
#' Returns a HTML formated report detailing the results of a QC Match
#' Analysis
#' @param dp is a compare_datapoints objects containing both the f and q datapoints
#' @param qc_title the title that you would like to appear in the QC match report
#' @keywords QC
#' @export
#' @examples

html_matching_report <- function(dp, qc_title = ""){

  if (!"data.points" %in% class(dp))
    stop("html_matching_report: dp must be data.points object")

  # TEST THREE LEVELS OF MATCHING

  values <- match_values(dp)

  if (values$equal) {

    # PUT SUCCESS TEXT HERE

    html <- sprintf("<div id = 'status_passed'><strong><big><big>%s</big></big></strong><br>", qc_title)
    html <- sprintf("%s<strong>Values are matched</strong><br>", html)
    v <- 1:nrow(dp$f)
    s <- sample(v, 15, replace = TRUE)
    values <- show_values(dp)
    tab <- knitr::kable(values$d[s,], format = "html")
    html <- sprintf("%s<strong>Sanity Check: Randomly Selected Values </strong><br>%s", html, tab)
    html <- sprintf("%s</div>", html)

  } else {

    # PUT SUCCESS TEXT HERE

    html <- sprintf("<div id = 'status_failed'><strong><big><big>%s</big></big></strong><br>", qc_title)
    html <- sprintf("%s<strong>Values are Not valuesing</strong><br>", html)
    values <- show_values(dp)
    tab <- knitr::kable(head(values$mis_valuesed), format = "html")
    html <- sprintf("%s<strong>Check out these misvaluesed values </strong><br>%s", html, tab)
    html <- sprintf("%s</div>", html)

  }

  html

}
