#' Transforms the raw table file in something better.
#' 
#' @importFrom magrittr %>%
#' 
#' @param arq A string containing the path to the raw table.
#' @return The raw table in tibble format with cleaned names and more intelligible tree format.
#' @examples
#' 
#' library(tpur); build_table(download_table("mov","estadual","1 grau"));build_table(download_table("mov","federal","1 grau"))
#' @export
build_table <-function(arq){
  xml2::read_html(arq) %>%
    rvest::html_table(fill=T) %>%
    dplyr::first() %>% 
    stats::setNames(.[1,]) %>% 
    janitor::clean_names() %>% 
    stats::setNames(abjutils::rm_accent(names(.))) %>% 
    tibble::as_tibble() %>% 
    dplyr::mutate(codigo = abjutils::rm_accent(codigo),
                  codigo = gsub('[.,/\\]', '', codigo)) %>% 
    dplyr::filter(!stringr::str_detect(codigo, "[:alpha:]"),nchar(codigo) > 0) %>% 
    name_fix() %>% 
    roll_down_on_null(n1,n2,n3,n4,n5) %>% 
    dplyr::mutate(folha = codigo %in% leaf_classifier(.)) 
}