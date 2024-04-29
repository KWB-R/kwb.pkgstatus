#' badge_codecov
#' 
#' @param repo_full_names vector with combination of username/repo (e.g. 
#' c("KWB-R/kwb.utils", "KWB-R/kwb.db"))
#' @return codecov badges for provided repo_full_names  
#' @export

badge_codecov <- function(repo_full_names)
{
  to_full_url <- function(path_pattern) {
    compose_url(
      protocol = "https", 
      domain_name = "codecov.io", 
      path = sprintf(path_pattern, repo_full_names)
    )
  }
  
  image_link(
    image_name = "codecov", 
    image_url = to_full_url("github/%s/branch/master/graphs/badge.svg"),
    link_url = to_full_url("github/%s")
  )
}
