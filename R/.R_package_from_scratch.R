### How to build an R package from scratch

usethis::create_package(".")
fs::file_delete(path = "DESCRIPTION")

author <- list(name = "Michael Rustler", 
               orcid = "0000-0003-0647-7726",
               url = "http://mrustl.de")

pkg <- list(name = "kwb.pkgstatus", 
            title = "R package for checking KWB package status", 
            desc  = paste("R package for checking KWB package status",
"(e.g. generating https://kwb-r.github.io/status)"))

kwb.pkgbuild::use_pkg(author, 
                     pkg, 
                     version = "0.1.0.9000",
                     stage = "experimental")


usethis::use_vignette("Tutorial")

### R functions


secrets_csv <- "C:/Users/mrustl.KWB/Documents/WC_Server/R_Development/trunk/RScripts/FAKIN/Github_StatusReport/secrets.csv"

kwb.pkgstatus::prepare_status_rpackages(secrets_csv)

kwb.pkgstatus::create_report_rpackages(secrets_csv,
                                       export_dir = getwd())
