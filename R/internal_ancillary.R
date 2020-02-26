#' @name .getUTMepsg
#' @title get UTM espg for a given roi
#' @noRd
#' @import sf

.getUTMepsg<-function(roi){
  bbox<-sf::st_bbox(sf::st_transform(roi,4326))
  utm_zone_number<-(floor((bbox$xmin + 180)/6) %% 60) + 1
  if(bbox$ymin>0){ # if latitudes are North
  epsg<-as.numeric(paste0("326",utm_zone_number))
  } else { # if latitude are South
    epsg<-as.numeric(paste0("325",utm_zone_number))
  }

  return(epsg)

}

#' @name .getInstanceId
#' @title get instance id and typenames for a given collection
#' @noRd
#'
.getInstanceId<-function(collection){

  if(collection %in% c("S2L2A","S2L1C")){
    if(!getOption("s2_login")){stop("Instance id is not provided")}
    instance_id=getOption("instance_id_s2")
  } else if (collection == "S1-AWS-IW-VVVH"){
    if(!getOption("s2_login")){stop("Instance id is not provided")}
    instance_id=getOption("instance_id_s1")
  }

  return(instance_id)

}
