#' Helper function: get_non_r_packages 
#'
#' @return returns vector with KWB-R repos on Github, which are not R packages
#' @export
#' @examples
#' get_non_r_packages()
#' 
get_non_r_packages <- function() {
  
  c("abimo", "apps", "abluft2", "abluft2.scripts", "basar.scripts", "dwc.scripts", 
    "kwb-r.github.io", "fakin", "fakin.blog", "fakin.doc", "fakin.scripts", "FolderRights", 
    "flusshygiene", "HydroServerLite", "hydrus1d", "GeoSalz", "geosalz.mf", "geosalz.scripts", 
    "programming", "pathana", "pFromGrADS", "qmra", "r-training", "support", "maxflow",  
    "mbr40.scripts", "misa.scripts", "pubs", "riverPollution", "smart.control", "sema.scripts", 
    "spur.scripts", "status", "universe", "useR-2019", "wellma.scripts")

}
