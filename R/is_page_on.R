#' Receives the status code of a GET request
#' 
#' @param x The url to be requested.
#' @return The status code of the get request.
#' @examples
#' is_page_on("www.google.com")
#' @export
is_page_on <-
function(x){
  sapply(x, function(t){httr::GET(t)$status_code})
}
