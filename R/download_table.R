download_table <-
function(type, crt, lvl, arq = tempfile(), return_file = T){
  
  type %<>% type_fix() 
  crt %<>% court_fix()
  lvl %<>% level_fix()
  
  u <- tpur::table_links %>% 
    filter(table_type == type,
           court == crt,
           level == lvl)
  
  if(nrow(u) == 0){
    stop("Não há tabela com essas configurações.")
  } else {
    u <- u$link[1]
  }
  
  httr::GET(u, httr::config(ssl_verifypeer = FALSE), httr::write_disk(arq))
  
  if(return_file){
    arq
  }
}
