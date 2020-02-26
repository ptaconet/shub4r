require(dplyr)

shrVariables_internal <- read.csv("/home/ptaconet/shub4r/.variables.csv",stringsAsFactors =F ) %>% dplyr::arrange(collection)

usethis::use_data(shrVariables_internal,internal = TRUE,overwrite = TRUE)

devtools::document()
devtools::install()

