# get_gitlab_repos -------------------------------------------------------------

#' get_gitlab_repos
#' 
#' @param group username or organisation for Gitlab (default: "KWB-R")
#' @param gitlab_token gitlab access token.
#'   Default: kwb.pkgstatus:::get_gitlab_token()
#' @return data.frame with for all repositories of the user/organisation defined 
#' in parameter group (private repos will only be accessible if the token is 
#' configured to allow that)
#' @importFrom jsonlite fromJSON
#' @export
get_gitlab_repos <- function(
    group = "KWB-R", 
    gitlab_token = get_gitlab_token()
)
{ 
  endpoint <- compose_url_gitlab(
    path = paste0("api/v4/groups/", group),
    token = gitlab_token
  )

  gitlab_group <- jsonlite::fromJSON(endpoint)
  
  gitlab_group$projects
}

# get_github_repos -------------------------------------------------------------

#' get_github_repos
#' 
#' @param group username or organisation for Github (default: "KWB-R")
#' @param github_token github access token.
#'   Default: kwb.pkgstatus:::get_github_token()
#' @return data.frame with for all repositories of the user/organisation defined 
#' in parameter group (private repos will only be accessible if the token is 
#' configured to allow that)
#' @importFrom gh gh
#' @export
get_github_repos <- function(group = "KWB-R", github_token = get_github_token())
{
  #kwb.utils::assignPackageObjects("kwb.pkgstatus");group="kwb-r"
  result <- group %>% 
    get_github_repos_impl(github_token = github_token) %>% 
    lapply(github_repo_object_to_data_row) %>% 
    do.call(what = rbind)
  
  result[order(result[["name"]], decreasing = FALSE), ]
}

# get_github_repos_impl --------------------------------------------------------
get_github_repos_impl <- function(
    group, 
    github_token = get_github_token(),
    per_page = 100L,
    dbg = TRUE
)
{
  all_repos <- list()
  
  # Start with the first page
  page <- 1L
  
  # Read next page while page number is given
  while (page > 0L) {
    
    cat_if(
      dbg, 
      "Reading page %d of %d GitHub repos per page\n", 
      page, 
      per_page
    )
    
    # Read repos from current page  
    repos <- gh::gh(
      endpoint = github_endpoint(group, page, per_page), 
      .token =  github_token
    )
    
    # If the page contained at least one repo...
    if (length(repos) > 0L) {
      
      # ... append repos to the list all_repos
      all_repos[[length(all_repos) + 1L]] <- repos
      
      page <- page + 1L
      
    } else {
      
      # Set page number to zero to finish the while-loop
      page <- 0L
    }
  }
  
  # Combine all repo objects into one list
  do.call(c, all_repos)
}

# github_endpoint --------------------------------------------------------------
github_endpoint <- function(group, page, per_page = 100L)
{
  sprintf(
    "GET /orgs/%s/repos%s", 
    group, 
    url_parameter_string(page = page, per_page = per_page)
  )
}

# github_repo_object_to_data_row -----------------------------------------------
github_repo_object_to_data_row <- function(repo)
{
  name <- repo[["name"]]
  full_name <- repo[["full_name"]]
  url <- repo[["html_url"]]
  
  license_key <- na_if_null(repo[["license"]][["key"]])
  license_short <- na_if_null(repo[["license"]][["spdx_id"]])
  
  license_link <- if (is.na(license_short)) {
    NA
  } else {
    compose_url_github(
      path = paste0(full_name, "/blob/master/LICENSE")
    )
  }
  
  result <- data.frame(
    name = name,
    full_name = full_name,
    url = url,
    created_at = repo[["created_at"]], 
    pushed_at = repo[["pushed_at"]],
    open_issues = repo[["open_issues"]],
    license_key = license_key, 
    license_short = license_short, 
    license_link = license_link,
    stringsAsFactors = FALSE
  )
  
  result[["Repository"]] <- named_link(name, url)
  
  result[["License"]] <- if (is.na(license_short)) {
    NA
  } else {
    named_link(license_short, license_link)
  }
  
  result
}
