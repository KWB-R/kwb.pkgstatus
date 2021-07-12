#' Helper function: check if tokens are set
#'
#' @return TRUE if all tokens are set, FALSE otherwise
#' @importFrom stringr str_length
#' @keywords internal
#'
check_all_tokens_set <- function() {
  token_names <- c("APPVEYOR_TOKEN", 
                   "CODECOV_TOKEN", 
                   "GITHUB_TOKEN", 
                   "GITLAB_TOKEN",
                   "ZENODO_TOKEN"
                   )
  token_values <- Sys.getenv(token_names)
  
  tokens_defined <- stringr::str_length(token_values) > 0
  
  if(all(tokens_defined)) {
    TRUE
  } else {
    tokens_undefined <- paste(token_names[!tokens_defined], collapse = ", ")
    warning(sprintf("The folling tokens were not defined: %s", tokens_undefined))
    FALSE
  }
  
}


#' prepare_status_rpackages
#' @param secrets_csv path to "secrets.csv" file, if "NULL" Sys.env variables 
#' for the following services are used/need to be defined: APPVEYOR_TOKEN, 
#' GITHUB_TOKEN, GITLAB_TOKEN, CODECOV_TOKEN, ZENODO_TOKEN, 
#' (default: NULL)
#' @param non_r_packages a character vector with repositories in KWB-R group that
#' are not R packages (default: \code{get_non_r_packages})
#' @importFrom dplyr filter_ left_join
#' @importFrom kwb.pkgbuild use_badge_ghactions_rcmdcheck use_badge_ghactions_pkgdown
#' @importFrom utils read.csv
#' @return data.frame with R package status information
#' @export
prepare_status_rpackages <- function (secrets_csv = NULL, 
    non_r_packages = get_non_r_packages()) {
  
  
  if(!is.null(secrets_csv)) {
  ### Need to check Hadley`s vignette for safely managing access tokens:
  ### https://cran.r-project.org/web/packages/httr/vignettes/secrets.html
  secrets <- read.csv(secrets_csv, stringsAsFactors = FALSE)
  
  Sys.setenv(APPVEYOR_TOKEN = secrets$appveyor_token,
             CODECOV_TOKEN = secrets$codecov_token,
             GITHUB_TOKEN = secrets$github_token,
             GITLAB_TOKEN = secrets$gitlab_token,
             ZENODO_TOKEN = secrets$zenodo_token
          )
  }
  
  stopifnot(check_all_tokens_set())
  
  repo_infos <- kwb.pkgstatus::get_github_repos() %>% 
    dplyr::filter_("!name %in% non_r_packages") 
  

build_pkg_release <- as.vector(sapply(repo_infos$name, function(repo) {
    kwb.pkgbuild::use_badge_ghactions_rcmdcheck(repo)
    }))  

build_pkg_dev <- as.vector(sapply(repo_infos$name, function(repo) {
  kwb.pkgbuild::use_badge_ghactions_rcmdcheck(repo, branch = "dev")
}))

build_doc_release <- as.vector(sapply(repo_infos$name, function(repo) {
  kwb.pkgbuild::use_badge_ghactions_pkgdown(repo)
}))  

build_doc_dev <- as.vector(sapply(repo_infos$name, function(repo) {
  kwb.pkgbuild::use_badge_ghactions_pkgdown(repo, branch = "dev")
}))

badge_runiverse <- as.vector(sapply(repo_infos$name, function(repo) {
  kwb.pkgbuild::use_badge_runiverse(repo)
}))

sapply(repo_infos$name, kwb.pkgbuild::use_badge_runiverse)
  
meta_info <- data.frame(License_Badge = badge_license(repo_infos$license_key), 
Dependencies = badge_dependencies(repo_infos$name),
Tests_Coverage.io = badge_codecov(repo_infos$full_name), 
Build_Pkg_Release = build_pkg_release,
Build_Pkg_Dev = build_pkg_dev,
Build_Doc_Release = build_doc_release,
Build_Doc_Dev = build_doc_dev,
Released_on_R-Universe = badge_runiverse,
### Avoid issue with CRAN R packages badges
### (no problem if PANDOC version >= 2.2.1)
### https://github.com/rstudio/rmarkdown/issues/228
Released_on_CRAN = badge_cran(repo_infos$name), 
Citation_DigitalObjectIdentifer = badge_zenodo(repo_infos$full_name),
Doc_Rel = check_docu_release(repo_names = repo_infos$name),
Doc_Dev = check_docu_dev(repo_names = repo_infos$name),
stringsAsFactors = FALSE)                      
  
  
dat <- cbind(repo_infos, meta_info)
  
check_gitlab <- check_gitlab_backup()
deployed_on_opencpu <- check_opencpu_deploy()
  
dat <- dat %>% 
        dplyr::left_join(y = check_gitlab) %>% 
        dplyr::left_join(y = deployed_on_opencpu)
  
return(dat)  
}