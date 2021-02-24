#' Create R packages status report#'
#' @param secrets_csv path to "secrets.csv" file, if "NULL" Sys.env variables 
#' for the following services are used/need to be defined: APPVEYOR_TOKEN, 
#' GITHUB_TOKEN, GITLAB_TOKEN, CODECOV_TOKEN, ZENODO_TOKEN, 
#' (default: NULL)
#' @param non_r_packages a character vector with repositories in KWB-R group that
#' are not R packages (default: \code{get_non_r_packages})
#' @param export_dir report export directory (default: ".")
#' @param input_rmd default: system.file("extdata/reports/status_report.Rmd", 
#' package = "kwb.pkgstatus")
#' @return creates html status report for R packages and returns the absolute 
#' path to the export directory
#' @importFrom fs dir_create path_real 
#' @export
create_report_rpackages <- function (secrets_csv = NULL, 
non_r_packages = get_non_r_packages(),
                                     export_dir = ".", 
  input_rmd = system.file("extdata/reports/status_report.Rmd", 
             package = "kwb.pkgstatus")) {
  
  
  fs::dir_create(export_dir)

  rmarkdown::render(input = input_rmd, 
                    output_format = "html_document", 
                    output_file = "index.html", 
                    output_dir = export_dir, 
                    params = list(secrets_csv = secrets_csv,
                                  non_r_packages = non_r_packages))
  
  
  fs::path_real(export_dir)
}