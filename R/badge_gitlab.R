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
    logo_path = compose_url(
      protocol = "https", 
      domain_name = "gitlab.com", 
      path = "gitlab-com/gitlab-artwork/raw/master/logo/logo-square.png"
    ),
    size = 24
)
{
  img_attr <- sprintf(" title='Gitlab' width='%d' height = '%d'", size, size)
  
  logo_path %>% 
    html_img(img_attr) %>%
    html_a(href = url)
}
