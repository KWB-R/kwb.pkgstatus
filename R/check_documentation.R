#' url_success
#' @param url url of documentation website
#' @importFrom httr status_code GET
#' @return TRUE in case HTTP status code is 200, if not: FALSE

url_success <- function(url) {
  identical(httr::status_code(x = httr::GET(url)), 200L)
}

#' Check documentation: development 
#' @param repo_names vector of repository names to be checked 
#' @param url main url for Github pages (default: "http://kwb-r.github.io")
#' @return character vector with links in case documentation of development 
#' version for R packages is available 
#' @export
check_docu_dev <- function(repo_names, 
                           url = "http://kwb-r.github.io") {
  
  
  sapply(X = repo_names, FUN = function(repo) {
    url_docu_dev <- sprintf("%s/%s/dev/index.html", url, repo)
    docu_available <- url_success(url = url_docu_dev)
    if(docu_available) { 
      sprintf("[X](%s)", url_docu_dev)
    } else {
      ""
    }})
}

#' Check documentation: release
#' @param repo_names vector of repository names to be checked 
#' @param url main url for Github pages (default: "http://kwb-r.github.io")
#' @return character vector with links in case documentation of latest release
#' for R packages is available 
#' @export
check_docu_release <- function(repo_names, 
                               url = "http://kwb-r.github.io") {
  
  
  sapply(X = repo_names, FUN = function(repo) {
    url_docu_release <- sprintf("%s/%s/index.html", url, repo)
    docu_available <- url_success(url = url_docu_release)
    if(docu_available) { 
      sprintf("[X](%s)", url_docu_release)
    } else {
      ""
    }})
}
