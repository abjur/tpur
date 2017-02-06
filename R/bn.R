#' Probability of leaf nodes
#' 
#' @param d_litig base de dados processual.
#' @param leafs nomes das folhas a serem incluidas na pesquisa.
#' @param tpu TPU a ser utilizada como base do modelo. 
#' @param model modelo de classe. Defaults to independent model (MCAR).
#' 
#' @export
tpu_assunto_prob <- function(d_litig, leafs, tpu, model = bn_indep()) {
  # roll!
  rm <- abjutils::rm_accent
  cnj_roll <- tpu %>%
    dplyr::select(n1:n6) %>%
    dplyr::mutate(n2 = dplyr::if_else(n2 == '', n1, n2),
                  n3 = dplyr::if_else(n3 == '', n2, n3),
                  n4 = dplyr::if_else(n4 == '', n3, n4),
                  n5 = dplyr::if_else(n5 == '', n4, n5),
                  n6 = dplyr::if_else(n6 == '', n5, n6)) %>%
    dplyr::mutate_all(dplyr::funs(rm)) %>% 
    # here we kill duplicate leaf nodes
    # this is clearly wrong
    # the only alternative is to use assuntos IDs
    # but they are not available via webscraping
    dplyr::distinct(n6, .keep_all = TRUE)
  # empilhado
  cnj_roll_empilhado <- cnj_roll %>%
    tidyr::gather(nivel, assunto, n1:n6, factor_key = TRUE) %>%
    dplyr::arrange(nivel, assunto) %>%
    dplyr::distinct(nivel, assunto) %>%
    dplyr::mutate(nivel = as.character(nivel))
  d_modelo <- d_litig %>%
    dplyr::mutate(assunto = rm(assunto)) %>%
    dplyr::inner_join(cnj_roll, c('assunto' = 'n6')) %>%
    dplyr::mutate(y = assunto %in% rm(leafs)) %>% 
    dplyr::select(n1:n5, n6 = assunto, y) %>%
    dplyr::mutate_all(as.factor) %>%
    as.data.frame()
  # modelo redes bayesianas
  fit <- bnlearn::bn.fit(model, d_modelo)
  d_litig %>%
    dplyr::mutate(assunto_clean = rm(assunto)) %>% 
    dplyr::group_by(assunto_clean) %>% 
    dplyr::do({
      dd <- .
      ass <- dd$assunto_clean[1]
      nn <- cnj_roll_empilhado %>%
        dplyr::filter(assunto == ass) %>%
        with(nivel) %>%
        sort() %>% 
        dplyr::last()
      if (is.na(nn)) {
        dd$p <- 0
      } else {
        nm <- as.name(nn)
        l <- substitute((X == Y), list(X = nm, Y = ass))
        assign('.very_unlikely_var_name', l, .GlobalEnv)
        dd$p <- bnlearn::cpquery(fit, (y == 'TRUE'), 
                                 eval(.very_unlikely_var_name))
      }
      dd
    }) %>%
    dplyr::ungroup() %>% 
    dplyr::select(-assunto_clean)
}

bn_indep <- function() {
  g <- bnlearn::empty.graph(c(paste0('n', 1:6), 'y'))
  edges <- matrix(c(
    'n1', rep(paste0('n', 2:6), each = 2), 'y' 
  ), ncol = 2, byrow = TRUE)
  bnlearn::arcs(g) <- edges
  g
}
