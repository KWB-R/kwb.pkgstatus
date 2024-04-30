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
