#' Match All Data Points
#'
#' Attempts to do an exact 1:1 match between two datasets stored in a data points object.
#' @description match_data_points checks all content including column metadata. If the match is not 100% equal then match_data_points will return datasets describing the differences between the datasets.
#' @param dp  \link[datapointsr]{data_points} object containing the fulfiller dataset f and the QC dataset q
#' @export
#' @examples

match_data_points  <- function(dp){

  if (!"data_points" %in% class(dp))
    stop("match_data_points: dp must be data_points object")

  library(tidyverse)

  me <- list()

  f <- dp$f
  q <- dp$q

  # META DATA

  l_f <- length(names(f)) - 1
  md_f <- data.frame(list(names = names(f)[1:l_f],
                          classes = sapply(f,class)[1:l_f],
                          modes = sapply(f, mode)[1:l_f]))

  l_q <- length(names(q)) - 1
  md_q <- data.frame(list(names = names(q)[1:l_q],
                          classes = sapply(q,class)[1:l_q],
                          modes = sapply(q, mode)[1:l_q]))

  both <- inner_join(md_f, md_q, by = "names") %>%
    mutate(is = "in_both") %>%
    select(is, everything()) %>%
    rename(col_name = names,
           f_class = classes.x,
           f_mode = modes.x,
           q_class = classes.y,
           q_mode = modes.y)

  only_in_f <- anti_join(md_f, md_q, by = "names") %>%
    mutate(is = "in_f") %>%
    select(is, everything()) %>%
    mutate(q_class = NA,
           q_mode = NA) %>%
    rename(col_name = names,
           f_class = classes,
           f_mode = modes) %>%
    select(is, col_name, f_class, f_mode, q_class, q_mode)

  only_in_q <- anti_join(md_q, md_f, by = "names") %>%
    mutate(is = "in_q") %>%
    select(is, everything()) %>%
    mutate(f_class = NA,
           f_mode = NA) %>%
    rename(col_name = names,
           q_class = classes,
           q_mode = modes) %>%
    select(is, col_name, f_class, f_mode, q_class, q_mode)

  ds_meta <- bind_rows(both, only_in_f, only_in_q) %>%
    mutate(match = as.character(f_class) == as.character(q_class) & as.character(f_mode) == as.character(q_mode)) %>%
    select(is, match, everything())

  me$match_meta <- testthat::compare(md_f, md_q)
  me$ds_meta <- ds_meta

  # CLEAN ALL TO CHARACTER

  for (i in 1:length(names(f)))
    f[i] <- as.vector(sapply(f[i], as.character))

  for (i in 1:length(names(q)))
    q[i] <- as.vector(sapply(q[i], as.character))

  # MATCH ALL VALUES/CATEGORIES

  both <- NULL
  only_in_f <- NULL
  only_in_q <- NULL

  n <- length(names(f)) - 1
  n <- names(f)[1:n]

  both <- inner_join(f, q, by = n) %>%
    mutate(is = "in_both") %>%
    select(is, everything()) %>%
    rename(f_value = value.x,
           q_value = value.y)

  only_in_f <- anti_join(f, q, by = n) %>%
    mutate(is = "only_in_f") %>%
    select(is, everything()) %>%
    rename(f_value = value) %>%
    mutate(q_value = NA)

  only_in_q <- anti_join(q, f, by = n) %>%
    mutate(is = "only_in_q",
           f_value = NA) %>%
    rename(q_value = value) %>%
    select(is, everything(), f_value, q_value)

  ds <- bind_rows(both, only_in_f, only_in_q) %>%
    mutate(match = f_value == q_value) %>%
    select(is, match, f_value, q_value, everything()) %>%
    mutate(match = ifelse(is.na(match), ifelse(is.na(f_value) & is.na(q_value), TRUE, FALSE), match))

  me$match <- testthat::compare(f, q)
  me$ds <- ds

  class(me) <- append(class(me), "match_data_points")

  me

}

