download_table <-
function(type, level, arq = tempfile(), return_file = F){
  
  type %<>% type_fix() 
  
  session <- httr::GET(u)
  
  httr::GET(u, httr::config(ssl_verifypeer = FALSE), httr::write_disk(arq))
  
}
