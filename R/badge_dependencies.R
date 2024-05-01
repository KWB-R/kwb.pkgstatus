#' badge_dependencies
#' 
#' @param repo_names vector of repository names (e.g. c("kwb.utils", "kwb.db"))
#' @return dependency badges for provided repo_names  
#' @export
badge_dependencies <- function(repo_names)
{
  image_link(
    image_name = "Dependencies_badge", 
    image_url = compose_url_netlify(paste0("badge/", repo_names)),
    link_url = compose_url_netlify("")
  )
}
