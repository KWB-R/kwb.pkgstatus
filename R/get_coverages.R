#' get_coverage
#' @param repo_full_name one combination of username/repo (e.g."KWB-R/kwb.db")
#' @param codecov_token  zenodo authentication token (default: 
#' getOption("codecov_token")
#' @param dbg debug if TRUE (default: TRUE) 
#' @importFrom httr status_code
#' @return codecov coverage in percent for provided repo_full_name
get_coverage <- function(repo_full_name, 
                         codecov_token = getOption("codecov_token"), 
                         dbg = TRUE) {
  
  
  url <- sprintf("https://codecov.io/api/gh/%s", repo_full_name)
  
  if(dbg) cat(sprintf("Checking code coverage for %s at %s", 
                      repo_full_name, 
                      url))
  
  req <- sprintf("%s?access_token=%s",
                 url,
                 codecov_token)
  if(httr::status_code(httr::GET(url = req)) == 200L) {
    codecov_data <- jsonlite::fromJSON(req)
    
    if(!is.null(codecov_data$commit$totals$c)) {
      codecov_coverage <- round(as.numeric(codecov_data$commit$totals$c),
                                digits = 2)
    } else {
      codecov_coverage <- NA 
    }
  } else {
    codecov_coverage <- NA
  }
  
  if(dbg) cat(sprintf("....%3.1f%%\n", codecov_coverage))
  return(codecov_coverage)
}

#' get_coverage
#' @param repo_full_names vector with combination of username/repo (e.g.
#' c("KWB-R/kwb.utils", "KWB-R/kwb.db"))
#' @param codecov_token  zenodo authentication token (default: 
#' getOption("codecov_token")
#' @param dbg debug if TRUE (default: TRUE) 
#' @return data.frame with coverage percent and url for all provided 
#' repo_full_names
#' @export
get_coverages <- function (repo_full_names, 
                           codecov_token = getOption("codecov_token"), 
                           dbg = TRUE) {
  coverage_percent <- rep(NA, 
                          length = length(repo_full_names))
  coverage_url <- rep(NA, 
                      length = length(repo_full_names))
  
  for (index in seq_along(repo_full_names)) {
    coverage_percent[index] <- get_coverage(
      repo_full_name = repo_full_names[index], 
      codecov_token, 
      dbg)
  }
  
  
  available_indices <- which(!is.na(coverage_percent))
  
  coverage_url[available_indices] <- sprintf("https://codecov.io/gh/%s", 
                                             repo_full_names[available_indices])
  return(data.frame(Coverage = coverage_percent, 
                    Coverage_url = coverage_url))
}