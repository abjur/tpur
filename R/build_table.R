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

build_table_vec <- 
function(vec){
  lapply(vec,build_table)
}