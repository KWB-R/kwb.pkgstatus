# list_files_in_github_repo ----------------------------------------------------
list_files_in_github_repo <- function(
    owner, 
    repo, 
    path = "", 
    full_info = FALSE,
    columns = c("isdir", "name", "path", "download_url")
)
{
  #kwb.utils::assignPackageObjects("kwb.pkgstatus")
  #owner="kwb-r";repo="kwb.utils";path=""
  
  url <- compose_url_github(
    subdomain = "api", 
    path = sprintf("repos/%s/%s/contents/%s", owner, repo, path)
  )
  
  response <- http_get_or_stop(
    url, 
    config = httr::add_headers(
      Authorization = paste("Bearer", get_github_token())
    )
  )
  
  contents <- httr::content(response)
  
  file_info <- lapply(contents, function(x) {
    #x <- contents[[1L]]
    x_without_links <- x[setdiff(names(x), "_links")]
    is_null <- sapply(x_without_links, is.null)
    x_without_links[is_null] <- as.list(rep(NA, sum(is_null)))
    as.data.frame(x_without_links)
  }) %>% 
    do.call(what = rbind)
  
  isdir <- file_info[["type"]] == "dir"
  
  file_info[["download_url"]] <- character(nrow(file_info))
  
  file_info[["download_url"]][!isdir] <- sapply(
    contents[!isdir], 
    FUN = `[[`, 
    elements = "download_url"
  )

  file_info[["isdir"]] <- isdir

  if (full_info) {
    return(file_info[columns])
  }

  file_info[["name"]] %>% 
    paste0(ifelse(isdir, "/", ""))
}
