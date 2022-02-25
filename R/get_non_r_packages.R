#' Helper function: get_non_r_packages 
#'
#' @return returns vector with KWB-R repos on Github, which are not R packages
#' @export
#' @examples
#' get_non_r_packages()
#' 
get_non_r_packages <- function() {
  
  c("abimo", "apps", "abluft2", "abluft2.scripts", "basar.scripts", "dwc.scripts", "kwb-r.github.io", "fakin", 
    "fakin.blog", "fakin.doc", "fakin.scripts", "FolderRights", "flusshygiene", 
    "HydroServerLite", "mbr4.0_ml", "misa.scripts", "GeoSalz", "geosalz.ml", "pathana", "pFromGrADS", "r-training", 
   "support", "mbr4.0_ml", "maxflow", "promisces.hhra", "pubs", "riverPollution", "smart.control", 
   "sema.scripts", "spur", "status", "universe", "useR-2019", "wellma.scripts")

}
