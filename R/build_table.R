#' Transforms the raw table file in something better.
#' 
#' @param arq A string containing the path to the raw table.
#' @return The raw table in tibble format with cleaned names and more intelligible tree format.
#' @examples
#' build_table(download_table("mov","estadual","1º grau"))
#' build_table(download_table("mov","federal","1º grau"))
build_table <-
function(arq){
  xml2::read_html(arq) %>%
    rvest::html_table(fill=T) %>%
    dplyr::first() %>% 
    setNames(.[1,]) %>% 
    janitor::clean_names() %>% 
    setNames(abjutils::rm_accent(names(.))) %>% 
    tibble::as_tibble() %>% 
    dplyr::mutate(codigo = abjutils::rm_accent(codigo),
                  codigo = gsub('[.,/\\]', '', codigo)) %>% 
    filter(!stringr::str_detect(codigo, "[:alpha:]"),nchar(codigo) > 0) %>% 
    name_fix() %>% 
    roll_down_on_null(n1,n2,n3,n4,n5) %>% 
    mutate(folha = codigo %in% leaf_classifier(.)) 
}