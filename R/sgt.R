# sgt_atuais

sgt_atual_download <- function(tipo, path = "data-raw/sgt_atual") {
  u_sgt <- glue::glue("https://www.cnj.jus.br/sgt/versoes.php?tipo_tabela={tipo}")
  file <- glue::glue("{path}/sgt_{tipo}.html")
  r_sgt <- httr::GET(u_sgt, httr::write_disk(file, overwrite = TRUE))
}

sgt_atual_parse <- function(file) {

  html <- xml2::read_html(file)
  table <- html |> 
    xml2::xml_find_first("//table[@class='tabelaLista']") |> 
    xml2::xml_find_all(".//tr[@class='itemLista']") 
  
  tipo <- file |> 
    stringr::str_remove("data-raw/sgt_atual/sgt_") |> 
    stringr::str_remove("\\.html") 
  
  da <- purrr::map(table, function(table) {
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
  }) |> 
    dplyr::bind_rows() |> 
    dplyr::mutate(
      link = glue::glue("https://www.cnj.jus.br/sgt/{link}")
    )
  
  return(da)
}

# sgt_anterior

sgt_anterior_download <- function(tipo, path = "data-raw/sgt_anterior") {
  
  u_sgt <- glue::glue("https://www.cnj.jus.br/sgt/versoes_anteriores.php?tipo_tabela={tipo}")
  file <- glue::glue("{path}/sgt_{tipo}.html")
  r_sgt <- httr::GET(u_sgt, httr::write_disk(file, overwrite = TRUE))
  
}

sgt_anterior_parse <- function(file) {
  
  html <- xml2::read_html(file)
  table <- html |> 
    xml2::xml_find_all("//table[@class='tabelaLista']") |> 
    xml2::xml_find_all(".//tr[@class='itemLista']") 
  
  tipo <- file |> 
    stringr::str_remove("data-raw/sgt_anterior/sgt_") |> 
    stringr::str_remove("\\.html") 
  
  da <- purrr::map(table, function(table) {
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
  }) |> dplyr::bind_rows() |> 
    dplyr::mutate(
      link = glue::glue("https://www.cnj.jus.br/sgt/{link}")
    )
  
  return(da)
}

sgt_tidy <- function(da) {
  a <- da |> 
    dplyr::mutate(
      tipo_abbr = tipo,
      tipo = dplyr::case_when(
        tipo == "A" ~ "Assuntos",
        tipo == "C" ~ "Classes",
        tipo == "M" ~ "Movimentos"
      ),
      justica_abbr = dplyr::case_when(
        justica == "Justiça do Trabalho" ~ "JT",
        justica == "Justiça Federal" ~ "JF",
        justica == "Justiça Estadual" ~ "JEs",
        justica == "Justiça Eleitoral" ~ "JEl",
        justica == "Justiça Militar" ~ "JM",
        justica == "Superiores" ~ "S",
      ),
      tabela = stringr::str_squish(tabela),
      tabela = stringr::str_replace_all(tabela, "º", "°"),
      tabela_abbr = dplyr::case_when(
        tabela == "Trabalho 1° Grau" ~ "1",
        tabela == "Trabalho 2° Grau" ~ "2",
        tabela == "Trabalho TST" ~ "S",
        tabela == "Federal 1° Grau" ~ "1",
        tabela == "Federal 2° Grau" ~ "2",
        tabela == "Federal Juizado Especial" ~ "JEC",
        tabela == "Federal Turmas Recursais" ~ "TR",
        tabela == "Federal Turma Nacional de Uniformização" ~ "TNU",
        tabela == "Federal Turma Regional de Uniformização" ~ "TRU",
        tabela == "Estadual 1° Grau" ~ "1",
        tabela == "Estadual 2° Grau" ~ "2",
        tabela == "Estadual Juizado Especial" ~ "JEC",
        tabela == "Estadual Turmas Recursais" ~ "TR",
        tabela == "Estadual Turmas Recursais de Uniformização" ~ "TRU",
        tabela == "Juizados Especiais Fazenda Pública" ~ "JECFP",
        tabela == "Juizados Especiais da Fazenda Pública" ~ "JECFP",
        tabela == "Turma Estadual de Uniformização" ~ "TEU",
        tabela == "Militar da União 1°" ~ "U1",
        tabela == "Militar União 1° Grau" ~ "U1",
        tabela == "Militar da União STM" ~ "STM",
        tabela == "Militar União STM" ~ "STM",
        tabela == "Militar Estadual 1°" ~ "E1",
        tabela == "Militar Estadual 1° Grau" ~ "E1",
        tabela == "Militar Estadual TJM" ~ "TJM",
        tabela == "Justiça Eleitoral - Zonas Eleitorais" ~ "ZE",
        tabela == "Eleitoral Zonas Eleitorais" ~ "ZE",
        tabela == "Eleitoral TRE" ~ "TRE",
        tabela == "Justiça Eleitoral - TRE" ~ "TRE",
        tabela == "Eleitoral TSE" ~ "TSE",
        tabela == "Justiça Eleitoral - TSE" ~ "TSE",
        justica == "Superiores" ~ tabela
      ),
      data_versao = lubridate::dmy(data_versao),
      sigla = glue::glue("{tipo_abbr}_{data_versao}_{justica_abbr}{tabela_abbr}")
    ) |> 
    dplyr::select(
      sigla,
      tipo,
      tipo_abbr,
      data_versao,
      justica,
      tabela,
      link
    )
}
