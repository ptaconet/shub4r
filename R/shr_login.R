#' @name shr_login
#' @title Login to query servers and download data
#' @description Login before querying data servers
#'
#' @param instance_id instance id
#' @param source source. See details
#'
#' @return None.
#' @export
#'
#' @details
#'
#' Current options for parameter \code{"source"} are :
#' \itemize{
#' \item{"sentinel1"}{ : to query and download Sentinel 1 collections}
#' \item{"sentinel2"}{ : to query and download Sentinel 2 collections}
#'}
#' Create an account to the Sentinel Hub OGC web services here : \url{https://sentinel-hub.com/pricing-plans}.
#'
#' @importFrom utils URLencode
#' @import httr
#'
#' @examples
#'
#' \donttest{
#' instance_id_s1 <- Sys.getenv("instance_id_shub_s1")
#' instance_id_s2 <- Sys.getenv("instance_id_shub_s2")
#'
#' shr_login(instance_id_s1,source = "sentinel1")
#' shr_login(instance_id_s2,source = "sentinel2")
#' }
#'

shr_login <- function(instance_id,source,verbose=TRUE){

  wfs <- utils::URLencode(paste0("https://services.sentinel-hub.com/ogc/wfs/",instance_id,"?version=2.0.0&service=WFS&request=GetCapabilities"))
  x <- httr::GET(wfs)
  httr::stop_for_status(x, "login to the wms servers. Check out instance id")
  httr::warn_for_status(x)
  if(source=="sentinel1"){
    options(instance_id_s1=instance_id)
    options(s1_login=TRUE)
  } else if (source=="sentinel2"){
    options(instance_id_s2=instance_id)
    options(s2_login=TRUE)
  }

  if(verbose){cat("Successfull login to",source,"\n")}

}
