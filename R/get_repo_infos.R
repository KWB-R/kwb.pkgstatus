#' get_gitlab_repos
#' @param group username or organisation for Gitlab (default: "KWB-R")
#' @param gitlab_token gitlab access token (default: getOption("gitlab_token"))
#' @return data.frame with for all repositories of the user/organisation defined 
#' in parameter group (private repos will only be accessible if the token is 
#' configured to allow that)
#' @importFrom jsonlite fromJSON
#' @export
get_gitlab_repos <- function(group = "KWB-R", 
                             gitlab_token = getOption("gitlab_token")) { 
  endpoint <- sprintf("https://gitlab.com/api/v4/groups/%s?private_token=%s",
                      group,
                      gitlab_token)
  
  
  gitlab_group <- jsonlite::fromJSON(endpoint)
  
  
  gitlab_group$projects
}


#' get_github_repos
#' @param group username or organisation for Github (default: "KWB-R")
#' @param github_token github access token (default: getOption("github_token"))
#' @return data.frame with for all repositories of the user/organisation defined 
#' in parameter group (private repos will only be accessible if the token is 
#' configured to allow that)
#' @importFrom gh gh
#' @export
get_github_repos <- function (group = "KWB-R", 
                              github_token = getOption("github_token")) {
  
  
  gh_repos <- gh::gh(endpoint = sprintf("GET /orgs/%s/repos?per_page=100", 
                                        group), 
                     .token =  github_token)
  
  for (repo_ind in seq_along(gh_repos)) {
    
    sel_repo <- gh_repos[[repo_ind]]
    
    tmp <- data.frame(name = sel_repo$name,
                      full_name = sel_repo$full_name,
                      url = sel_repo$html_url,
                      created_at = sel_repo$created_at, 
                      pushed_at = sel_repo$pushed_at,
                      open_issues = sel_repo$open_issues,
                      license_key = ifelse(is.null(sel_repo$license$key),
                                           NA, sel_repo$license$key), 
                      license_short = ifelse(is.null(sel_repo$license$spdx_id),
                                             NA, sel_repo$license$spdx_id), 
                      license_link = ifelse(is.null(sel_repo$license$spdx_id),
                                            NA, 
                                            sprintf("https://github.com/%s/blob/master/LICENSE", 
                                                    sel_repo$full_name)),
                      stringsAsFactors = FALSE)
    
    
    tmp$Repository <-  sprintf("[%s](%s)", tmp$name, tmp$url)  
    
    tmp$License <- ifelse(is.na(tmp$license_short),
                          NA, 
                          sprintf("[%s](%s)", 
                                  tmp$license_short, 
                                  tmp$license_link))
    
    if (repo_ind == 1) {
      res <- tmp
    } else {
      res <- rbind(res,tmp)
    }
  } 
  res <- res[order(res$name,decreasing = FALSE), ]
  return(res)
}




badge_cran <- function(repo_names) {
  sprintf("[![CRAN_Status_Badge](http://www.r-pkg.org/badges/version/%s)](http://www.r-pkg.org/pkg/%s)", 
          repo_names,
          repo_names)
}

badge_codecov <- function(repo_full_names) {
  sprintf("[![codecov](https://codecov.io/github/%s/branch/master/graphs/badge.svg)](https://codecov.io/github/%s)",
          repo_full_names,
          repo_full_names)
  
  # sprintf("![codecov](https://img.shields.io/codecov/c/github/%s/master.svg", 
  #           repo_full_names)
}

