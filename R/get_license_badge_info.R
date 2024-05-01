# get_license_badge_info -------------------------------------------------------
get_license_badge_info <- function()
{
  data.frame(
    key = c(
      "agpl-3.0", 
      "apache-2.0", 
      "bsd-2-clause", 
      "bsd-3-clause", 
      "epl-2.0",
      "gpl-2.0",
      "gpl-3.0",    
      "lgpl-2.1",
      "lgpl-3.0", 
      "mit", 
      "mpl-2.0", 
      "unlicense"
    ),   
    image_url = c(
      compose_url_badge(c(
        "License-AGPL%20v3-blue.svg", 
        "License-Apache%202.0-blue.svg",
        "License-BSD%202--Clause-orange.svg",
        "License-BSD%203--Clause-blue.svg"
      )),
      "",
      compose_url_badge(c(
        "License-GPL%20v2-blue.svg",
        "License-GPL%20v3-blue.svg"
      )),
      "",
      compose_url_badge(c(
        "License-LGPL%20v3-blue.svg", 
        "License-MIT-yellow.svg", 
        "License-MPL%202.0-brightgreen.svg", 
        "license-Unlicense-blue.svg"
      ))
    ),
    license_url = c(
      compose_url_opensource(path = c(
        "licenses/AGPL-3.0", 
        "licenses/Apache-2.0", 
        "licenses/BSD-2-Clause", 
        "licenses/BSD-3-Clause"
      )),
      compose_url_eclipse(
        path = "legal/epl-2.0/"
      ),
      compose_url_gnu(path = c(
        "licenses/gpl-2.0",
        "licenses/gpl-3.0",    
        "licenses/lgpl-2.1",
        "licenses/lgpl-3.0"
      )),
      compose_url_opensource(path = c(
        "licenses/MIT", 
        "licenses/MPL-2.0"
      )),
      compose_url_unlicense()
    ),
    stringsAsFactors = FALSE
  )
}
