# cat_if -----------------------------------------------------------------------
cat_if <- function(condition, fmt, ...)
{
  if (condition) {
    cat(sprintf(fmt, ...))
  }
}

# dot_to_dash ------------------------------------------------------------------
dot_to_dash <- function(x)
{
  gsub(".", "-", x, fixed = TRUE)
}

# get_github_token -------------------------------------------------------------
get_github_token <- function()
{
  Sys.getenv("GITHUB_TOKEN", Sys.getenv("GITHUB_PAT"))
}

# get_gitlab_token -------------------------------------------------------------
get_gitlab_token <- function()
{
  Sys.getenv("GITLAB_TOKEN")
}

# get_token --------------------------------------------------------------
get_token <- function(prefix)
{
  Sys.getenv(paste0(toupper(prefix), "_TOKEN"))
}

# html_a -----------------------------------------------------------------------
html_a <- function(href, x)
{
  sprintf("<a href='%s'>%s</a>", href, x)
}

# html_attribute_string --------------------------------------------------------
html_attribute_string <- function(...)
{
  attributes <- list(...)
  
  sprintf("%s='%s'", names(attributes), attributes) %>% 
    paste(collapse = ", ")
}

# html_img ---------------------------------------------------------------------
html_img <- function(src, ...)
{
  attr_string <- html_attribute_string(...)
  
  sprintf(
    "<img src='%s'%s/>", 
    src, 
    ifelse(nzchar(attr_string), paste0(" ", attr_string), "")
  )
}

# na_along ---------------------------------------------------------------------
na_along <- function(x)
{
  rep(NA, length = length(x))
}

# na_if_null -------------------------------------------------------------------
na_if_null <- function(x)
{
  if (is.null(x)) NA else x
}

# prefix_names -----------------------------------------------------------------
prefix_names <- function(x, prefix)
{
  names(x) <- paste0(prefix, names(x))
  x
}
