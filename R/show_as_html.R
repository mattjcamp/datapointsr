#' Show Match as HTML
#'
#' Summarizes the results of a match QC with HTML for R Markdown display
#' @param matched_data_points \link[datapointsr]{matched_data_points} analysis object
#' @param title text title to include in the report
#' @export
#' @examples

show_as_html <- function(matched_data_points, title){

  if (!"match_data_points" %in% class(matched_data_points))
    stop("show_as_html: matched_data_points must be a match_data_points object")

  if (matched_data_points$match$equal) {

    # PERFECT MATCH
    
    html <- sprintf("<div id = 'status_passed'><strong><big><big>%s</big></big></strong><br>", title)
    html <- sprintf("%s<strong>The content in both datasets matches completely.</strong><br>", html)
    v <- 1:nrow(matched_data_points$ds)
    s <- sample(v, 15, replace = TRUE)
    tab <- knitr::kable(matched_data_points$ds[s,], format = "html")
    html <- sprintf("%s<strong>Sanity Check: Randomly Selected Values </strong><br>%s", html, tab)
    html <- sprintf("%s</div>", html)
    
  } else {

    html <- sprintf("<div id = 'status_failed'><strong><big><big>%s</big></big></strong><br>", title)
    html <- sprintf("%s<strong>The datasets are mismatched...</strong><br>", html)
    
    # SHOW MISMATCHED METADATA
    
    if (!matched_data_points$match_meta$equal) {
      md_mismatched <- bind_rows(matched_data_points$ds_meta %>% filter(is.na(match)),
                                 matched_data_points$ds_meta %>% filter(match == FALSE))
      tab <- knitr::kable(md_mismatched, format = "html")
      html <- sprintf("%s<strong>The metadata in both datasets doesn't completely match</strong><br>%s", html, tab)
    }
    
    # SHOW MISSING CATEGORIES
    
    r <- matched_data_points$ds %>% group_by(is) %>% count()
    
    if ("only_in_f" %in% r$is) {
      tab <- knitr::kable(matched_data_points$ds %>% filter(is == "only_in_f") %>% head(), format = "html")
      html <- sprintf("%s<strong>Some values only appear in the fulfiller dataset </strong><br>%s", html, tab)
    }
    
    if ("only_in_q" %in% r$is) {
      tab <- knitr::kable(matched_data_points$ds %>% filter(is == "only_in_q") %>% head(), format = "html")
      html <- sprintf("%s<strong>Some values only appear in the qc dataset </strong><br>%s", html, tab)
    }

    # SHOW MISMATCHED VALUES
    
    r <- matched_data_points$ds %>% filter(match == FALSE)
    
    if (nrow(r) > 0) {
      tab <- knitr::kable(r %>% head(), format = "html")
      html <- sprintf("%s<strong>Some values are not equal but appear in both datasets</strong><br>%s", html, tab)
    } else {
      tab <- knitr::kable(matched_data_points$ds %>% head(), format = "html")
      html <- sprintf("%s<strong>Even though categories were off, we still match in content</strong><br>%s", html, tab)
    }
    
    html <- sprintf("%s</div>", html)

  }

  html

}

