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
build_table <-function(arq) {
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
    name_fix() %>%
    dplyr::mutate(nas = cumsum(!is.na(n1))) %>% 
    dplyr::filter(nas > 0) %>% 
    dplyr::select(-nas) %>% 
    dplyr::mutate_all(dplyr::funs(ifelse(is.na(.), '', .))) %>% 
    add_leaf_flag() %>% 
    dplyr::mutate_at(dplyr::vars(n1, n2, n3, n4, n5, n6),
                     dplyr::funs(ifelse(. == '', NA_character_, .))) %>% 
    dplyr::mutate(n6 = adicionar_um_abaixo(n6, folha == 'n6')) %>% 
    dplyr::mutate(n5 = adicionar_um_abaixo(n5, folha == 'n5')) %>% 
    dplyr::mutate(n4 = adicionar_um_abaixo(n4, folha == 'n4')) %>% 
    dplyr::mutate(n3 = adicionar_um_abaixo(n3, folha == 'n3')) %>% 
    dplyr::mutate(n2 = adicionar_um_abaixo(n2, folha == 'n2')) %>% 
    dplyr::mutate(n1 = adicionar_um_abaixo(n1, folha == 'n1')) %>% 
    tidyr::fill(n1, n2, n3, n4, n5, n6) %>% 
    dplyr::filter(codigo != '', folha != '') %>% 
    dplyr::mutate(folha = (folha != '')) %>% 
    tidyr::replace_na(list(n1 = '', n2 = '', n3 = '', 
                           n4 = '', n5 = '', n6 = ''))
  tab
}

#' Transforms the raw table file in something better (keeping non leaf nodes)
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
build_table_all_nodes <- function(arq){
  html <- xml2::read_html(arq)
  titulos <- html %>% rvest::html_nodes(xpath = "//tr[1]//td") %>% 
  {
    colspan <- as.numeric(rvest::html_attr(., "colspan"))
    colspan <- ifelse(is.na(colspan), 1, colspan)
    stringr::str_trim(rep(rvest::html_text(.), colspan))
  }
  raiz <- "processuais"
  tab <- html %>% 
    rvest::html_nodes(xpath = "//table/*[not(@align=\"left\")]") %>% 
    purrr::map(tpur:::arrumar_linha) %>% 
    dplyr::bind_rows() %>% 
    dplyr::select(V0, dplyr::everything()) %>% 
    stats::setNames(c(raiz, titulos)) %>% 
    janitor::clean_names() %>% 
    stats::setNames(abjutils::rm_accent(names(.))) %>% 
    tibble::as_tibble() %>% 
    dplyr::mutate(codigo = abjutils::rm_accent(codigo), 
                  codigo = gsub("[.,/\\]", "", codigo)) %>% 
    tpur:::name_fix() %>% 
    dplyr::mutate(nas = cumsum(!is.na(n1))) %>% 
    dplyr::filter(nas > 0) %>% 
    dplyr::select(-nas) %>% 
    dplyr::mutate_all(dplyr::funs(ifelse(is.na(.), "", .))) %>% 
    tpur:::add_leaf_flag() %>% 
    dplyr::mutate_at(dplyr::vars(n1, n2, n3, n4, n5, n6),
                     dplyr::funs(ifelse(. == "", NA_character_, .))) %>% 
    dplyr::mutate(n6 = tpur:::adicionar_um_abaixo(n6, folha == "n6")) %>% 
    dplyr::mutate(n5 = tpur:::adicionar_um_abaixo(n5, folha == "n5")) %>% 
    dplyr::mutate(n4 = tpur:::adicionar_um_abaixo(n4, folha == "n4")) %>% 
    dplyr::mutate(n3 = tpur:::adicionar_um_abaixo(n3, folha == "n3")) %>% 
    dplyr::mutate(n2 = tpur:::adicionar_um_abaixo(n2, folha == "n2")) %>%
    dplyr::mutate(n1 = tpur:::adicionar_um_abaixo(n1, folha == "n1")) %>% 
    tidyr::fill(n1, n2, n3, n4, n5, n6) %>% 
    tidyr::replace_na(list(n1 = "", n2 = "", n3 = "", 
                           n4 = "", n5 = "", n6 = ""))
  tab
}

adicionar_um_abaixo <- function(x, regra) {
  onde <- dplyr::lag(!is.na(x), default = FALSE)
  onde2 <- is.na(x)
  x[onde & onde2 & dplyr::lag(regra, default = FALSE)] <- ''
  x
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
