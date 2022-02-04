#' Match All Data Points
#'
#' Attempts to do an exact 1:1 match between two datasets stored in a data points object.
#' @description match_data_points checks all content including column metadata. If the match is not 100% equal then match_data_points will return datasets describing the differences between the datasets.
#' @param dp  \link[datapointsr]{data_points} object containing the fulfiller dataset a and the QC dataset b
#' @export

match_data_points  <- function(dp){

  if (!"data_points" %in% class(dp))
    stop("match_data_points: dp must be data_points object")

  library(tidyverse)

  me <- list()

  a <- dp$a
  b <- dp$b

  # META DATA

  l_a <- length(names(a)) - 1
  md_a <- data.frame(list(names = names(a)[1:l_a],
                          classes = sapply(a,class)[1:l_a],
                          modes = sapply(a, mode)[1:l_a]))

  l_b <- length(names(b)) - 1
  md_b <- data.frame(list(names = names(b)[1:l_b],
                          classes = sapply(b,class)[1:l_b],
                          modes = sapply(b, mode)[1:l_b]))

  both <- inner_join(md_a, md_b, by = "names") %>%
    mutate(is = "in_both") %>%
    select(is, everything()) %>%
    dplyr::rename(col_name = names,
                  a_class = classes.x,
                  a_mode = modes.x,
                  b_class = classes.y,
                  b_mode = modes.y)

  only_in_a <- anti_join(md_a, md_b, by = "names") %>%
    mutate(is = "in_a") %>%
    select(is, everything()) %>%
    mutate(b_class = NA,
           b_mode = NA) %>%
    dplyr::rename(col_name = names,
                  a_class = classes,
                  a_mode = modes) %>%
    mutate(is = as.character(is),
           col_name = as.character(col_name),
           a_class = as.character(a_class),
           a_mode = as.character(a_mode),
           b_class = as.character(b_class),
           b_mode = as.character(b_mode)) %>%
    select(is, col_name, a_class, a_mode, b_class, b_mode)

  only_in_b <- anti_join(md_b, md_a, by = "names") %>%
    mutate(is = "in_b") %>%
    select(is, everything()) %>%
    mutate(a_class = NA,
           a_mode = NA) %>%
    dplyr::rename(col_name = names,
                  b_class = classes,
                  b_mode = modes) %>%
    mutate(is = as.character(is),
           col_name = as.character(col_name),
           a_class = as.character(a_class),
           a_mode = as.character(a_mode),
           b_class = as.character(b_class),
           b_mode = as.character(b_mode)) %>%
    select(is, col_name, a_class, a_mode, b_class, b_mode)

  ds_meta <-
    bind_rows(both, only_in_a, only_in_b) %>%
    mutate(match = as.character(a_class) == as.character(b_class) & as.character(a_mode) == as.character(b_mode)) %>%
    select(is, match, everything())

  me$match_meta <- testthat::compare(md_a, md_b)
  me$ds_meta <- ds_meta

  # CLEAN ALL TO CHARACTER

  for (i in 1:length(names(a)))
    a[i] <- as.vector(sapply(a[i], as.character))

  for (i in 1:length(names(b)))
    b[i] <- as.vector(sapply(b[i], as.character))

  # MATCH ALL VALUES/CATEGORIES

  both <- NULL
  only_in_a <- NULL
  only_in_b <- NULL

  n <- length(names(a)) - 1
  n <- names(a)[1:n]

  both <- inner_join(a, b, by = n) %>%
    mutate(is = "in_both") %>%
    select(is, everything()) %>%
    dplyr::rename(a_value = value.x,
                  b_value = value.y) %>%
    mutate(a_value = as.character(a_value),
           b_value = as.character(b_value))

  only_in_a <- anti_join(a, b, by = n) %>%
    mutate(is = "only_in_a") %>%
    select(is, everything()) %>%
    dplyr::rename(a_value = value) %>%
    mutate(b_value = NA) %>%
    mutate(a_value = as.character(a_value),
           b_value = as.character(b_value))

  only_in_b <- anti_join(b, a, by = n) %>%
    mutate(is = "only_in_b",
           a_value = NA) %>%
    dplyr::rename(b_value = value) %>%
    select(is, everything(), a_value, b_value) %>%
    mutate(a_value = as.character(a_value),
           b_value = as.character(b_value))

  ds <- bind_rows(both, only_in_a, only_in_b) %>%
    mutate(match = a_value == b_value) %>%
    select(is, match, a_value, b_value, everything()) %>%
    mutate(match = ifelse(is.na(match), ifelse(is.na(a_value) & is.na(b_value), TRUE, FALSE), match),
           match = ifelse(is != "in_both", FALSE, match))

  me$match <- testthat::compare(a, b)
  me$ds <- ds

  class(me) <- append(class(me), "match_data_points")

  me


}

