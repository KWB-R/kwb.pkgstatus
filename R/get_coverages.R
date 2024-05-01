#' get_coverage
#' 
#' @param repo_full_name one combination of username/repo (e.g."KWB-R/kwb.db")
#' @param codecov_token codecov authentication token.
#'   Default: kwb.pkgstatus:::get_token("CODECOV")
#' @param dbg debug if TRUE (default: TRUE) 
#' @importFrom httr status_code
#' @return codecov coverage in percent for provided repo_full_name
get_coverage <- function(
    repo_full_name, 
    codecov_token = get_token("CODECOV"), 
    dbg = TRUE
)
{
  url <- compose_url_codecov(
    path = paste0("api/gh/", repo_full_name)
  )
  
  cat_if(dbg, "Checking code coverage for %s at %s", repo_full_name, url)
  
  req <- paste0(url, url_parameter_string(access_token = codecov_token))
  
  if (url_success(req)) {
    
    codecov_data <- jsonlite::fromJSON(req)
    
    if (!is.null(codecov_data$commit$totals$c)) {
      
      codecov_coverage <- round(
        as.numeric(codecov_data$commit$totals$c),
        digits = 2
      )
      
    } else {
      
      codecov_coverage <- NA 
    }
    
  } else {
    
    codecov_coverage <- NA
  }
  
  cat_if(dbg, "....%3.1f%%\n", codecov_coverage)
  
  codecov_coverage
}

#' get_coverages
#' 
#' @param repo_full_names vector with combination of username/repo
#'   (e.g. c("KWB-R/kwb.utils", "KWB-R/kwb.db"))
#' @param codecov_token codecov authentication token.
#'   Default: kwb.pkgstatus:::get_token("CODECOV")
#' @param dbg debug if TRUE (default: TRUE) 
#' @return data.frame with coverage percent and url for all provided 
#' repo_full_names
#' @export
get_coverages <- function(
    repo_full_names, 
    codecov_token = get_token("CODECOV"), 
    dbg = TRUE
)
{
  coverage_percent <- na_along(repo_full_names)
  coverage_url <- na_along(repo_full_names)
  
  for (index in seq_along(repo_full_names)) {
    coverage_percent[index] <- get_coverage(
      repo_full_name = repo_full_names[index], 
      codecov_token, 
      dbg
    )
  }
  
  available_indices <- which(!is.na(coverage_percent))
  
  coverage_url[available_indices] <- compose_url_codecov(
    path = paste0("gh/", repo_full_names[available_indices])
  )
  
  data.frame(
    Coverage = coverage_percent, 
    Coverage_url = coverage_url
  )
}
