# get_gitlab_repos -------------------------------------------------------------

#' get_gitlab_repos
#' 
#' @param group username or organisation for Gitlab (default: "KWB-R")
#' @param gitlab_token gitlab access token (default: Sys.getenv("GITLAB_TOKEN"))
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
  endpoint <- compose_url(
    protocol = "https", 
    domain_name = "gitlab.com", 
    path = paste0(
      url_path(paste0("api/v4/groups/", group)), 
      url_parameter_string(private_token = gitlab_token)
    )
  )

  gitlab_group <- jsonlite::fromJSON(endpoint)
  
  gitlab_group$projects
}

# get_github_repos -------------------------------------------------------------

#' get_github_repos
#' 
#' @param group username or organisation for Github (default: "KWB-R")
#' @param github_token github access token (default: Sys.getenv("GITHUB_TOKEN"))
#' @return data.frame with for all repositories of the user/organisation defined 
#' in parameter group (private repos will only be accessible if the token is 
#' configured to allow that)
#' @importFrom gh gh
#' @export
get_github_repos <- function(group = "KWB-R", github_token = get_github_token())
{
  get_repos <- function(per_page = 100L) {
    
    endpoint <- function(group, page, per_page) paste0(
      "GET ", 
      url_path(sprintf("orgs/%s/repos", group)),
      url_parameter_string(page = page, per_page = per_page)
    )
    
    all_repos <- list()
    
    # Start with the first page
    page <- 1L
    
    # Read next page while page number is given
    while(page > 0L) {
      
      # Read repos from current page  
      repos <- gh::gh(
        endpoint = endpoint(group, page, per_page), 
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
    
    do.call(what = c, args = all_repos)
  }
  
  gh_repos <- get_repos()
  
  for (repo_ind in seq_along(gh_repos)) {
    
    sel_repo <- gh_repos[[repo_ind]]
    
    tmp <- data.frame(
      name = sel_repo$name,
      full_name = sel_repo$full_name,
      url = sel_repo$html_url,
      created_at = sel_repo$created_at, 
      pushed_at = sel_repo$pushed_at,
      open_issues = sel_repo$open_issues,
      license_key = ifelse(
        is.null(sel_repo$license$key), 
        NA, 
        sel_repo$license$key
      ), 
      license_short = ifelse(
        is.null(sel_repo$license$spdx_id), 
        NA, 
        sel_repo$license$spdx_id
      ), 
      license_link = ifelse(
        is.null(sel_repo$license$spdx_id), 
        NA, 
        compose_url(
          protocol = "https", 
          domain_name = "github.com", 
          path = paste0(sel_repo$full_name, "/blob/master/LICENSE")
        )
      ),
      stringsAsFactors = FALSE
    )
    
    tmp$Repository <- named_link(tmp$name, tmp$url)
    
    tmp$License <- ifelse(
      is.na(tmp$license_short),
      NA, 
      named_link(tmp$license_short, tmp$license_link)
    )
    
    if (repo_ind == 1) {
      res <- tmp
    } else {
      res <- rbind(res,tmp)
    }
  } 
  
  res[order(res$name,decreasing = FALSE), ]
}
