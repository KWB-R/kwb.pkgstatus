#' badge_opencpu
#' @param url url to repository on Gitlab
#' @param logo_path path to OpenCpu logo (default: 
#' "https://avatars2.githubusercontent.com/u/28672890?s=200&v=4")
#' @param size size of logo in pixels (default: 24)
#' @return OpenCpu logo in html with path to R package on OpenCpu  
#' @export

badge_opencpu <- function(url, logo_path = compose_url_opencpu(), size = 24)
{
  logo_path %>% 
    html_img(title = "OpenCpu", width = size, height = size) %>% 
    html_a(href = url)
}
