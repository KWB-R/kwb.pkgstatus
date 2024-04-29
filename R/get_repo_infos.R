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

# badge_cran -------------------------------------------------------------------
badge_cran <- function(repo_names)
{
  url_formats <- compose_url(
    protocol = "http", 
    subdomain = "www", 
    domain_name = "r-pkg.org", 
    path = c(
      "/badges/version/%s", 
      "/pkg/%s"
    )
  )
  
  image_link(
    image_name = "CRAN_Status_Badge", 
    image_url = sprintf(url_formats[1L], repo_names),
    link_url = sprintf(url_formats[2L], repo_names)
  )
}

# badge_codecov ----------------------------------------------------------------
badge_codecov <- function(repo_full_names)
{
  url_formats <- compose_url(
    protocol = "https",
    domain_name = "codecov.io", 
    path = c(
      "/github/%s/branch/master/graphs/badge.svg",
      "/github/%s"
    )
  )
  
  image_link(
    image_name = "codecov",
    image_url = sprintf(url_formats[1L], repo_full_names),
    link_url = sprintf(url_formats[2L], repo_full_names)
  )
}

# badge_license ----------------------------------------------------------------
badge_license <- function(license_keys, github_token = get_github_token())
{
  gh_licenses <- gh::gh(endpoint = "GET /licenses", .token =  github_token)
  
  gh_licenses_df <- data.table::rbindlist(gh_licenses, fill=TRUE)
  
  #### License badges from: https://gist.github.com/lukas-h/2a5d00690736b4c3a7ba
  license_badges <- get_license_badge_info()
  
  gh_licenses_df <- dplyr::left_join(gh_licenses_df, license_badges) 
  
  gh_licenses_df$Badge_License <- image_link(
    image_name = gh_licenses_df$spdx_id, 
    image_url = gh_licenses_df$image_url,
    link_url = gh_licenses_df$license_url
  )
  
  badges <- gh_licenses_df %>%  
    dplyr::select_(~key, ~Badge_License) %>%  
    dplyr::rename_(license_key = ~key)
  
  result <- dplyr::left_join(
    x = data.frame(
      license_key = license_keys, 
      stringsAsFactors = FALSE
    ), 
    y = badges
  )
  
  result$Badge_License
}

# badge_appveyor ---------------------------------------------------------------
badge_appveyor <- function(repo_full_names)
{
  url_formats <- compose_url(
    protocol = "https", 
    subdomain = "ci", 
    domain_name = "appveyor.com", 
    path = c(
      "api/projects/status/github/%s?branch=master&svg=true",
      "project/%s/branch/master"
    )
  )
  
  image_link(
    image_name = "Appveyor",
    image_url = sprintf(url_formats[1L], repo_full_names),
    link_url = sprintf(url_formats[2L], dot_to_dash(repo_full_names))
  )
}

# badge_travis -----------------------------------------------------------------
badge_travis <- function(repo_full_names)
{
  url_formats <- compose_url(
    protocol = "https", 
    domain_name = "travis-ci.org", 
    path = c(
      "/%s.svg?branch=master",
      "/%s"
    )
  )
  
  image_link(
    image_name = "Travis",
    image_url = sprintf(url_formats[1L], repo_full_names),
    link_url = sprintf(url_formats[2L], repo_full_names)
  )
}

# badge_zenodo -----------------------------------------------------------------
badge_zenodo <- function(
    repo_full_names, 
    zenodo_token = Sys.getenv("ZENODO_TOKEN")
)
{
  zen_data <- zen_collections(access_token = zenodo_token)
  
  zen_badge <- na_along(repo_full_names)
  
  for (index in seq_along(repo_full_names)) {
    
    doi_exists <- stringr::str_detect(
      string = zen_data$metadata.related_identifiers.identifier, 
      pattern = compose_url(
        protocol = "https", 
        domain_name = "github.com", 
        path = paste0("/", repo_full_names[index])
      )
    )
    
    doi_exists[is.na(doi_exists)] <- FALSE
    
    if (sum(doi_exists) == 1) {
      
      zen_badge[index] <- sprintf(
        "[![DOI](%s)](%s)", 
        zen_data$links.badge[doi_exists], 
        zen_data$doi_url[doi_exists]
      )
      
    } else if (sum(doi_exists) > 1) {
      warn_msg <- sprintf(
        "Multiple entries found for repo '%s':\n%s",
        repo_full_names[index], 
        paste(
          zen_data$metadata.related_identifiers.identifier[doi_exists],
          collapse = "\n"
        )
      )
      warning(warn_msg)
      zen_badge[index] <- "Multiple badges found!"
    } else {
      zen_badge[index] <- NA
    }
  }
  
  zen_badge
}

# get_coverage -----------------------------------------------------------------
get_coverage <- function(
    repo_full_name, 
    codecov_token = Sys.getenv("CODECOV_TOKEN"), 
    dbg = TRUE
) 
{
  url <- compose_url(
    protocol = "https", 
    domain_name = "codecov.io", 
    path = paste0("/api/gh/", repo_full_name)
  )
  
  cat_if(dbg, "Checking code coverage for %s at %s", repo_full_name, url)

  req <- sprintf("%s?access_token=%s", url, codecov_token)
  
  if(httr::status_code(httr::GET(url = req)) == 200L) {
    codecov_data <- jsonlite::fromJSON(req)
    
    if(!is.null(codecov_data$commit$totals$c)) {
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

# get_coverages ----------------------------------------------------------------
get_coverages <- function (
    repo_full_names, 
    codecov_token = Sys.getenv("CODECOV_TOKEN"), 
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
  
  coverage_url[available_indices] <- compose_url(
    protocol = "https", 
    domain_name = "codecov.io", 
    path = paste0("gh/", repo_full_names[available_indices])
  )
  
  data.frame(
    Coverage = coverage_percent, 
    Coverage_url = coverage_url
  )
}
