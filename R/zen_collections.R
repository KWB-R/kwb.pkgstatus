#' Helper function for Zenodo
#' @param response response provided by httr::content()
#' @importFrom dplyr tbl_df
#' @importFrom data.table rbindlist
#' @return a tibble of available Zenodo data 
#' @export
process_hitter_response <- function (response) 
{
  res <- lapply(response, function(s) data.frame(t(unlist(s))))
  dplyr::tbl_df(data.table::rbindlist(res, fill = TRUE))
}

#' Zenodo: get available collections
#' @param n number of zenodo entries ("size") to return per API call (default: 1000)
#' @param access_token Zenodo access token (default: getOption("zenodo_token"))
#' @importFrom httr content GET
#' @return a tibble of available Zenodo data 
#' @export
#' @seealso \url{https://developers.zenodo.org/#depositions}

zen_collections <- function (n = 1000, 
                             access_token = getOption("zenodo_token"))  {
  dir_path <- "https://zenodo.org/api/deposit/depositions"
  args <- as.list(c("size" = n, "access_token" = access_token))
  results <- httr::GET(dir_path, query = args)
  request <- httr::content(results)
  process_hitter_response(request)
}
