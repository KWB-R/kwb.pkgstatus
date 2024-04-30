# list_files_in_github_repo ----------------------------------------------------
list_files_in_github_repo <- function(
    owner, 
    repo, 
    path = "", 
    full_info = FALSE,
    columns = c("isdir", "name", "path", "download_url")
)
{
  #owner="kwb-r";repo="kwb.utils";
  
  url <- compose_url(
    protocol = "https", 
    subdomain = "api", 
    domain_name = "github.com",
    path = sprintf("repos/%s/%s/contents/%s", owner, repo, path)
  )
  
  response <- httr::GET(url, config = list(
    Authorization = paste("Bearer", get_github_token()))
  )
  
  contents <- httr::content(response)
  
  file_info <- lapply(contents, function(x) {
    as.data.frame(x[setdiff(names(x), c("_links", "download_url"))])
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
