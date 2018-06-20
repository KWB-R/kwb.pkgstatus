#' badge_appveyor
#' @param repo_full_names vector with combination of username/repo (e.g. 
#' c("KWB-R/kwb.utils", "KWB-R/kwb.db"))
#' @return appveyor badges for provided repo_full_names  
#' @export
badge_appveyor <- function(repo_full_names) {

paste0("[![Appveyor](https://ci.appveyor.com/api/projects/status/github/",
       repo_full_names, 
      "?branch=master&svg=true)](https://ci.appveyor.com/project/",
       gsub(".", "-", repo_full_names, fixed = TRUE),
       "/branch/master)")
}

#' badge_travis
#' @param repo_full_names vector with combination of username/repo (e.g. 
#' c("KWB-R/kwb.utils", "KWB-R/kwb.db"))
#' @return travis badges for provided repo_full_names 
#' @export
badge_travis <- function(repo_full_names) {
  paste0("[![Travis](https://travis-ci.org/", 
  repo_full_names,
".svg?branch=master)](https://travis-ci.org/", 
repo_full_names,
")")
}