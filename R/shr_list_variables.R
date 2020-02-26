#' @name odr_list_variables
#' @aliases odr_list_variables
#' @title Get informations related to the variables available for a given collection
#' @description Get the variables available for a given collection
#'
#' @inheritParams shr_get_url
#'
#' @return A data.frame with the available variables for the collection, and a set of related information for each variable.
#'
#' @export
#'
#' @examples
#'
#' # Get the variables available for the collection S2L2A
#' (df_varinfo <- shr_list_variables("S2L2A"))
#'
#'

shr_list_variables<-function(collection){  # for a given collection, get the available variables and associated information

  df_variables <- NULL

  if(!(collection %in% c("S2L1C","S2L2A","S1-AWS-IW-VVVH"))){stop("the collection that you specified does not exist")}

  df_variables <- shrVariables_internal[which(shrVariables_internal$collection==collection),]

  return(df_variables)

}
