# image_link -------------------------------------------------------------------
image_link <- function(image_name, image_url, link_url)
{
  sprintf("[!%s](%s)", named_link(image_name, image_url),link_url)
}

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

# named_link -------------------------------------------------------------------
named_link <- function(name, url)
{
  sprintf("[%s](%s)", name, url)
}

# url_parameter_string ---------------------------------------------------------
url_parameter_string <- function(...)
{
  parameters <- list(...)
  
  if (length(parameters) == 0L) {
    return("")
  }
  
  paste0("?", paste0(names(parameters), "=", parameters, collapse = "&"))
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
