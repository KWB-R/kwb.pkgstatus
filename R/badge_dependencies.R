#' badge_dependencies
#' @param repo_names vector of repository names (e.g. c("kwb.utils", "kwb.db"))
#' @return dependency badges for provided repo_names  
#' @export
badge_dependencies <- function(repo_names) {
  paste0("[![Dependencies_badge](https://kwb-githubdeps.netlify.app/badge/",
         repo_names,
        ")](https://kwb-githubdeps.netlify.app")
}




