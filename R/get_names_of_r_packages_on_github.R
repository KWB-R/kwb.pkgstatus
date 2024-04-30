# get_names_of_r_packages_on_github --------------------------------------------

#' Get Names of R Packages on GitHub
#' 
#' @param group name of organisation on GitHub, defaults to "kwb-r"
#' @param public logical indicating whether private repositories are to be
#'   considered. Default: \code{TRUE}
#' @param private logical indicating whether public repositories are to be
#'   considered. Default: \code{TRUE}
#' @returns vector of character representing the names of the \code{public} 
#'   and/or \code{private} repositories (as requested), owned by the 
#'   organisation \code{groupt} on GitHub
#' @export
get_names_of_r_packages_on_github <- function(
    group = "kwb-r", public = TRUE, private = TRUE
)
{
  # Get info on all repositories owned by group
  all_repos <- get_github_repos_impl(group = group)
  
  # Is a repository private (or public)?
  is_private <- sapply(all_repos, `[[`, "private")

  # Keep only repositories of requested type
  repos <- all_repos[(public & !is_private) | (private & is_private)]
  
  # Get the names of the selected repositories
  repo_names <- sapply(repos, `[[`, "name")
  
  # If there are no (remaining) repository names, return an empty vector
  if (length(repos) == 0L) {
    return(character(0L))
  }
  
  # Keep only the names of repositories that look like R packages
  keep <- sapply(repo_names, github_repo_looks_like_r_package, owner = group)
  repo_names[keep]
}

# github_repo_looks_like_r_package ---------------------------------------------
github_repo_looks_like_r_package <- function(owner = "kwb-r", repo)
{
  file_names <- try(list_files_in_github_repo(owner, repo))

  if (inherits(file_names, "try-error")) {
    message(
      "Error when trying to list files of repo '", repo, "'.\n",
      "Returning FALSE (does not look like an R package)"
    )
    return(FALSE)
  }
  
  all(c("R/", "DESCRIPTION") %in% file_names)
}
