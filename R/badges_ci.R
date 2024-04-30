#' badge_appveyor
#' 
#' @param repo_full_names vector with combination of username/repo (e.g. 
#' c("KWB-R/kwb.utils", "KWB-R/kwb.db"))
#' @return appveyor badges for provided repo_full_names  
#' @export
badge_appveyor <- function(repo_full_names)
{
  to_url <- function(path, parameters) {
    compose_url(
      protocol = "https", 
      subdomain = "ci", 
      domain_name = "appveyor.com",
      path = path, 
      parameters = parameters
    )
  }
  
  image_link(
    image_name = "Appveyor", 
    image_url = to_url(
      path = sprintf("api/projects/status/github/%s", repo_full_names), 
      parameters = list(branch = "master", svg = "true")
    ),
    link_url = to_url(
      path = sprintf("project/%s/branch/master", dot_to_dash(repo_full_names)),
      parameters = list()
    )
  )
}

#' badge_travis
#' 
#' @param repo_full_names vector with combination of username/repo (e.g. 
#' c("KWB-R/kwb.utils", "KWB-R/kwb.db"))
#' @return travis badges for provided repo_full_names 
#' @export
badge_travis <- function(repo_full_names)
{
  to_url <- function(path, parameters) {
    compose_url(
      protocol = "https", 
      domain_name = "travis-ci.org",
      path = path, 
      parameters = parameters
    )
  }
  
  image_link(
    image_name = "Travis", 
    image_url = to_url(
      path = sprintf("%s.svg", repo_full_names),
      parameters = list(branch = "master")
    ),
    link_url = to_url(
      path = repo_full_names,
      parameters = list()
    )
  )
}
