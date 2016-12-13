#' Receives the status code of a GET requisition.
#' 
#' @param x The url to be requested.
#' @return The status code of the get requisiton.
#' @examples
#' is_page_on("www.google.com")
is_page_on <-
function(x){
  sapply(x, function(t){httr::GET(t)$status_code})
}
