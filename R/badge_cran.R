#' badge_cran
#' 
#' @param repo_names vector of repository names (e.g. c("kwb.utils", "kwb.db"))
#' @return crank badges for provided repo_names  
#' @export
badge_cran <- function(repo_names)
{
  to_full_path <- function(path) {
    paste0(path, "/", repo_names)
  }
  
  image_link(
    image_name = "CRAN_Status_Badge", 
    image_url = compose_url_cran(
      path = to_full_path("badges/version")
    ),
    link_url = compose_url_cran(
      path = to_full_path("pkg")
    )
  )
}
