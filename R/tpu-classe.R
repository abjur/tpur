#' Baixar html classe TPU
#' 
#' Baixa um arquivo html na pasta indicada
#' 
#' @param sig Sigla que se deseja baixar. A lista de siglas está na base sgt. Esta função recebe apenas as siglas iniciadas com "C"
#' @param path Diretório em que o html será salvo
#' 
#' @return Retorna o path dos arquivos salvos
tpu_classe_download <- function(sig, path = "data-raw/tpu/C") {
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
  
  file
}

#' Parse html classe TPU
#' 
#' Realiza o parse do html de um arquivo de classe das TPUs
#' 
#' @param file Recebe o path de um arquivo html
#' 
#' @return Retorna um data frame, com 17 colunas
tpu_classe_parse <- function(file) {
  # pega todos as classes de nível 2 a 6
  html <- xml2::read_html(file) |>
    xml2::xml_find_first("//table") |> 
    xml2::xml_find_all("./tr[contains(@style, 'background-color')]") 
  
  sem_dts <- html |> 
    xml2::xml_find_all("./td[14]") |>
    xml2::xml_text(trim=TRUE) |> 
    length() == 0
  
  if(sem_dts) {
    da_sem_classe1 <- tibble::tibble(
      classe1 = NA_character_,
      classe2 = html |> 
        xml2::xml_find_first("./td[1]") |>
        xml2::xml_text(trim=TRUE),
      classe3 = html |> 
        xml2::xml_find_first("./td[2]") |>
        xml2::xml_text(trim=TRUE),
      classe4 = html |> 
        xml2::xml_find_first("./td[3]") |>
        xml2::xml_text(trim=TRUE),
      classe5 = html |> 
        xml2::xml_find_first("./td[4]") |>
        xml2::xml_text(trim=TRUE),
      classe6 = html |> 
        xml2::xml_find_first("./td[5]") |>
        xml2::xml_text(trim=TRUE),
      codigo = html |> 
        xml2::xml_find_first("./td[6]") |>
        xml2::xml_text(trim=TRUE),
      codigo_pai = html |> 
        xml2::xml_find_first("./td[7]") |>
        xml2::xml_text(trim=TRUE),
      dispositivo_legal = html |> 
        xml2::xml_find_first("./td[8]") |>
        xml2::xml_text(trim=TRUE),
      artigo = html |> 
        xml2::xml_find_first("./td[9]") |>
        xml2::xml_text(trim=TRUE),
      sigla = html |> 
        xml2::xml_find_first("./td[10]") |>
        xml2::xml_text(trim=TRUE),
      alteracoes = html |> 
        xml2::xml_find_first("./td[11]") |>
        xml2::xml_text(trim=TRUE),
      glossario = html |> 
        xml2::xml_find_first("./td[12]") |>
        xml2::xml_text(trim=TRUE)
    ) |> 
      dplyr::bind_rows() |> 
      dplyr::mutate(id = dplyr::row_number()*2)
  } else {
    da_sem_classe1 <- tibble::tibble(
        classe1 = NA_character_,
        classe2 = html |> 
          xml2::xml_find_first("./td[1]") |>
          xml2::xml_text(trim=TRUE),
        classe3 = html |> 
          xml2::xml_find_first("./td[2]") |>
          xml2::xml_text(trim=TRUE),
        classe4 = html |> 
          xml2::xml_find_first("./td[3]") |>
          xml2::xml_text(trim=TRUE),
        classe5 = html |> 
          xml2::xml_find_first("./td[4]") |>
          xml2::xml_text(trim=TRUE),
        classe6 = html |> 
          xml2::xml_find_first("./td[5]") |>
          xml2::xml_text(trim=TRUE),
        codigo = html |> 
          xml2::xml_find_first("./td[6]") |>
          xml2::xml_text(trim=TRUE),
        codigo_pai = html |> 
          xml2::xml_find_first("./td[7]") |>
          xml2::xml_text(trim=TRUE),
        dispositivo_legal = html |> 
          xml2::xml_find_first("./td[8]") |>
          xml2::xml_text(trim=TRUE),
        artigo = html |> 
          xml2::xml_find_first("./td[9]") |>
          xml2::xml_text(trim=TRUE),
        sigla = html |> 
          xml2::xml_find_first("./td[10]") |>
          xml2::xml_text(trim=TRUE),
        alteracoes = html |> 
          xml2::xml_find_first("./td[11]") |>
          xml2::xml_text(trim=TRUE),
        glossario = html |> 
          xml2::xml_find_first("./td[12]") |>
          xml2::xml_text(trim=TRUE),
        dt_publicacao = html |> 
          xml2::xml_find_first("./td[13]") |>
          xml2::xml_text(trim=TRUE),
        dt_alteracao = html |> 
          xml2::xml_find_first("./td[14]") |>
          xml2::xml_text(trim=TRUE),
        dt_inativacao = html |> 
          xml2::xml_find_first("./td[15]") |>
          xml2::xml_text(trim=TRUE),
        dt_reativacao = html |> 
          xml2::xml_find_first("./td[16]") |>
          xml2::xml_text(trim=TRUE)
      ) |> 
      dplyr::bind_rows() |> 
      dplyr::mutate(id = dplyr::row_number()*2)
  }
  
  # pega todos classes de nível 1
  classe1_sem_id <- tibble::tibble(
    txt = xml2::read_html(file) |>
      xml2::xml_find_first("//table") |> 
      xml2::xml_find_all("./td[contains(@style, 'background-color:#4c83c8')]") |> 
      xml2::xml_text(trim=TRUE) 
  ) |> 
    dplyr::mutate(
      txt = ifelse(txt == "", NA_character_, txt),
      classe1 = !stringr::str_detect(txt, "[a-z]|[0-9]")
    )
  
  n_id <- classe1_sem_id |> 
    dplyr::count(classe1) |> 
    dplyr::filter(classe1) |>  
    dplyr::pull(n)
  
  n_col <- da_sem_classe1 |> 
    dplyr::select(!dplyr::contains("classe")) |> 
    ncol()
  
  classe1_ids <- classe1_sem_id |> 
    dplyr::filter(classe1) |> 
    dplyr::mutate(
      id = ifelse(classe1, 1:n_id, NA_integer_)
    ) 

  if(sem_dts) {
    da_classe1 <- classe1_sem_id |> 
      dplyr::left_join(classe1_ids) |> 
      tidyr::fill(id, .direction="down") |> 
      dplyr::group_by(id) |> 
      dplyr::mutate(
        colname = 1:n_col,
        colname = dplyr::case_when(
          colname == 1 ~ "classe1",
          colname == 2 ~ "codigo",
          colname == 3 ~ "codigo_pai",
          colname == 4 ~ "dispositivo_legal",
          colname == 5 ~ "artigo",
          colname == 6 ~ "sigla",
          colname == 7 ~ "alteracoes",
          colname == 8 ~ "glossario",
          colname == 9 ~ "dt_publicacao",
          colname == 10 ~ "dt_alteracao",
          colname == 11 ~ "dt_inativacao",
          colname == 12 ~ "dt_reativacao"
        )
      ) |> 
      dplyr::ungroup() |> 
      dplyr::select(txt, id, colname) |> 
      tidyr::pivot_wider(values_from = txt, names_from = colname) |> 
      dplyr::transmute(
        classe1,
        classe2 = "",
        classe3 = "",
        classe4 = "",
        classe5 = "",
        classe6 = "",
        codigo,
        codigo_pai,
        dispositivo_legal,
        artigo,
        sigla,
        alteracoes,
        glossario,
        dt_publicacao = NA_character_,
        dt_alteracao = NA_character_,
        dt_inativacao = NA_character_,
        dt_reativacao = NA_character_
      )
  } else {
    da_classe1 <- classe1_sem_id |> 
      dplyr::left_join(classe1_ids) |> 
      tidyr::fill(id, .direction="down") |> 
      dplyr::group_by(id) |> 
      dplyr::mutate(
        colname = 1:n_col,
        colname = dplyr::case_when(
          colname == 1 ~ "classe1",
          colname == 2 ~ "codigo",
          colname == 3 ~ "codigo_pai",
          colname == 4 ~ "dispositivo_legal",
          colname == 5 ~ "artigo",
          colname == 6 ~ "sigla",
          colname == 7 ~ "alteracoes",
          colname == 8 ~ "glossario",
          colname == 9 ~ "dt_publicacao",
          colname == 10 ~ "dt_alteracao",
          colname == 11 ~ "dt_inativacao",
          colname == 12 ~ "dt_reativacao"
        )
      ) |> 
      dplyr::ungroup() |> 
      dplyr::select(txt, id, colname) |> 
      tidyr::pivot_wider(values_from = txt, names_from = colname) |> 
      dplyr::transmute(
        classe1,
        classe2 = "",
        classe3 = "",
        classe4 = "",
        classe5 = "",
        classe6 = "",
        codigo,
        codigo_pai,
        dispositivo_legal,
        artigo,
        sigla,
        alteracoes,
        glossario,
        dt_publicacao,
        dt_alteracao,
        dt_inativacao,
        dt_reativacao
      )
  }

  # insere os classes de nivel 1 junto dos demais classes
  da <- da_sem_classe1
  for(cod in da_classe1$codigo) {
    posicao_classe1 <- da |> 
      dplyr::mutate(
        classe1_acima = codigo_pai == cod
      ) |> 
      dplyr::filter(classe1_acima) |> 
      dplyr::pull(id) |> 
      min() - 1L
    
    row <- da_classe1 |> 
      dplyr::filter(codigo == cod) |> 
      dplyr::mutate(id = posicao_classe1)
    
    da <- da |> 
      dplyr::bind_rows(row) |>
      dplyr::arrange(id) 
  }
  da <- da |> dplyr::select(-id)
  return(da)
}