badge_license <- function(license_keys, 
                          github_token = getOption("github_token")) {
  gh_licenses <- gh::gh(endpoint = "GET /licenses", 
                        .token =  github_token)
  
  gh_licenses_df <- data.table::rbindlist(gh_licenses, fill=TRUE)
  
  
  #### License badges from: https://gist.github.com/lukas-h/2a5d00690736b4c3a7ba
  license_badges <- data.frame(key = c("agpl-3.0", 
                                       "apache-2.0", 
                                       "bsd-2-clause", 
                                       "bsd-3-clause", 
                                       "epl-2.0",
                                       "gpl-2.0",
                                       "gpl-3.0",    
                                       "lgpl-2.1",
                                       "lgpl-3.0", 
                                       "mit", 
                                       "mpl-2.0", 
                                       "unlicense"),   
                               badge_url = c("https://img.shields.io/badge/License-AGPL%20v3-blue.svg", 
                                             "https://img.shields.io/badge/License-Apache%202.0-blue.svg",
                                             "https://img.shields.io/badge/License-BSD%202--Clause-orange.svg",
                                             "https://img.shields.io/badge/License-BSD%203--Clause-blue.svg",
                                             "",
                                             "https://img.shields.io/badge/License-GPL%20v2-blue.svg",
                                             "https://img.shields.io/badge/License-GPL%20v3-blue.svg",    
                                             "",
                                             "https://img.shields.io/badge/License-LGPL%20v3-blue.svg", 
                                             "https://img.shields.io/badge/License-MIT-yellow.svg", 
                                             "https://img.shields.io/badge/License-MPL%202.0-brightgreen.svg", 
                                             "https://img.shields.io/badge/license-Unlicense-blue.svg"),
                               license_url = c("https://opensource.org/licenses/AGPL-3.0", 
                                               "https://opensource.org/licenses/Apache-2.0", 
                                               "https://opensource.org/licenses/BSD-2-Clause", 
                                               "https://opensource.org/licenses/BSD-3-Clause", 
                                               "https://www.eclipse.org/legal/epl-2.0/",
                                               "https://www.gnu.org/licenses/gpl-2.0",
                                               "https://www.gnu.org/licenses/gpl-3.0",    
                                               "https://www.gnu.org/licenses/lgpl-2.1",
                                               "https://www.gnu.org/licenses/lgpl-3.0", 
                                               "https://opensource.org/licenses/MIT", 
                                               "https://opensource.org/licenses/MPL-2.0", 
                                               "http://unlicense.org/"),
                               stringsAsFactors = FALSE) 
  
  gh_licenses_df <- dplyr::left_join(gh_licenses_df, 
                                     license_badges) 
  
  gh_licenses_df$Badge_License <- sprintf("[![%s](%s)](%s)", 
                                          gh_licenses_df$spdx_id, 
                                          gh_licenses_df$badge_url,
                                          gh_licenses_df$license_url)
  
  badges <- gh_licenses_df %>%  
    dplyr::select_(~key, ~Badge_License) %>%  
    dplyr::rename_(license_key = ~key)
  
  
  res <- dplyr::left_join(x = data.frame(license_key = license_keys, 
                                         stringsAsFactors = FALSE), 
                          y = badges)
  
  return(res$Badge_License)
}


badge_appveyor <- function(repo_full_names) {
  sprintf("[![Appveyor](https://ci.appveyor.com/api/projects/status/github/%s?branch=master&svg=true)](https://ci.appveyor.com/project/%s/branch/master)", 
          repo_full_names,
          gsub(".", "-", repo_full_names, fixed = TRUE))
}

badge_travis <- function(repo_full_names) {
  sprintf("[![Travis](https://travis-ci.org/%s.svg?branch=master)](https://travis-ci.org/%s)", 
          repo_full_names,
          repo_full_names)
}


process_hitter_response <- function (response) 
{
  res <- lapply(response, function(s) data.frame(t(unlist(s))))
  dplyr::tbl_df(data.table::rbindlist(res, fill = TRUE))
}

zen_collections <- function (access_token = getOption("zenodo_token")) 
{
  dir_path <- "https://zenodo.org/api/deposit/depositions"
  args <- as.list(c(access_token = access_token))
  results <- httr::GET(dir_path, query = args)
  request <- httr::content(results)
  process_hitter_response(request)
}


badge_zenodo <- function(repo_full_names, 
                         zenodo_token = getOption("zenodo_token")) {
  
  zen_data <- zen_collections(zenodo_token)
  
  zen_badge <- rep(NA, length = length(repo_full_names))
  
  for (index in seq_along(repo_full_names)) {
    doi_exists <- stringr::str_detect(string = zen_data$metadata.related_identifiers.identifier, 
                                      pattern = sprintf("https://github.com/%s", 
                                                        repo_full_names[index]))
    doi_exists[is.na(doi_exists)] <- FALSE
    
    if(sum(doi_exists) == 1) {
      
      zen_badge[index] <- sprintf("[![DOI](%s)](%s)", 
                                  zen_data$links.badge[doi_exists], 
                                  zen_data$doi_url[doi_exists])
      
    } else if (sum(doi_exists) > 1) {
      warn_msg <- sprintf("Multiple entries found for repo '%s':\n%s",
                          repo_full_names[index], 
                          paste(zen_data$metadata.related_identifiers.identifier[doi_exists],
                                collapse = "\n"))
      warning(warn_msg)
      zen_badge[index] <- "Multiple badges found!"
    } else {
      zen_badge[index] <- NA
    }
  }
  return(zen_badge)   
}


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
      codecov_coverage <- round(as.numeric(codecov_data$commit$totals$c),digits = 2)
    } else {
      codecov_coverage <- NA 
    }
  } else {
    codecov_coverage <- NA
  }
  
  if(dbg) cat(sprintf("....%3.1f%%\n", codecov_coverage))
  return(codecov_coverage)
}

get_coverages <- function (repo_full_names, 
                           codecov_token = getOption("codecov_token"), 
                           dbg = TRUE) {
  coverage_percent <- rep(NA, 
                          length = length(repo_full_names))
  coverage_url <- rep(NA, 
                      length = length(repo_full_names))
  
  for (index in seq_along(repo_full_names)) {
    coverage_percent[index] <- get_coverage(repo_full_name = repo_full_names[index], 
                                            codecov_token, 
                                            dbg)
  }
  
  
  available_indices <- which(!is.na(coverage_percent))
  
  coverage_url[available_indices] <- sprintf("https://codecov.io/gh/%s", 
                                             repo_full_names[available_indices])
  return(data.frame(Coverage = coverage_percent, 
                    Coverage_url = coverage_url))
}
