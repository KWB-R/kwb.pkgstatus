#' check_gitlab_backup 
#'
#' @param group username or organisation for Github/Gitlab (default: "KWB-R")
#' @param github_token github access token (default: Sys.getenv("GITHUB_TOKEN"))
#' @param gitlab_token gitlab access token (default: Sys.getenv("GITLAB_TOKEN")))
#' @return data.frame containing all Github repositoriers that are mirrored in 
#' Gitlab (i.e. were at least syncronised within the last 2 hours)
#' @importFrom magrittr "%>%"
#' @importFrom dplyr left_join
#' @importFrom lubridate as_datetime
#' @export
check_gitlab_backup <- function(
    group = "KWB-R",
    github_token = get_github_token(), 
    gitlab_token = get_gitlab_token()
)
{
  git_repos <- dplyr::left_join(
    x = prefix_names(get_github_repos(group, github_token), "gh_"),
    y = prefix_names(get_gitlab_repos(group, gitlab_token), "gl_"), 
    by = c("gh_name" = "gl_name")
  )

  git_repos$last_mirrored_hours <- difftime(
    lubridate::as_datetime(git_repos$gh_pushed_at), 
    lubridate::as_datetime(git_repos$gl_last_activity_at), 
    units = "hours"
  )
  
  is_mirrored <- git_repos$last_mirrored_hours <= 2 #h
  
  mirrored_repos <- git_repos[is_mirrored, ]
  
  data.frame(
    name = mirrored_repos$gh_name,
    Backup = badge_gitlab(url = mirrored_repos$gl_web_url),
    stringsAsFactors = FALSE
  )
}
