#' @name shr_list_products
#' @aliases shr_list_products
#' @title Get products available for a given collection, roi and time range
#' @export
#'
#' @importFrom sf st_transform
#' @importFrom utils URLencode
#' @importFrom jsonlite fromJSON
#'
#' @examples
#'
#' \dontrun{
#'
#' # login to the wms server
#' log_s1 <- shr_login(Sys.getenv("instance_id_shub_s1"))
#' log_s2 <- shr_login(Sys.getenv("instance_id_shub_s2"))
#'
#' roi <- sf::st_as_sf(data.frame(geom="POLYGON ((-5.82 9.54, -5.42 9.55, -5.41 8.84, -5.81 8.84, -5.82 9.54))"),wkt="geom",crs = 4326)
#' time_range<-as.Date(c("2017-01-01","2017-01-30"))
#'
#' # get Sentinel 1 products available
#' (s1_products_available <-shr_list_products(collection = "S1-AWS-IW-VVVH", roi = roi, time_range = time_range))
#'
#' # get Sentinel 2 L2A products available
#' (s2l2a_products_available <-shr_list_products(collection = "S2L2A", roi = roi, time_range = time_range))
#'
#' }


shr_list_products <- function(collection,
                              roi,
                              time_range,
                              instance_id=NULL){


  if(is.null(instance_id)){
    instance_id <- .getInstanceId(collection)
  } else {
    instance_id <- instance_id
  }

  if(collection=="S2L1C"){
    typenames="DSS1"
  } else if (collection == "S2L2A"){
    typenames="DSS2"
  } else if (collection == "S1-AWS-IW-VVVH"){
    typenames="DSS3"
  }

  if(length(time_range)==1){time_range=c(time_range,time_range)}

  epsg <- .getUTMepsg(roi)
  roi <- sf::st_transform(roi,epsg) %>% sf::st_zm()

  # get dates of images available through a WFS query
  # see https://www.sentinel-hub.com/develop/documentation/faq#t32n443 / https://www.sentinel-hub.com/faq/how-are-values-calculated-within-sentinel-hub-and-how-are-they-returned-output
  wfs <- utils::URLencode(paste0("https://services.sentinel-hub.com/ogc/wfs/",instance_id,"?version=2.0.0&service=WFS&request=GetFeature&SRSNAME=EPSG:",epsg,"&geometry=",sf::st_as_text(roi$geom),"&time=",time_range[1],"/",time_range[2],"/P1D&typenames=",typenames,"&outputformat=application/json"))
  df_data_available <- jsonlite::fromJSON(wfs)$features

  if(length(df_data_available)==0){warning("no products available for the time frame / roi specified")}
  return(df_data_available)

}
