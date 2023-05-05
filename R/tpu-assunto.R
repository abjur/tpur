tpu_assunto_download <- function(sig, path = "data-raw/tpu/A") {
  load("data/sgt_atual.rda")
  
  u_tpu <- sgt_atual |>
    dplyr::filter(sigla == sig) |> 
    dplyr::pull(link)
  
  file <- glue::glue("{path}/{sig}.html")
  
  r_tpu <- httr::GET(u_tpu, httr::write_disk(file, overwrite = TRUE))
}

tpu_assunto_parse <- function(file) {
  # pega todos os assuntos de nível 2 a 6
  html <- xml2::read_html(file) |>
    xml2::xml_find_first("//table") |> 
    xml2::xml_find_all(".//tr[contains(@style, 'background-color')]") 
  
  da_sem_assunto1 <- purrr::map(html, function(html) {
    tibble::tibble(
      assunto1 = NA_character_,
      assunto2 = html |> 
        xml2::xml_find_all("./td[1]") |>
        xml2::xml_text(trim=TRUE),
      assunto3 = html |> 
        xml2::xml_find_all("./td[2]") |>
        xml2::xml_text(trim=TRUE),
      assunto4 = html |> 
        xml2::xml_find_all("./td[3]") |>
        xml2::xml_text(trim=TRUE),
      assunto5 = html |> 
        xml2::xml_find_all("./td[4]") |>
        xml2::xml_text(trim=TRUE),
      assunto6 = html |> 
        xml2::xml_find_all("./td[5]") |>
        xml2::xml_text(trim=TRUE),
      codigo = html |> 
        xml2::xml_find_all("./td[6]") |>
        xml2::xml_text(trim=TRUE),
      codigo_pai = html |> 
        xml2::xml_find_all("./td[7]") |>
        xml2::xml_text(trim=TRUE),
      dispositivo_legal = html |> 
        xml2::xml_find_all("./td[8]") |>
        xml2::xml_text(trim=TRUE),
      artigo = html |> 
        xml2::xml_find_all("./td[9]") |>
        xml2::xml_text(trim=TRUE),
      alteracoes = html |> 
        xml2::xml_find_all("./td[10]") |>
        xml2::xml_text(trim=TRUE),
      glossario = html |> 
        xml2::xml_find_all("./td[11]") |>
        xml2::xml_text(trim=TRUE),
      dt_publicacao = html |> 
        xml2::xml_find_all("./td[12]") |>
        xml2::xml_text(trim=TRUE),
      dt_alteracao = html |> 
        xml2::xml_find_all("./td[13]") |>
        xml2::xml_text(trim=TRUE),
      dt_inativacao = html |> 
        xml2::xml_find_all("./td[14]") |>
        xml2::xml_text(trim=TRUE),
      dt_reativacao = html |> 
        xml2::xml_find_all("./td[15]") |>
        xml2::xml_text(trim=TRUE)
    ) 
  }) |> 
    dplyr::bind_rows() |> 
    dplyr::mutate(id = dplyr::row_number()*2)
  
  # pega todos assuntos de nível 1
  assunto1_sem_id <- tibble::tibble(
    txt = xml2::read_html(file) |>
      xml2::xml_find_first("//table") |> 
      xml2::xml_find_all("./td[contains(@style, 'background-color:#4c83c8')]") |> 
      xml2::xml_text(trim=TRUE) 
  ) |> 
    dplyr::mutate(
      txt = ifelse(txt == "", NA_character_, txt),
      assunto1 = !stringr::str_detect(txt, "[a-z]|[0-9]")
    )
  
  n_id <- assunto1_sem_id |> 
    dplyr::count(assunto1) |> 
    dplyr::filter(assunto1) |>  
    dplyr::pull(n)
  
  n_col <- da_sem_assunto1 |> 
    dplyr::select(!dplyr::contains("assunto")) |> 
    ncol()
  
  assunto1_ids <- assunto1_sem_id |> 
    dplyr::filter(classe1) |> 
    dplyr::mutate(
      id = ifelse(classe1, 1:n_id, NA_integer_)
    ) 
  
  da_assunto1 <- assunto1_sem_id |> 
    dplyr::left_join(assunto1_ids) |> 
    tidyr::fill(id, .direction="down") |> 
    dplyr::group_by(id) |> 
    dplyr::mutate(
      colname = 1:n_col,
      colname = dplyr::case_when(
        colname == 1 ~ "assunto1",
        colname == 2 ~ "codigo",
        colname == 3 ~ "codigo_pai",
        colname == 4 ~ "dispositivo_legal",
        colname == 5 ~ "artigo",
        colname == 6 ~ "alteracoes",
        colname == 7 ~ "glossario",
        colname == 8 ~ "dt_publicacao",
        colname == 9 ~ "dt_alteracao",
        colname == 10 ~ "dt_inativacao",
        colname == 11 ~ "dt_reativacao"
      )
    ) |> 
    dplyr::ungroup() |> 
    dplyr::select(txt, id, colname) |> 
    tidyr::pivot_wider(values_from = txt, names_from = colname) |> 
    dplyr::transmute(
      assunto1,
      assunto2 = "",
      assunto3 = "",
      assunto4 = "",
      assunto5 = "",
      assunto6 = "",
      codigo,
      codigo_pai,
      dispositivo_legal,
      artigo,
      alteracoes,
      glossario,
      dt_publicacao,
      dt_alteracao,
      dt_inativacao,
      dt_reativacao
    )
  
  # insere os assuntos de nivel 1 junto dos demais assuntos
  da <- da_sem_assunto1
  for(cod in da_assunto1$codigo) {
    posicao_assunto1 <- da |> 
      dplyr::mutate(
        assunto1_acima = codigo_pai == cod
      ) |> 
      dplyr::filter(assunto1_acima) |> 
      dplyr::pull(id) |> 
      min() - 1L
    
    row <- da_assunto1 |> 
      dplyr::filter(codigo == cod) |> 
      dplyr::mutate(id = posicao_assunto1)
    
    da <- da |> 
      dplyr::bind_rows(row) |>
      dplyr::arrange(id) 
  }
  da <- da |> dplyr::select(-id)
  return(da)
}

tpu_assunto_tidy <- function(da) {
  da |> 
    dplyr::mutate(
      dplyr::across(
        everything(),
        ~ifelse(.x == "", NA_character_, .x)
      ),
      dplyr::across(
        dplyr::contains("codigo"),
        ~as.integer(.x)
      ),
      dplyr::across(
        dplyr::starts_with("dt_"),
        ~ifelse(.x == "0000-00-00 00:00:00", NA_character_, .x)
      ),
      dplyr::across(
        dplyr::starts_with("dt_"),
        ~lubridate::ymd_hms(.x)
      )
    ) |> 
    tidyr::fill(dplyr::contains("assunto"), .direction="down") |> 
    dplyr::mutate(
      dplyr::across(
        dplyr::contains("assunto"),
        ~tidyr::replace_na(.x, "-")
      )
    )   
}
