#' prepare_status_rpackages
#' @param secrets_csv path to "secrets.csv" file
#' @param non_r_packages a character vector with repositories in KWB-R group that
#' are not R packages (default: \code{get_non_r_packages})
#' @importFrom dplyr filter_ left_join
#' @importFrom kwb.pkgbuild use_badge_ghactions_rcmdcheck use_badge_ghactions_pkgdown
#' @importFrom utils read.csv
#' @return data.frame with R package status information
#' @export
prepare_status_rpackages <- function (secrets_csv, 
    non_r_packages = get_non_r_packages()) {
  
  
  ### Need to check Hadley`s vignette for safely managing access tokens:
  ### https://cran.r-project.org/web/packages/httr/vignettes/secrets.html
  secrets <- read.csv(secrets_csv, stringsAsFactors = FALSE)
  
  options(zenodo_token = secrets$zenodo_token, 
          codecov_token  = secrets$codecov_token,
          github_token = secrets$github_token,
          appveyor_token =  secrets$appveyor_token,
          gitlab_token = secrets$gitlab_token)
  
  
  repo_infos <- get_github_repos() %>% 
    dplyr::filter_("!name %in% non_r_packages") 
  

meta_info <- data.frame(License_Badge = badge_license(repo_infos$license_key), 
Tests_Coverage.io = badge_codecov(repo_infos$full_name), 
Build_Pkg_Release = kwb.pkgbuild::use_badge_ghactions_rcmdcheck(repo_infos$full_name),
Build_Pkg_Dev = kwb.pkgbuild::use_badge_ghactions_rcmdcheck(repo_infos$full_name, 
                                          branch = "dev"),
Build_Doc_Release = kwb.pkgbuild::use_badge_ghactions_pkgdown(repo_infos$full_name),
Build_Doc_Dev = kwb.pkgbuild::use_badge_ghactions_pkgdown(repo_infos$full_name, 
                                                        branch = "dev"),
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