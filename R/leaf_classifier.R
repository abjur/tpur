cria_bn <-
function (edges) {
  nm <- unique(as.character(edges))
  g <- bnlearn::empty.graph(nm)
  bnlearn::arcs(g) <- edges
  g
}

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