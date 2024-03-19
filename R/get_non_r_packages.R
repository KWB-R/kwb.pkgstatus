#' Helper function: get_non_r_packages 
#'
#' @return returns vector with KWB-R repos on Github, which are not R packages
#' @export
#' @examples
#' get_non_r_packages()
#' 
get_non_r_packages <- function() {
  
  c("abimo", "abimo.scripts", "ad4gd_lakes", "apps", "abluft2", "abluft2.scripts", 
    "basar.scripts", "dwc.scripts", "kwb-r.github.io", "kwb-r.r-universe.dev", 
    "fakin", "fakin.blog", "fakin.doc", "fakin.scripts", "FolderRights", 
    "flusshygiene", "HydroServerLite", "hydrus1d", "GeoSalz", "geosalz.mf", 
    "geosalz.scripts", "impetus_scripts", "intruder.io", "lasso.scripts", 
    "Logremoval", "programming", "pathana", "pFromGrADS", "promisces.hhra", 
    "qmra", "qsimVis", "r-training", "support", "maxflow",  "mbr40.scripts", 
    "misa.scripts", "pubs", "riverPollution", "smart.control", "sema.scripts", 
    "sema.projects", "swim-ai", "spur.scripts", "status", "ultimate.scripts", 
    "useR-2019", "wellma.scripts")
}

