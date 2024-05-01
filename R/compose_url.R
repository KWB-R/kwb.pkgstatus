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
compose_url_codecov <- function(path)
{
  compose_url(
    protocol = "https", 
    domain_name = "codecov.io", 
    path = path
  )
}

# compose_url_cran -------------------------------------------------------------
compose_url_cran <- function(path)
{
  compose_url(
    protocol = "http", 
    subdomain = "www", 
    domain_name = "r-pkg.org", 
    path = path
  )
}

# compose_url_netlify ----------------------------------------------------------
compose_url_netlify <- function(path)
{
  compose_url(
    protocol = "https", 
    subdomain = "kwb-githubdeps", 
    domain_name = "netlify.app", 
    path = path
  )
}
