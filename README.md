[![R-CMD-check](https://github.com/KWB-R/kwb.pkgstatus/workflows/R-CMD-check/badge.svg)](https://github.com/KWB-R/kwb.pkgstatus/actions?query=workflow%3AR-CMD-check)
[![pkgdown](https://github.com/KWB-R/kwb.pkgstatus/workflows/pkgdown/badge.svg)](https://github.com/KWB-R/kwb.pkgstatus/actions?query=workflow%3Apkgdown)
[![codecov](https://codecov.io/github/KWB-R/kwb.pkgstatus/branch/master/graphs/badge.svg)](https://codecov.io/github/KWB-R/kwb.pkgstatus)
[![Project Status](https://img.shields.io/badge/lifecycle-experimental-orange.svg)](https://www.tidyverse.org/lifecycle/#experimental)
[![CRAN_Status_Badge](https://www.r-pkg.org/badges/version/kwb.pkgstatus)]()
[![R-Universe_Status_Badge](https://kwb-r.r-universe.dev/badges/kwb.pkgstatus)](https://kwb-r.r-universe.dev/)

# kwb.pkgstatus

R package for checking KWB package status (e.g.
generating https://kwb-r.github.io/status).

## Installation

For details on how to install KWB-R packages checkout our [installation tutorial](https://kwb-r.github.io/kwb.pkgbuild/articles/install.html).

```r
### Optionally: specify GitHub Personal Access Token (GITHUB_PAT)
### See here why this might be important for you:
### https://kwb-r.github.io/kwb.pkgbuild/articles/install.html#set-your-github_pat

# Sys.setenv(GITHUB_PAT = "mysecret_access_token")

# Install package "remotes" from CRAN
if (! require("remotes")) {
  install.packages("remotes", repos = "https://cloud.r-project.org")
}

# Install KWB package 'kwb.pkgstatus' from GitHub
remotes::install_github("KWB-R/kwb.pkgstatus")
```

## Documentation

Release: [https://kwb-r.github.io/kwb.pkgstatus](https://kwb-r.github.io/kwb.pkgstatus)

Development: [https://kwb-r.github.io/kwb.pkgstatus/dev](https://kwb-r.github.io/kwb.pkgstatus/dev)
