# make_github_package_db -------------------------------------------------------

#' Make Package Database for Packages on GitHub
#' 
#' ready to be used in e.g. \code{\link[tools]{package_dependencies}}
#' 
#' @param group Name of GitHub organisation, defaults to "kwb-r"
#' @param dbg logical indicating whether or not to show debug messages. 
#'   The default is \code{TRUE}
#' @return data frame with each column representing a field in the `DESCRIPTION`
#'   file
#' @export
make_github_package_db <- function(group = "kwb-r", dbg = TRUE)
{
  #kwb.utils::assignPackageObjects("kwb.pkgstatus")
  public_r_packages <- get_names_of_r_packages_on_github(
    group = group, 
    private = FALSE,
    dbg = dbg
  )
  
  description_urls <- compose_url_githubusercontent(
    subdomain = "raw",
    path = sprintf("%s/%s/master/DESCRIPTION", group, public_r_packages)
  )
  
  description_matrices <- lapply(description_urls, function(url) {
    cat_if(dbg, "Reading %s\n", url)
    con <- file(url, encoding = "UTF-8")
    on.exit(close(con))
    read.dcf(con)
  })
  
  dplyr::bind_rows(lapply(description_matrices, as.data.frame))
}
