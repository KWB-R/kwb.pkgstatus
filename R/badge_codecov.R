#' badge_codecov
#' @param repo_full_names vector with combination of username/repo (e.g. 
#' c("KWB-R/kwb.utils", "KWB-R/kwb.db"))
#' @return codecov badges for provided repo_full_names  
#' @export

badge_codecov <- function(repo_full_names) {
  paste0("[![codecov](https://codecov.io/github/", 
         repo_full_names, 
        "/branch/master/graphs/badge.svg)](https://codecov.io/github/", 
         repo_full_names, 
         ")")

}



