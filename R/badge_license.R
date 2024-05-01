#' badge_license
#'
#' @param license_keys one or many valid license keys from c("agpl-3.0", 
#' "apache-2.0", "bsd-2-clause", "bsd-3-clause", "epl-2.0", "gpl-2.0", "gpl-3.0",    
#' "lgpl-2.1", "lgpl-3.0", "mit", "mpl-2.0", "unlicense") 
#' @param github_token github access token. Default: 
#'   kwb.pkgstatus:::get_github_token()
#' @importFrom gh gh
#' @importFrom data.table rbindlist
#' @importFrom dplyr left_join select_ rename_
#' @return badge for all provided license keys
#' @export
badge_license <- function(license_keys, github_token = get_github_token()) 
{
  #### License badges from: https://gist.github.com/lukas-h/2a5d00690736b4c3a7ba
  license_badges <- get_license_badge_info()
  
  gh_licenses_df <- "GET /licenses" %>% 
    gh::gh(.token = github_token) %>% 
    data.table::rbindlist(fill = TRUE) %>% 
    dplyr::left_join(license_badges) 
  
  gh_licenses_df$Badge_License <- image_link(
    image_name = gh_licenses_df$spdx_id, 
    image_url = gh_licenses_df$image_url, 
    link_url = gh_licenses_df$license_url
  )
  
  badges <- gh_licenses_df %>%  
    dplyr::select_(~key, ~Badge_License) %>%  
    dplyr::rename_(license_key = ~key) %>% 
    dplyr::left_join(
      x = data.frame(
        license_key = license_keys, 
        stringsAsFactors = FALSE
      )
    )
  
  badges$Badge_License
}
