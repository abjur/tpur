# tpus_atuais

download_tpus_atuais <- function(tipo, path = "data-raw/tpus_atuais") {
  u_sgt <- glue::glue("https://www.cnj.jus.br/sgt/versoes.php?tipo_tabela={tipo}")
  file <- glue::glue("{path}/sgt_{tipo}.html")
  r_sgt <- httr::GET(u_sgt, httr::write_disk(file, overwrite = TRUE))
}

parse_tpus_atuais <- function(file) {

  html <- xml2::read_html(file)
  table <- html |> 
    xml2::xml_find_first("//table[@class='tabelaLista']") |> 
    xml2::xml_find_all(".//tr[@class='itemLista']") 
  
  tipo <- file |> 
    stringr::str_remove("data-raw/tpus_atuais/sgt_") |> 
    stringr::str_remove("\\.html") 
  
  dfs <- lapply(table, function(table) {
    data.frame(
      tipo = tipo,
      data_versao = table |> 
        xml2::xml_find_all(".//td[1]") |> 
        xml2::xml_text(trim = TRUE),
      justica = table |> 
        xml2::xml_find_all(".//td[2]") |> 
        xml2::xml_text(trim = TRUE),
      tabela = table |> 
        xml2::xml_find_all(".//td[3]") |> 
        xml2::xml_find_all(".//option") |> 
        xml2::xml_text(),
      link = table |> 
        xml2::xml_find_all(".//td[3]") |> 
        xml2::xml_find_all(".//option") |> 
        xml2::xml_attr("value")
      
    )
  })
  
  da <- do.call(rbind, dfs) |> 
    dplyr::mutate(
      link = glue::glue("https://www.cnj.jus.br/sgt/{link}")
    )
  
  return(da)
}

# tpus_anteriores

download_tpus_anteriores <- function(tipo, path = "data-raw/tpus_anteriores") {
  
  u_sgt <- glue::glue("https://www.cnj.jus.br/sgt/versoes_anteriores.php?tipo_tabela={tipo}")
  file <- glue::glue("{path}/sgt_{tipo}.html")
  r_sgt <- httr::GET(u_sgt, httr::write_disk(file, overwrite = TRUE))
  
}

parse_tpus_anteriores <- function(file) {
  
  html <- xml2::read_html(file)
  table <- html |> 
    xml2::xml_find_all("//table[@class='tabelaLista']") |> 
    xml2::xml_find_all(".//tr[@class='itemLista']") 
  
  tipo <- file |> 
    stringr::str_remove("data-raw/tpus_atuais/sgt_") |> 
    stringr::str_remove("\\.html") 
  
  dfs <- lapply(table, function(table) {
    data.frame(
      tipo = tipo,
      data_versao = table |> 
        xml2::xml_find_all(".//td[1]") |> 
        xml2::xml_text(trim = TRUE),
      justica = table |> 
        xml2::xml_find_all(".//td[2]") |> 
        xml2::xml_text(trim = TRUE),
      tabela = table |> 
        xml2::xml_find_all(".//td[3]") |> 
        xml2::xml_find_all(".//option") |> 
        xml2::xml_text(),
      link = table |> 
        xml2::xml_find_all(".//td[3]") |> 
        xml2::xml_find_all(".//option") |> 
        xml2::xml_attr("value")
      
    )
  })
  
  da <- do.call(rbind, dfs) |> 
    dplyr::mutate(
      link = glue::glue("https://www.cnj.jus.br/sgt/{link}")
    )
  
  return(da)
}
