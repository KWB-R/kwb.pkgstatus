#' badge_gitlab
#' 
#' @param url url to repository on Gitlab
#' @param logo_path path to Gitlab logo (default: 
#' "https://gitlab.com/gitlab-com/gitlab-artwork/raw/master/logo/logo-square.png")
#' @param size size of logo in pixels (default: 24)
#' @return Gitlab logo in html with path to repository in Gitlab  
#' @export
badge_gitlab <- function(
    url, 
    logo_path = compose_url_gitlab(
      path = "gitlab-com/gitlab-artwork/raw/master/logo/logo-square.png"
    ),
    size = 24
)
{
  logo_path %>% 
    html_img(title = "Gitlab", width = size, height = size) %>%
    html_a(href = url)
}
