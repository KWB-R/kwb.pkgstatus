#' badge_license
#'
#' @param license_keys one or many valid license keys from c("agpl-3.0", 
#' "apache-2.0", "bsd-2-clause", "bsd-3-clause", "epl-2.0", "gpl-2.0", "gpl-3.0",    
#' "lgpl-2.1", "lgpl-3.0", "mit", "mpl-2.0", "unlicense") 
#' @param github_token github access token (default: getOption("github_token"))
#' @importFrom gh gh
#' @importFrom data.table rbindlist
#' @importFrom dplyr left_join select_ rename_
#' @return badge for all provided license keys
#' @export
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
