#' badge_cran
#' @param repo_names vector of repository names (e.g. c("kwb.utils", "kwb.db"))
#' @return crank badges for provided repo_names  
#' @export
badge_cran <- function(repo_names) {
  paste0("[![CRAN_Status_Badge](http://www.r-pkg.org/badges/version/",
         repo_names,
        ")](http://www.r-pkg.org/pkg/", 
        repo_names,
        ")")
}




