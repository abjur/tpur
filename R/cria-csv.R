#' Cria o arquivo .csv
#' 
#' Baixa um arquivo html na pasta indicada
#' 
#' @param da Base de dados que será salva como csv
#' @param path_csv Diretório em que o csv será salvo
#' 
#' @return Não retorna nada
cria_csv <- function(da, path_csv){
  fs::dir_create(path_csv)
  id <- da |> 
    dplyr::distinct(id) |> 
    dplyr::pull()
  path_file <- paste0(path_csv, "/", id, ".csv")
  readr::write_csv(da, path_file)
}