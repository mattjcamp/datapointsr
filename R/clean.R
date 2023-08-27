
#' Clean Dataset
#'
#' Clean a dataset
#' @description Transforms dataset by rounding numerics and removing all
#' variations of
#' NULL and NA and replacing them with blank characters. This can be used
#' to quickly test datasets with weird formats.
#' @param ds The source dataset
#' @keywords dataset, utility, QC
#' @export

clean <- function(ds){

  round_numeric <- function(x) {
    if(is.numeric(x)) {
      return(round(x, 1))
    } else {
      return(x)
    }
  }

  d <- ds %>%
    mutate_if(is.numeric, round_numeric) %>%
    mutate_all(~ ifelse(is.na(.), "", as.character(.))) %>%
    mutate_all(~ str_replace_all(., "\\bNULL\\b", "")) %>%
    mutate_all(~ str_replace_all(., "\\bNA\\b", ""))

  d

}
