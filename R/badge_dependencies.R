#' badge_dependencies
#' 
#' @param repo_names vector of repository names (e.g. c("kwb.utils", "kwb.db"))
#' @return dependency badges for provided repo_names  
#' @export
badge_dependencies <- function(repo_names)
{
  to_url <- function(path) {
    compose_url(
      protocol = "https", 
      subdomain = "kwb-githubdeps", 
      domain_name = "netlify.app", 
      path = path
    )
  }
  
  image_link(
    image_name = "Dependencies_badge", 
    image_url = to_url(paste0("badge/", repo_names)),
    link_url = to_url("")
  )
}
