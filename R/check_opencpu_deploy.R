#' check_opencpu_deploy: get all Github repos that are deployed on OpenCpu 
#' @description Direct deployment of R packages (including vignette build) by 
#' using webhooks as described in OpenCpu blog post 
#' (https://www.opencpu.org/posts/opencpu-release-1-4-5/) and online help 
#' (https://www.opencpu.org/cloud.html)
#' @param group username or organisation for Github (default: "KWB-R")
#' @return data.frame containing names with OpenCpu badges for all Github 
#' repositories that are deployed on OpenCpu (default: https://kwb-r.ocpu.io) 
#' @export

check_opencpu_deploy <- function(group = "KWB-R")
{
  ocpu_url <- compose_url(
    protocol = "https", 
    subdomain = tolower(group), 
    domain_name = "ocpu.io"
  )
  
  repo_names <- readLines(ocpu_url)
  
  ocpu_urls <- sprintf("%s/%s", ocpu_url, repo_names)
  
  data.frame(
    name = repo_names,
    OpenCpu = badge_opencpu(ocpu_urls),
    stringsAsFactors = FALSE
  )
}
