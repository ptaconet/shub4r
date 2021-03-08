#' @name shr_get_url
#' @aliases shr_get_url
#' @title Get URLs of Sentinel datasets
#' @description This function enables to retrieve WMS URLs of Sentinel products given a collection, a ROI, a time frame and a set of bands of interest.
#'
#' @return a data.frame with one row for each dataset and 3 columns  :
#'  \itemize{
#'  \item{*time_start*: }{Start Date/time for the dataset}
#'  \item{*name*: }{An indicative name for the dataset}
#'  \item{*url*: }{WMS URL for the dataset}
#'  }
#'
#' @details
#'
#' Available collections : S2L2A, S1-AWS-IW-VVVH
#'
#' Available dimensions :
#' \itemize{
#' \item{for collection S2L2A  : } {1_TRUE_COLOR, 2_FALSE_COLOR, 3_NDVI, 4_FALSE_COLOR, 5_MOISTURE_INDEX, 6_SWIR, 7-NDWI, 8_NDSI, 9_SCENE_CLASSIFICATION, B01, B02, etc... B12}
#' \item{for collection S1-AWS-IW-VVVH : } {towrite}
#' }
#'
#' @author Paul Taconet, IRD \email{paul.taconet@ird.fr}
#'
#' @import sf dplyr
#' @importFrom utils URLencode
#' @importFrom purrr map_chr
#'
#' @export
#'
#' @examples
#'
#' \dontrun{
#' # login to the wms server
#' log_s1 <- shr_login(Sys.getenv("instance_id_shub_s1"),"sentinel1")
#' log_s2 <- shr_login(Sys.getenv("instance_id_shub_s2"),"sentinel2")
#'
#' roi <- sf::st_as_sf(data.frame(geom="POLYGON ((-5.82 9.54, -5.42 9.55, -5.41 8.84, -5.81 8.84, -5.82 9.54))"),wkt="geom",crs = 4326)
#' time_range<-as.Date(c("2017-01-01","2017-01-30"))
#'
#' (s1_urls <-shr_get_url(collection = "S1-AWS-IW-VVVH", variables = c("VV","VH") ,roi = roi, time_range = time_range))
#'
#' (s2l2a_urls <-shr_get_url(collection = "S2L2A", variables = c("B04","B08","B8A","B11","9_SCENE_CLASSIFICATION") ,roi = roi, time_range = time_range))
#'}

shr_get_url<-function(collection,
                      variables,
                      roi,
                      time_range, # mandatory. either a time range (e.g. c(date_start,date_end) ) or a single date e.g. ( date_start )
                      instance_id=NULL,
                      verbose=FALSE

){

   if(is.null(instance_id)){
      instance_id <- .getInstanceId(collection)
   } else {
      instance_id <- instance_id
   }

 df_data_available <- shr_list_products(collection,roi,time_range,instance_id)

 dates_to_retrieve <- unique(df_data_available$properties$date)


 if(length(time_range)==1){time_range=c(time_range,time_range)}

 epsg <- .getUTMepsg(roi)
 roi <- sf::st_transform(roi,epsg) %>% sf::st_zm()

 # We can download max 2500 * 2500 pixels image from Sinergize WMS servers.
 grid_2500px <- sf::st_make_grid(roi,what="polygons",cellsize = 25000) %>%
    sf::st_crop(roi) %>%
    sf::st_as_text()

 grid_2500px_df <- data.frame(area_wkt=grid_2500px,part_number=seq(1,length(grid_2500px),1),stringsAsFactors = F)

 if(length(df_data_available)>0){
 # Build URLs to download data
 res <- expand.grid(variables, grid_2500px, dates_to_retrieve) %>%
   dplyr::rename(band=Var1,area_wkt=Var2,time_start=Var3) %>%
   dplyr::mutate(url=paste0("https://services.sentinel-hub.com/ogc/wms/",instance_id,"?version=1.1.1&service=WMS&request=GetMap&format=image/tiff&crs=EPSG:",epsg,"&layers=",band,"&geometry=",area_wkt,"&RESX=10&RESY=10&time=",time_start,"/",time_start,"&showlogo=false&transparent=false&maxcc=100&evalsource=",collection)) %>%
   dplyr::left_join(grid_2500px_df,by="area_wkt") %>%
   dplyr::mutate(name=paste0(collection,"_",gsub("-","",time_start),"_",band,"__p",part_number)) %>%
   dplyr::mutate(destfile=file.path(collection,paste0(name,".tif"))) %>%
   dplyr::select(name,time_start,destfile,url) %>%
   dplyr::arrange(time_start,name) %>%
   dplyr::mutate(time_start=as.character(time_start))

 res$url <- purrr::map_chr(res$url,~utils::URLencode(.))

 } else {
    res <- data.frame(time_start=NA,name=NA,url=NA,destfile=NA)
 }
  return(res)

}

