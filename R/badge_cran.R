#' badge_cran
#' 
#' @param repo_names vector of repository names (e.g. c("kwb.utils", "kwb.db"))
#' @return crank badges for provided repo_names  
#' @export
badge_cran <- function(repo_names)
{
  to_full_url <- function(path) {
    compose_url(
      protocol = "http", 
      subdomain = "www", 
      domain_name = "r-pkg.org", 
      path = paste0(path, "/", repo_names)
    )
  }
  
  image_link(
    image_name = "CRAN_Status_Badge", 
    image_url = to_full_url("badges/version"),
    link_url = to_full_url("pkg")
  )
}
