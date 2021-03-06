% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/zen_collections.R
\name{zen_collections}
\alias{zen_collections}
\title{Zenodo: get available collections}
\usage{
zen_collections(n = 1000, access_token = Sys.getenv("ZENODO_TOKEN"))
}
\arguments{
\item{n}{number of zenodo entries ("size") to return per API call (default: 1000)}

\item{access_token}{Zenodo access token (default: Sys.getenv("ZENODO_TOKEN"))}
}
\value{
a tibble of available Zenodo data
}
\description{
Zenodo: get available collections
}
\seealso{
\url{https://developers.zenodo.org/#depositions}
}
