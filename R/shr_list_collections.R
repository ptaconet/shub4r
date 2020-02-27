#' @name shr_list_collections
#' @aliases shr_list_collections
#' @title Get data sources / collections implemented in the package
#' @description This function returns a table of the data sources / collections that can be downloaded using the shub4r package
#' @export
#'
#' @usage shr_list_collections()
#'
#' @return a data.frame with the data sources / collections dealt by shr_list_collections, along with details on each data collection
#'
#'
#' @export
#' @examples
#'
#' sources<-shr_list_collections()
#' sources
#'
#' @author Paul Taconet, \email{paul.taconet@@ird.fr}
#'


shr_list_collections<-function(){

  return(shrMetadata_internal)

}
