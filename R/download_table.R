#' Downloads the Unified Processual Table.
#' 
#' @param type String containing the type of the table.
#' @param crt String containing the court of the table.
#' @param lvl String containing the level of the table.
#' @return The path of the download file.
#' @examples
#' download_table("mov","estadual","1º grau")
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
