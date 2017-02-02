#' Transforms the raw table file in something better.
#' 
#' @importFrom magrittr %>%
#' 
#' @param arq A string containing the path to the raw table.
#' @return The raw table in tibble format with cleaned names and more intelligible tree format.
#' @examples
#' 
#' library(tpur)
#' build_table(download_table("mov","estadual","1 grau"))
#' build_table(download_table("mov","federal","1 grau"))
#' @export
build_table <-function(arq){
  html <- xml2::read_html(arq)
  titulos <- html %>% 
    rvest::html_nodes(xpath = '//tr[1]//td') %>% {
      colspan <- as.numeric(rvest::html_attr(., 'colspan'))
      colspan <- ifelse(is.na(colspan), 1, colspan)
      stringr::str_trim(rep(rvest::html_text(.), colspan))
    }
  raiz <- "processuais"
  tab <- html %>% 
    rvest::html_nodes(xpath = '//table/*[not(@align="left")]') %>% 
    purrr::map(arrumar_linha) %>% 
    dplyr::bind_rows() %>% 
    dplyr::select(V0, dplyr::everything()) %>% 
    stats::setNames(c(raiz, titulos)) %>% 
    janitor::clean_names() %>% 
    stats::setNames(abjutils::rm_accent(names(.))) %>% 
    tibble::as_tibble() %>% 
    dplyr::mutate(codigo = abjutils::rm_accent(codigo),
                  codigo = gsub('[.,/\\]', '', codigo)) %>% 
    # dplyr::filter(!stringr::str_detect(codigo, "[:alpha:]"), nchar(codigo) > 0) %>% 
    name_fix() %>%
    dplyr::mutate(nas = cumsum(!is.na(n1))) %>% 
    dplyr::filter(nas > 0) %>% 
    dplyr::select(-nas) %>% 
    dplyr::mutate_all(dplyr::funs(ifelse(is.na(.), '', .))) %>% 
    roll_down_on_null(n1, n2, n3, n4, n5, n6) %>% 
    dplyr::filter(codigo != '') %>% 
    dplyr::mutate(folha = codigo %in% leaf_classifier(.)) 
  tab
}

arrumar_linha <- function(.x) {
  x <- rvest::html_nodes(.x, 'td')
  if (length(x) == 0) {
    a <- .x %>% 
      rvest::html_text() %>% 
      stringr::str_trim() %>% 
      t() %>% 
      tibble::as_tibble() %>% 
      stats::setNames('V0')
    b <- .x %>% 
      rvest::html_node(xpath = './following-sibling::td[1]') %>% 
      rvest::html_text()
    # a$V2 <- b
  } else {
    a <- x %>% 
      rvest::html_text() %>% 
      stringr::str_trim() %>% 
      t() %>% 
      tibble::as_tibble()
  }
  a
}