#' Arruma uma base de classes
#' 
#' Realiza a arrumação de uma base de dados contendo as classes de uma TPU 
#' 
#' @param da Recebe um data frame 
#' 
#' @return Retorna um data frame arrumado, com 17 colunas
tpu_classe_tidy <- function(da) {
  
  da <- dplyr::mutate(da, id = dplyr::row_number()*2)
  
  if(any(!stringr::str_detect(da$codigo, "[0-9]"))) {
    id_colunas_ruins <- da |> 
      dplyr::filter(!stringr::str_detect(codigo, "[0-9]")) |> 
      dplyr::arrange(id) |> 
      dplyr::pull(id)
    
    colunas_ruins <- da |> 
      dplyr::filter(!stringr::str_detect(codigo, "[0-9]")) |> 
      dplyr::arrange(id) |> 
      dplyr::select(-id)
    
    colunas_ruins$id <- ""
    names(colunas_ruins)[1:ncol(colunas_ruins)] <- c("id", names(colunas_ruins)[1:ncol(colunas_ruins) - 1])
    colunas_ruins$id <- id_colunas_ruins
    colunas_ruins$classe1 <- NA_character_
    
    da <- da |> 
      dplyr::filter(stringr::str_detect(codigo, "[0-9]")) |> 
      dplyr::bind_rows(colunas_ruins) |> 
      dplyr::arrange(id) 
  }
  
  da |> 
    dplyr::mutate(
      dplyr::across(
        dplyr::everything(),
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
    tidyr::fill(dplyr::starts_with("classe")) |> 
    dplyr::mutate(
      classe2 = ifelse(classe1 == dplyr::lag(classe1), classe2, NA),
      classe3 = ifelse(classe2 == dplyr::lag(classe2), classe3, NA),
      classe4 = ifelse(classe3 == dplyr::lag(classe3), classe4, NA),
      classe5 = ifelse(classe4 == dplyr::lag(classe4), classe5, NA),
      classe6 = ifelse(classe5 == dplyr::lag(classe5), classe6, NA)
    ) |> 
    dplyr::mutate(
      dplyr::across(
        dplyr::contains("classe"),
        ~tidyr::replace_na(.x, "-")
      )
    ) |> 
    dplyr::select(-id)
}

#' Ler classes da TPU
#' 
#' Retorna os códigos de classes das TPUs por período
#' 
#' @param busca Palavra a ser buscada nas classes
#' @param ini Data de início, por default o dia de hoje
#' @param fim Data de fim, por default o dia de hoje
#' 
#' @return Retorna tibble com 5 colunas:
#' 
#' @examples tpu_classe_read("execução", ini = "2023-01-01", fim = "2023-02-01")
#'
#' @export
tpu_classe_read <- function(busca = NULL,  ini = Sys.Date(), fim = Sys.Date()) {
  classes <- readr::read_csv(system.file("extdata/classes.csv", package = "tpur"), show_col_types = FALSE)
  
  # baixar as TPUs corretas
  if(!lubridate::is.Date(ini)) {
    ini <- as.Date(ini)
  }
  if(!lubridate::is.Date(fim)) {
    fim <- as.Date(fim)
  }
  
  periodo <- lubridate::interval(ini, fim)
  
  files <- classes |> 
    dplyr::mutate(
      periodo_validade = lubridate::interval(dt_ini, dt_fim),
      pegar = lubridate::int_overlaps(periodo, periodo_validade)
    ) |> 
    dplyr::filter(pegar) |> 
    dplyr::pull(release)
 
  da <- readr::read_csv(files, show_col_types = FALSE)
  
  # selecionar os códigos
  busca <- busca |> 
    abjutils::rm_accent() |> 
    stringr::str_to_lower()
  
  da |> 
    dplyr::mutate(
      classe = dplyr::case_when(
        classe6 != "-" ~ classe6,
        classe5 != "-" ~ classe5,
        classe4 != "-" ~ classe4,
        classe3 != "-" ~ classe3,
        classe2 != "-" ~ classe2,
        classe1 != "-" ~ classe1
      ),
      classe_tidy = abjutils::rm_accent(classe),
      classe_tidy = stringr::str_to_lower(classe_tidy),
      pegar = stringr::str_detect(classe_tidy, busca)
    ) |> 
    dplyr::filter(pegar) |> 
    dplyr::mutate(file = glue::glue("{id}.csv")) |> 
    dplyr::left_join(classes) |> 
    dplyr::mutate(
      dt_ini = format(dt_ini, "%d/%m/%Y"),
      dt_fim = format(dt_fim, "%d/%m/%Y")
    ) |> 
    dplyr::transmute(
      id,
      tpu_periodo_validade = glue::glue("de {dt_ini} a {dt_fim}"),
      codigo, 
      classe
    ) |> 
    dplyr::distinct(codigo, .keep_all = TRUE)
}

#' Ler classes da TPU (busca em qualquer nível)
#' 
#' Retorna os códigos de classes das TPUs por período, filtrando a palavra em qualquer nível (classe1 a classe6)
#' 
#' @param busca Palavra a ser buscada nas classes (ignora acentos e maiúsculas)
#' @param ini Data de início do período
#' @param fim Data de fim do período
#' 
#' @return Tibble com colunas: id, período de validade, código e classe mais específica
#' @export
tpu_classe_read_any <- function(busca = NULL, ini = Sys.Date(), fim = Sys.Date()) {
  classes <- readr::read_csv(system.file("extdata/classes.csv", package = "tpur"), show_col_types = FALSE)
  
  # tratar datas
  if (!lubridate::is.Date(ini)) ini <- as.Date(ini)
  if (!lubridate::is.Date(fim)) fim <- as.Date(fim)
  
  # identificar arquivos válidos no período
  periodo <- lubridate::interval(ini, fim)
  
  files <- classes |>
    dplyr::mutate(
      periodo_validade = lubridate::interval(dt_ini, dt_fim),
      pegar = lubridate::int_overlaps(periodo, periodo_validade)
    ) |>
    dplyr::filter(pegar) |>
    dplyr::pull(release)
  
  da <- readr::read_csv(files, show_col_types = FALSE)
  
  # definir a classe mais específica encontrada (como na original)
  da <- da |> dplyr::mutate(
    especlasse = dplyr::case_when(
      classe6 != "-" ~ classe6,
      classe5 != "-" ~ classe5,
      classe4 != "-" ~ classe4,
      classe3 != "-" ~ classe3,
      classe2 != "-" ~ classe2,
      classe1 != "-" ~ classe1
    )
  )
  
  # normalizar palavra de busca
  busca <- abjutils::rm_accent(busca) |> stringr::str_to_lower()
  
  # aplicar busca em todas as colunas de classe
  da <- da |> dplyr::mutate(across(starts_with("classe"), ~stringr::str_to_lower(abjutils::rm_accent(.x))))
  
  da <- da |> dplyr::mutate(pegar = classe1 %>% stringr::str_detect(busca) |
                              classe2 %>% stringr::str_detect(busca) |
                              classe3 %>% stringr::str_detect(busca) |
                              classe4 %>% stringr::str_detect(busca) |
                              classe5 %>% stringr::str_detect(busca) |
                              classe6 %>% stringr::str_detect(busca)) |>
    dplyr::filter(pegar)

  
  da |> 
    dplyr::mutate(file = glue::glue("{id}.csv")) |> 
    dplyr::left_join(classes, by = "file") |> 
    dplyr::mutate(
      dt_ini = format(dt_ini, "%d/%m/%Y"),
      dt_fim = format(dt_fim, "%d/%m/%Y")
    ) |> 
    dplyr::transmute(
      id,
      tpu_periodo_validade = glue::glue("de {dt_ini} a {dt_fim}"),
      codigo,
      especlasse
    ) |> 
    dplyr::distinct(codigo, .keep_all = TRUE)
}

#' Ler classes da TPU
#' 
#' Retorna os códigos da classe origem mais antiga da TPU
#' 
#' @param ini Data de início, por default o dia de hoje
#' @param fim Data de fim, por default o dia de hoje
#' 
#' @return Retorna tibble com 5 colunas:
#' 
#' @examples tpu_classe_read("execução", ini = "2023-01-01", fim = "2023-02-01")
#'
#' @export
tpu_classe_1_busca_codigo <- function(buscacodigo = NULL,  ini = Sys.Date(), fim = Sys.Date()) {
  classes <- readr::read_csv(system.file("extdata/classes.csv", package = "tpur"), show_col_types = FALSE)
  
  # baixar as TPUs corretas
  if(!lubridate::is.Date(ini)) {
    ini <- as.Date(ini)
  }
  if(!lubridate::is.Date(fim)) {
    fim <- as.Date(fim)
  }
  
  periodo <- lubridate::interval(ini, fim)
  
  files <- classes |> 
    dplyr::mutate(
      periodo_validade = lubridate::interval(dt_ini, dt_fim),
      pegar = lubridate::int_overlaps(periodo, periodo_validade)
    ) |> 
    dplyr::filter(pegar) |> 
    dplyr::pull(release)
  
  da <- readr::read_csv(files, show_col_types = FALSE)
  
  buscacodigo = as.numeric(buscacodigo)
  
  da |> 
    dplyr::mutate(
      classe = dplyr::case_when(
        classe6 != "-" ~ classe6,
        classe5 != "-" ~ classe5,
        classe4 != "-" ~ classe4,
        classe3 != "-" ~ classe3,
        classe2 != "-" ~ classe2,
        classe1 != "-" ~ classe1
      )
      )|> 
    dplyr::filter(codigo == buscacodigo)  |> 
    dplyr::mutate(file = glue::glue("{id}.csv")) |> 
    dplyr::left_join(classes) |> 
    dplyr::mutate(
      dt_ini = format(dt_ini, "%d/%m/%Y"),
      dt_fim = format(dt_fim, "%d/%m/%Y")
    ) |> 
    dplyr::transmute(
      id,
      tpu_periodo_validade = glue::glue("de {dt_ini} a {dt_fim}"),
      codigo, 
      classe,
      classe1
    ) |> 
    dplyr::distinct(codigo, .keep_all = TRUE)
}

#' Ler classes da TPU
#' 
#' Retorna os códigos da classe origem mais antiga da TPU
#' 
#' @param ini Data de início, por default o dia de hoje
#' @param fim Data de fim, por default o dia de hoje
#' 
#' @return Retorna tibble com 5 colunas:
#' 
#' @examples tpu_classe_read("execução", ini = "2023-01-01", fim = "2023-02-01")
#'
#' @export
tpu_classe_1_busca <- function(busca = NULL,  ini = Sys.Date(), fim = Sys.Date()) {
  classes <- readr::read_csv(system.file("extdata/classes.csv", package = "tpur"), show_col_types = FALSE)
  
  # baixar as TPUs corretas
  if(!lubridate::is.Date(ini)) {
    ini <- as.Date(ini)
  }
  if(!lubridate::is.Date(fim)) {
    fim <- as.Date(fim)
  }
  
  periodo <- lubridate::interval(ini, fim)
  
  # selecionar os códigos
  busca <- busca |> 
    abjutils::rm_accent() |> 
    stringr::str_to_lower()
  
  files <- classes |> 
    dplyr::mutate(
      periodo_validade = lubridate::interval(dt_ini, dt_fim),
      pegar = lubridate::int_overlaps(periodo, periodo_validade)
    ) |> 
    dplyr::filter(pegar) |> 
    dplyr::pull(release)
  
  da <- readr::read_csv(files, show_col_types = FALSE)
  
  da |> 
    dplyr::mutate(
      classe = dplyr::case_when(
        classe6 != "-" ~ classe6,
        classe5 != "-" ~ classe5,
        classe4 != "-" ~ classe4,
        classe3 != "-" ~ classe3,
        classe2 != "-" ~ classe2,
        classe1 != "-" ~ classe1
      ),
      classe_tidy = abjutils::rm_accent(classe),
      classe_tidy = stringr::str_to_lower(classe_tidy),
      pegar = stringr::str_detect(classe_tidy, busca)
    )|> 
    dplyr::filter(pegar)  |> 
    dplyr::mutate(file = glue::glue("{id}.csv")) |> 
    dplyr::left_join(classes) |> 
    dplyr::mutate(
      dt_ini = format(dt_ini, "%d/%m/%Y"),
      dt_fim = format(dt_fim, "%d/%m/%Y")
    ) |> 
    dplyr::transmute(
      id,
      tpu_periodo_validade = glue::glue("de {dt_ini} a {dt_fim}"),
      codigo, 
      classe,
      classe1
    ) |> 
    dplyr::distinct(codigo, .keep_all = TRUE)
}

#' Ler classes da TPU
#' 
#' Retorna os códigos da classe origem mais antiga da TPU
#' 
#' @param ini Data de início, por default o dia de hoje
#' @param fim Data de fim, por default o dia de hoje
#' 
#' @return Retorna tibble com 5 colunas:
#' 
#' @examples tpu_classe_read("execução", ini = "2023-01-01", fim = "2023-02-01")
#'
#' @export
tpu_classe_all_busca <- function(busca = NULL,  ini = Sys.Date(), fim = Sys.Date()) {
  classes <- readr::read_csv(system.file("extdata/classes.csv", package = "tpur"), show_col_types = FALSE)
  
  # baixar as TPUs corretas
  if(!lubridate::is.Date(ini)) {
    ini <- as.Date(ini)
  }
  if(!lubridate::is.Date(fim)) {
    fim <- as.Date(fim)
  }
  
  periodo <- lubridate::interval(ini, fim)
  
  # selecionar os códigos
  busca <- busca |> 
    abjutils::rm_accent() |> 
    stringr::str_to_lower()
  
  files <- classes |> 
    dplyr::mutate(
      periodo_validade = lubridate::interval(dt_ini, dt_fim),
      pegar = lubridate::int_overlaps(periodo, periodo_validade)
    ) |> 
    dplyr::filter(pegar) |> 
    dplyr::pull(release)
  
  da <- readr::read_csv(files, show_col_types = FALSE)
  
  da |> 
    dplyr::mutate(
      classe = dplyr::case_when(
        classe6 != "-" ~ classe6,
        classe5 != "-" ~ classe5,
        classe4 != "-" ~ classe4,
        classe3 != "-" ~ classe3,
        classe2 != "-" ~ classe2,
        classe1 != "-" ~ classe1
      ),
      classe_tidy = abjutils::rm_accent(classe),
      classe_tidy = stringr::str_to_lower(classe_tidy),
      pegar = stringr::str_detect(classe_tidy, busca)
    )|> 
    dplyr::filter(pegar)  |> 
    dplyr::mutate(file = glue::glue("{id}.csv")) |> 
    dplyr::left_join(classes) |> 
    dplyr::mutate(
      dt_ini = format(dt_ini, "%d/%m/%Y"),
      dt_fim = format(dt_fim, "%d/%m/%Y")
    ) |> 
    dplyr::transmute(
      id,
      tpu_periodo_validade = glue::glue("de {dt_ini} a {dt_fim}"),
      codigo, 
      classe,
      classe1,
      classe2,
      classe3,
      classe4,
      classe5,
      classe6
    ) |> 
    dplyr::distinct(codigo, .keep_all = TRUE)
}

#' Busca vetorizada da classe1 da TPU a partir de nomes de classe
#'
#' @param busca Vetor de palavras (nomes de classe) a serem buscadas
#' @param ini Data inicial do período (default: hoje)
#' @param fim Data final do período (default: hoje)
#'
#' @return Tibble com colunas: classe, codigo, classe1, tpu_periodo_validade
#' @export
tpu_classe_1_busca_vetorizada <- function(busca = NULL, ini = Sys.Date(), fim = Sys.Date()) {
  
  classes <- readr::read_csv(system.file("extdata/classes.csv", package = "tpur"), show_col_types = FALSE)
  
  # tratar datas
  if (!lubridate::is.Date(ini)) ini <- as.Date(ini)
  if (!lubridate::is.Date(fim)) fim <- as.Date(fim)
  
  periodo <- lubridate::interval(ini, fim)
  
  # Arquivos válidos
  files <- classes |>
    dplyr::mutate(
      periodo_validade = lubridate::interval(dt_ini, dt_fim),
      pegar = lubridate::int_overlaps(periodo, periodo_validade)
    ) |>
    dplyr::filter(pegar) |>
    dplyr::pull(release)
  
  # Leitura das classes da TPU
  da <- readr::read_csv(files, show_col_types = FALSE)
  
  # Definir classe mais específica
  da <- da |> dplyr::mutate(
    classe = dplyr::case_when(
      classe6 != "-" ~ classe6,
      classe5 != "-" ~ classe5,
      classe4 != "-" ~ classe4,
      classe3 != "-" ~ classe3,
      classe2 != "-" ~ classe2,
      TRUE ~ classe1
    ),
    classe_tidy = stringr::str_to_lower(abjutils::rm_accent(classe))
  ) |> 
    dplyr::mutate(file = glue::glue("{id}.csv")) |> 
    dplyr::left_join(classes, by = "file") |> 
    dplyr::mutate(
      dt_ini = format(dt_ini, "%d/%m/%Y"),
      dt_fim = format(dt_fim, "%d/%m/%Y")
    )
  
  # Preparar vetor de busca normalizado
  busca_tidy <- busca |> abjutils::rm_accent() |> stringr::str_to_lower()
  
  # Para cada termo na busca, filtrar os dados e adicionar a coluna termo_busca
  resultados <- da %>%
    filter(classe_tidy %in% busca_tidy) |>
      dplyr::transmute(
        tpu_periodo_validade = glue::glue("de {dt_ini} a {dt_fim}"),
        codigo,
        classe,
        classe_tidy,
        classe1
      )|> 
    dplyr::distinct(codigo, .keep_all = TRUE)
  return(resultados)
}

tpu_classe_1_busca_vetorizada_codigo <- function(buscacodigo = NULL, ini = Sys.Date(), fim = Sys.Date()) {
  
  classes <- readr::read_csv(system.file("extdata/classes.csv", package = "tpur"), show_col_types = FALSE)
  
  # tratar datas
  if (!lubridate::is.Date(ini)) ini <- as.Date(ini)
  if (!lubridate::is.Date(fim)) fim <- as.Date(fim)
  
  periodo <- lubridate::interval(ini, fim)
  
  # Arquivos válidos
  files <- classes |>
    dplyr::mutate(
      periodo_validade = lubridate::interval(dt_ini, dt_fim),
      pegar = lubridate::int_overlaps(periodo, periodo_validade)
    ) |>
    dplyr::filter(pegar) |>
    dplyr::pull(release)
  
  # Leitura das classes da TPU
  da <- readr::read_csv(files, show_col_types = FALSE)
  
  # Definir classe mais específica
  da <- da |> dplyr::mutate(
    classe = dplyr::case_when(
      classe6 != "-" ~ classe6,
      classe5 != "-" ~ classe5,
      classe4 != "-" ~ classe4,
      classe3 != "-" ~ classe3,
      classe2 != "-" ~ classe2,
      TRUE ~ classe1
    ),
    classe_tidy = stringr::str_to_lower(abjutils::rm_accent(classe))
  ) |> 
    dplyr::mutate(file = glue::glue("{id}.csv")) |> 
    dplyr::left_join(classes, by = "file") |> 
    dplyr::mutate(
      dt_ini = format(dt_ini, "%d/%m/%Y"),
      dt_fim = format(dt_fim, "%d/%m/%Y")
    )
  

  # Para cada termo na busca, filtrar os dados e adicionar a coluna termo_busca
  resultados <- da |>
    dplyr::filter(codigo %in% buscacodigo)  |> 
    dplyr::transmute(
      tpu_periodo_validade = glue::glue("de {dt_ini} a {dt_fim}"),
      codigo,
      classe,
      classe_tidy,
      classe1
    )|> 
    dplyr::distinct(codigo, .keep_all = TRUE)
  return(resultados)
}
