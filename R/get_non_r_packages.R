#' Helper function: get_non_r_packages 
#'
#' @return returns vector with KWB-R repos on Github, which are not R packages
#' @export
#' @examples
#' get_non_r_packages()
#' 
get_non_r_packages <- function() {
  
  c("apps", "abluft2", "basar.scripts", "kwb-r.github.io", "fakin", "fakin.blog", "fakin.doc", "fakin.scripts", "FolderRights",
   "flusshygiene", "HydroServerLite", "GeoSalz", "LIDsensitivity", "pathana", "pFromGrADS", "r-training", 
   "support", "maxflow", "pubs", "riverPollution", "smart.control", "sema.scripts",	"spur", "status", 
   "urbanAnnualRunoff", "useR-2019", "wellma.scripts")

}