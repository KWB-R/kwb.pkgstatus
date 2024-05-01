# http_get_or_stop -------------------------------------------------------------
http_get_or_stop <- function(url, ...)
{
  response <- httr::GET(url, ...)
  
  if (httr::status_code(response) != 200L) {
    stop(
      "Error when trying to GET ", url, ":\n",
      jsonlite::fromJSON(httr::content(response, type = "text"))$message,
      call. = FALSE
    )
  }
  
  response
}

#' url_success
#' 
#' @param url url of documentation website
#' @importFrom httr status_code GET
#' @return TRUE in case HTTP status code is 200, if not: FALSE
url_success <- function(url)
{
  identical(httr::status_code(x = httr::GET(url)), 200L)
}
