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
  Sys.getenv("GITHUB_TOKEN")
}

# get_gitlab_token -------------------------------------------------------------
get_gitlab_token <- function()
{
  Sys.getenv("GITLAB_TOKEN")
}

# html_a -----------------------------------------------------------------------
html_a <- function(href, x)
{
  sprintf("<a href='%s'>%s</a>", href, x)
}

# html_img ---------------------------------------------------------------------
html_img <- function(src, img_attr)
{
  sprintf("<img src='%s'%s/>", src, img_attr)
}

# na_along ---------------------------------------------------------------------
na_along <- function(x)
{
  rep(NA, length = length(x))
}

# prefix_names -----------------------------------------------------------------
prefix_names <- function(x, prefix)
{
  names(x) <- paste0(prefix, names(x))
  x
}
