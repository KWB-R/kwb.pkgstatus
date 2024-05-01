#' Check documentation: development 
#' 
#' @param repo_names vector of repository names to be checked 
#' @param url main url for Github pages (default: "http://kwb-r.github.io")
#' @return character vector with links in case documentation of development 
#' version for R packages is available 
#' @export
check_docu_dev <- function(repo_names, url = "http://kwb-r.github.io")
{
  check_docu_impl(repo_names, url, path_format = "%s/%s/dev/index.html")
}

#' Check documentation: release
#' 
#' @param repo_names vector of repository names to be checked 
#' @param url main url for Github pages (default: "http://kwb-r.github.io")
#' @return character vector with links in case documentation of latest release
#' for R packages is available 
#' @export
check_docu_release <- function(repo_names, url = "http://kwb-r.github.io") 
{
  check_docu_impl(repo_names, url, path_format = "%s/%s/index.html")
}

# check_docu_impl --------------------------------------------------------------
check_docu_impl <- function(repo_names, url, path_format)
{
  sapply(X = repo_names, FUN = function(repo) {
    
    url <- sprintf(path_format, url, repo)
    
    if (!url_success(url = url)) {
      return("")
    }
    
    named_link("X", url)
  })
}
