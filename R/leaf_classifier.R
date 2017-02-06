#' Creates a bnlearn's graph based on a its edges.
#' 
#' @param edges A 2 column matrix containg the edges of the graph.
#' @return A bnlearn type graph.
cria_bn <-
function (edges) {
  nm <- unique(as.character(edges))
  g <- bnlearn::empty.graph(nm)
  bnlearn::arcs(g) <- edges
  g
}

#' Returns a leaf list from a Unified Processual Table.
#' 
#' @param pre_processed_table A Unified Processual Table processed with build_table.
#' @return A list with the edges of the table.
leaf_classifier <- function(pre_processed_table){
   pre_processed_table %>% 
    dplyr::select(cod_pai, codigo) %>% 
    dplyr::filter(!is.na(cod_pai)) %>% 
    dplyr::distinct(cod_pai, codigo) %>% 
    as.matrix() %>% 
    apply(2, as.character) %>% 
    cria_bn() %>% 
    bnlearn::leaf.nodes()
}

add_leaf_flag <- function(d) {
  ife <- dplyr::if_else
  le <- function(x) dplyr::lead(x == '', default = TRUE)
  d %>% 
    dplyr::mutate(
      folha = ife(n6 != '', 'n6', ''),
      folha = ife(n5 != '' & le(n6), 'n5', folha),
      folha = ife(n4 != '' & le(n5), 'n4', folha),
      folha = ife(n3 != '' & le(n4), 'n3', folha),
      folha = ife(n2 != '' & le(n3), 'n2', folha),
      folha = ife(n1 != '' & le(n2), 'n1', folha)
    )
}