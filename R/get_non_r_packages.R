#' Helper function: get_non_r_packages 
#'
#' @return returns vector with KWB-R repos on Github, which are not R packages
#' @export
#' @examples
#' get_non_r_packages()
#' 
get_non_r_packages <- function() {
  
  c("apps", "kwb-r.github.io", "fakin", "fakin.blog", "fakin.doc", "fakin.scripts",
   "HydroServerLite", "GeoSalz", "FolderRights", "pathana", "r-training", 
   "support", "maxflow", "pubs", "smart.control", "sema.scripts",	"status", "useR-2019")

}
