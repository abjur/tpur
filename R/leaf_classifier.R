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
leaf_classifier <-
function(pre_processed_table){
   pre_processed_table %>% 
    dplyr::select(cod_pai, codigo) %>% 
    dplyr::filter(!is.na(cod_pai)) %>% 
    dplyr::distinct(cod_pai, codigo) %>% 
    as.matrix() %>% 
    apply(2, as.character) %>% 
    cria_bn %>% 
    bnlearn::leaf.nodes()
}