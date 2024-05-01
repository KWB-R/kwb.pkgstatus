# compose_url ------------------------------------------------------------------
compose_url <- function(
    protocol = "http", 
    subdomain = NULL, 
    domain_name, 
    path = "",
    parameters = list()
)
{
  paste0(
    protocol, "://", 
    if (!is.null(subdomain)) {
      paste0(subdomain, ".")
    }, 
    domain_name, 
    url_path(path),
    do.call(url_parameter_string, parameters)
  )
}

# compose_url_codecov ----------------------------------------------------------
compose_url_codecov <- function(path = "", parameters = list())
{
  compose_url(
    protocol = "https", 
    domain_name = "codecov.io", 
    path = path, 
    parameters = parameters
  )
}

# image_link -------------------------------------------------------------------
image_link <- function(image_name, image_url, link_url)
{
  sprintf("[!%s](%s)", named_link(image_name, image_url),link_url)
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

# url_path ---------------------------------------------------------------------
url_path <- function(path)
{
  paste0(ifelse(path == "", "", "/"), gsub("^/+", "", path))
}
