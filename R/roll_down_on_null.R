#' Replaces every NA in some columns by the last non null string observed.
#' 
#' @param d a data frame.
#' @param ... columns to be drilled down.
#' @return d with different columns names.

roll_down_on_null <- function(d, ...){
  
  n_nodes <- lazyeval::lazy_dots(...) %>% length()
  
  d_aux <- d %>%
    dplyr::select(...) %>%
    dplyr::mutate_each(dplyr::funs(cumsum(!(.==''))))
  
  for(ii in 2:ncol(d_aux)) {
    d_aux[,ii] = d_aux[,ii] +
      cumsum(c(0, diff(d_aux[,ii-1])))
  }
  
  d_aux <- d_aux %>%
    tidyr::gather(variavel, grupo)
  
  d_aux <- d %>%
    dplyr::select(...) %>%
    tidyr::gather(variavel, valor) %>%
    dplyr::select(-variavel) %>%
    dplyr::bind_cols(d_aux)
  
  d_2 <- d_aux %>%
    dplyr::group_by(variavel, grupo) %>%
    dplyr::mutate(valor = valor[1]) %>%
    dplyr::group_by(variavel) %>%
    dplyr::mutate(id = 1:n()) %>%
    dplyr::ungroup() %>%
    dplyr::select(-grupo) %>%
    tidyr::spread(variavel, valor) %>%
    dplyr::select(...)
  
  d[names(d_2)] <- d_2
  
  return(d)
}
