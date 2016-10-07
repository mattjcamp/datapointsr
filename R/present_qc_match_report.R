#' Present QC Report
#'
#' Returns a HTML formated report detailing the results of a QC Match
#' Analysis
#' @param dc is a compare_datapoints objects containing both the f and q datapoints
#' @param qc_title the title that you would like to appear in the QC match report
#' @keywords QC
#' @export
#' @examples

present_qc_match_report <- function(dc, qc_title = ""){

  if (!"compare_datapoints" %in% class(dc))
    stop("dc must be a compare_datapoints object")

  library(stringr)

  dataframe.as.html <- function(df){

    if (!is.null(df)) {

      # library(xtable)
      # 
      # html_table <- print(xtable(df),
      #                     type = "html",
      #                     include.rownames = FALSE)
      # 
      # html_table <- str_replace(html_table,
      #                           "border=1",
      #                           "border=0")
      # html_table <- sprintf("<center>%s</center>", html_table)
      
      library(knitr)
      html_table <- kable(df)

    } else {

      html_table <- ""

    }

    html_table

  }

  # TEST THREE LEVELS OF MATCHING

  match <- check_value_content(dc)

  if (match$match$result == TRUE)
    html <- sprintf("<div id = 'status_passed'><strong><big><big>%s</big></big></strong><br>", qc_title)
  else
    html <- sprintf("<div id = 'status_failed'><strong><big><big>%s</big></big></strong><br>", qc_title)


  if (!match$match$result) {

    cat.meta.match <- check_categories_meta(dc)
    cat.match <- check_categories_content(dc)

    html <- sprintf("%s<strong>Mismatched Data Points</strong><br> f and q are not matching:<br>", html)

    if (!cat.meta.match$match) {

      tab <- dataframe.as.html(cat.meta.match$Category_Comparison)
      html <- sprintf("%s<strong>Category Meta Data is Mismatched</strong><br>%s", html, tab)

    } else {

      if (!cat.match$match) {

        html <- sprintf("%s<strong>Category Content (Row) Data is Mismatched</strong><br>", html)

        if (!is.null(cat.match$in_f_but_not_q)) {

          d <- cat.match$in_f_but_not_q
          d <- d[, 1:length(names(d)) - 1]

          tab <- dataframe.as.html(head(d))
          html <- sprintf("%s<strong>Top 5 Categories Present In F But Not Q</strong><br>%s", html,tab)
        }

        if (!is.null(cat.match$in_q_but_not_f)) {

          d <- cat.match$in_q_but_not_f
          d <- d[, 1:length(names(d)) - 1]

          tab <- dataframe.as.html(head(d))
          html <- sprintf("%s<strong>Top 5 Categories Present In Q But Not F</strong><br>%s", html,tab)
        }

      } else {

        html <- sprintf("%s<strong>Value Content (Row) Data is Mismatched</strong><br>", html)

        if (!is.null(match$side_by_side_f_q)) {

          d <- filter(match$side_by_side_f_q, Match == FALSE)


          tab <- dataframe.as.html(head(d))
          html <- sprintf("%s<strong>Top 5 Mismatched Values </strong><br>%s", html,tab)
        }

      }

    }


  } else {

    # PUT SUCCESS TEXT HERE

    html <- sprintf("%s<strong>Value Content is Matched</strong><br>", html)

    v <- 1:nrow(dc$f)
    s <- sample(v, 5)

    f <- dc$f[s, ]
    q <- dc$q[s, ]

    side_by_side_f_q <- sqldf("
        SELECT F.*, F.Value AS Value_F, Q.Value AS Value_Q
        FROM f F
        JOIN q Q
          ON F.key_cat_var = Q.key_cat_var")

    side_by_side_f_q$Value <- NULL
    side_by_side_f_q$key <- NULL
    side_by_side_f_q$key_cat <- NULL
    side_by_side_f_q$key_cat_var <- NULL

    tab <- dataframe.as.html(head(side_by_side_f_q))
    html <- sprintf("%s<strong>Random 5 Value Rows (Sanity Check) </strong><br>%s", html, tab)



  }

   html <- sprintf("%s</div>", html)

  html

}
