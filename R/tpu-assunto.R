tpu_assunto_download <- function(sig, path = "data-raw/tpu/A") {
  load("data/sgt.rda")
  
  versao <- sig |> 
    stringr::str_extract("[0-9]{4}-[0-9]{2}-[0-9]{2}") |> 
    stringr::str_remove_all("-")
  
  u_tpu <- sgt |>
    dplyr::filter(id == sig) |> 
    dplyr::pull(link)
  
  fs::dir_create(glue::glue("{path}/{versao}"))
  
  file <- glue::glue("{path}/{versao}/{sig}.html")
  
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
    dplyr::filter(assunto1) |> 
    dplyr::mutate(
      id = ifelse(assunto1, 1:n_id, NA_integer_)
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
    tidyr::fill(dplyr::starts_with("assunto")) |> 
    dplyr::mutate(
      assunto2 = ifelse(assunto1 == dplyr::lag(assunto1), assunto2, NA),
      assunto3 = ifelse(assunto2 == dplyr::lag(assunto2), assunto3, NA),
      assunto4 = ifelse(assunto3 == dplyr::lag(assunto3), assunto4, NA),
      assunto5 = ifelse(assunto4 == dplyr::lag(assunto4), assunto5, NA),
      assunto6 = ifelse(assunto5 == dplyr::lag(assunto5), assunto6, NA)
    ) |> 
    dplyr::mutate(
      dplyr::across(
        dplyr::contains("assunto"),
        ~tidyr::replace_na(.x, "-")
      )
    )   
}

tpu_assunto_read <- function(busca = NULL, ini = lubridate::today(), fim = lubridate::today()) {
  assuntos <- readr::read_csv("inst/extdata/assuntos.csv")
  
  # baixar as TPUs corretas
  if(class(ini) != "date") {
    ini <- as.Date(ini)
  }
  if(class(fim) != "date") {
    fim <- as.Date(fim)
  }
  
  periodo <- lubridate::interval(ini, fim)
  
  files <- assuntos |> 
    dplyr::mutate(
      pegar = lubridate::int_overlaps(periodo, periodo_validade)
    ) |> 
    dplyr::filter(pegar) |> 
    dplyr::pull(release)
  
  da <- readr::read_csv(files)
  
  # selecionar os códigos
  busca <- busca |> 
    abjutils::rm_accent() |> 
    stringr::str_to_lower()
  
  da |> 
    dplyr::mutate(
      assunto = dplyr::case_when(
        assunto6 != "-" ~ assunto6,
        assunto5 != "-" ~ assunto5,
        assunto4 != "-" ~ assunto4,
        assunto3 != "-" ~ assunto3,
        assunto2 != "-" ~ assunto2,
        assunto1 != "-" ~ assunto1
      ),
      assunto = abjutils::rm_accent(assunto),
      assunto = stringr::str_to_lower(assunto),
      pegar = stringr::str_detect(assunto, busca)
    ) |> 
    dplyr::filter(pegar) |> 
    dplyr::pull(codigo)
}