

is_page_on <-
function(x){
  sapply(x, function(t){httr::GET(t)$status_code})
}
