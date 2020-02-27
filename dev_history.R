require(dplyr)


shrMetadata_internal <- read.csv("/home/ptaconet/shub4r/.data_collections.csv",stringsAsFactors =F ) %>% dplyr::arrange(collection)
shrVariables_internal <- read.csv("/home/ptaconet/shub4r/.variables.csv",stringsAsFactors =F ) %>% dplyr::arrange(collection)

usethis::use_data(shrMetadata_internal,shrVariables_internal,internal = TRUE,overwrite = TRUE)

devtools::document()
devtools::install()

