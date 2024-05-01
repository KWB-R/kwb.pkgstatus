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
    ifelse(path == "", "", paste0("/", gsub("^/+", "", path))),
    do.call(url_parameter_string, parameters)
  )
}

# compose_url_appveyor ---------------------------------------------------------
compose_url_appveyor <- function(path, parameters)
{
  compose_url(
    protocol = "https", 
    subdomain = "ci", 
    domain_name = "appveyor.com",
    path = path, 
    parameters = parameters
  )
}

# compose_url_badge ------------------------------------------------------------
compose_url_badge <- function(relative_paths)
{
  compose_url(
    protocol = "https",
    subdomain = "img", 
    domain_name = "shields.io", 
    path = paste0("badge/", relative_paths)
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

# compose_url_eclipse ----------------------------------------------------------
compose_url_eclipse <- function(path)
{
  compose_url(
    protocol = "https", 
    subdomain = "www", 
    domain_name = "eclipse.org", 
    path = path
  )
}

# compose_url_github -----------------------------------------------------------
compose_url_github <- function(path, subdomain = NULL)
{
  compose_url(
    protocol = "https", 
    subdomain = subdomain, 
    domain_name = "github.com", 
    path = path
  )
}

# compose_url_githubusercontent ------------------------------------------------
compose_url_githubusercontent <- function(subdomain, path, parameters = list())
{
  compose_url(
    protocol = "https", 
    subdomain = subdomain, 
    domain_name = "githubusercontent.com", 
    path = path,
    parameters = parameters
  )
}

# compose_url_gitlab -----------------------------------------------------------
compose_url_gitlab <- function(path, token = NULL)
{
  compose_url(
    protocol = "https", 
    domain_name = "gitlab.com", 
    path = path,
    parameters = if (is.null(token)) {
      list()
    } else {
      list(private_token = token)
    }
  )
}

# compose_url_gnu --------------------------------------------------------------
compose_url_gnu <- function(path)
{
  compose_url(
    protocol = "https", 
    subdomain = "www", 
    domain_name = "gnu.org", 
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

# compose_url_ocpu -------------------------------------------------------------
compose_url_ocpu <- function(group)
{
  compose_url(
    protocol = "https", 
    subdomain = tolower(group), 
    domain_name = "ocpu.io"
  )
}

# compose_url_opensource -------------------------------------------------------
compose_url_opensource <- function(path)
{
  compose_url(
    protocol = "https", 
    domain_name = "opensource.org", 
    path = path
  )
}

# compose_url_travis -----------------------------------------------------------
compose_url_travis <- function(path, parameters)
{
  compose_url(
    protocol = "https", 
    domain_name = "travis-ci.org",
    path = path, 
    parameters = parameters
  )
}

# compose_url_unlicense --------------------------------------------------------
compose_url_unlicense <- function()
{
  compose_url(
    protocol = "http", 
    domain_name = "unlicense.org"
  )
}

# compose_url_zenodo -----------------------------------------------------------
compose_url_zenodo <- function(path)
{
  compose_url(
    protocol = "https", 
    domain_name = "zenodo.org", 
    path = path
  )
}
