#' check_gitlab_backup 
#'
#' @param group username or organisation for Github/Gitlab (default: "KWB-R")
#' @param github_token github access token (default: getOption("github_token"))
#' @param gitlab_token gitlab access token (default: getOption("gitlab_token"))
#' @return data.frame containing all Github repositoriers that are mirrored in 
#' Gitlab (i.e. were at least syncronised within the last 2 hours)
#' @importFrom magrittr "%>%"
#' @importFrom dplyr left_join
#' @importFrom lubridate as_datetime
#' @export
check_gitlab_backup <- function(group = "KWB-R",
                                github_token = getOption("github_token"), 
                                gitlab_token = getOption("gitlab_token")) {
  
  
  github_repos <- get_github_repos(group, github_token)
  gitlab_repos <- get_gitlab_repos(group,gitlab_token)
  
  
  
  names(github_repos) <- paste0("gh_", names(github_repos))
  names(gitlab_repos) <- paste0("gl_", names(gitlab_repos))
  
  tmp <- github_repos %>% 
    dplyr::left_join(y = gitlab_repos, by = c("gh_name" = "gl_name")) 
  
  tmp$last_mirrored_hours <- difftime(lubridate::as_datetime(tmp$gh_pushed_at), 
                                      lubridate::as_datetime(tmp$gl_last_activity_at), 
                                      units = "hours")
  
  is_mirrored <- tmp$last_mirrored_hours <= 2 #h
  
  mirrored_repos <- tmp[is_mirrored, ]
  
  data.frame(name = mirrored_repos$gh_name,
             Backup = badge_gitlab(url = mirrored_repos$gl_web_url),
             stringsAsFactors = FALSE)
  
}
