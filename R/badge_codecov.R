#' badge_codecov
#' 
#' @param repo_full_names vector with combination of username/repo (e.g. 
#' c("KWB-R/kwb.utils", "KWB-R/kwb.db"))
#' @return codecov badges for provided repo_full_names  
#' @export

badge_codecov <- function(repo_full_names)
{
  to_full_path <- function(path) {
    paste0("github/", repo_full_names, path)
  }
  
  image_link(
    image_name = "codecov", 
    image_url = compose_url_codecov(
      path = to_full_path("/branch/master/graphs/badge.svg")
    ),
    link_url = compose_url_codecov(
      path = to_full_path("")
    )
  )
}
