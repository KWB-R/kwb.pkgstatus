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
