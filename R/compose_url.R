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
