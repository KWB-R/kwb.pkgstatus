#' badge_zenodo
#' @param repo_full_names vector with combination of username/repo (e.g.
#' c("KWB-R/kwb.utils", "KWB-R/kwb.db"))
#' @param zenodo_token zenodo authentication token (default: 
#' Sys.getenv("ZENODO_TOKEN")) 
#' @importFrom stringr str_detect
#' @return zenodo badges for provided repo_full_names  
#' @export
badge_zenodo <- function(
    repo_full_names, 
    zenodo_token = Sys.getenv("ZENODO_TOKEN")
)
{
  zen_data <- zen_collections(access_token = zenodo_token)
  
  zen_badge <- na_along(repo_full_names)
  
  for (index in seq_along(repo_full_names)) {
    
    doi_exists <- stringr::str_detect(
      string = zen_data$metadata.related_identifiers.identifier , 
      pattern = compose_url(
        protocol = "https", 
        domain_name = "github.com", 
        path = repo_full_names[index]
      )
    )
    
    doi_exists[is.na(doi_exists)] <- FALSE
    
    if (sum(doi_exists) == 1L) {
      
      zen_badge[index] <- image_link(
        image_name = "DOI", 
        image_url = zen_data$links.badge[doi_exists], 
        link_url = zen_data$doi_url[doi_exists]
      )
      
    } else if (sum(doi_exists) > 1L) {
      
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
