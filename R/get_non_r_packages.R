#' Get Names of Repositories that Do not Represent R Packages
#'
#' @param hard_coded logical indicating whether or not to return the hard-coded
#'   vector of package names. The default is \code{TRUE}. If \code{hard_coded}
#'   is \code{FALSE} the names of repositories that are not assumed to represent
#'   R packages are determined by looking into each repository. This may take a 
#'   while.
#' @return This function returns a (alphabetically sorted) vector of names of 
#'   KWB-R repositories on Github that do not represent R packages
#' @export
#' @examples
#' get_non_r_packages()
#' 
get_non_r_packages <- function(hard_coded = TRUE)
{
  repo_names <- if (hard_coded) {
    c(
      "abimo", 
      "abimo.scripts", 
      "ad4gd_lakes", 
      "apps", 
      "abluft2", 
      "abluft2.scripts", 
      "basar.scripts", 
      "dwc.scripts", 
      "kwb-r.github.io", 
      "kwb-r.r-universe.dev", 
      "fakin", 
      "fakin.blog", 
      "fakin.doc", 
      "fakin.scripts", 
      "FolderRights", 
      "flusshygiene", 
      "HydroServerLite", 
      "hydrus1d", 
      "GeoSalz", 
      "geosalz.mf", 
      "geosalz.scripts", 
      "impetus_scripts", 
      "intruder.io", 
      "lasso.scripts", 
      "Logremoval", 
      "programming", 
      "pathana", 
      "pFromGrADS", 
      "promisces.hhra", 
      "qmra", 
      "qsimVis", 
      "r-training", 
      "support", 
      "maxflow",
      "mbr40.scripts", 
      "misa.scripts", 
      "pubs", 
      "riverPollution", 
      "smart.control", 
      "sema.scripts", 
      "sema.projects", 
      "swim-ai", 
      "spur.scripts", 
      "status", 
      "ultimate.scripts", 
      "useR-2019", 
      "wellma.scripts"
    )
    
  } else {
    
    all_repos <- get_github_repos()[["name"]]
    package_repos <- get_names_of_r_packages_on_github()
    setdiff(all_repos, package_repos)
  }
  
  sort(repo_names)
}
