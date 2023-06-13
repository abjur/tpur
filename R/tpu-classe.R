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
  # pega todos os classes de nível 2 a 6
  html <- xml2::read_html(file) |>
    xml2::xml_find_first("//table") |> 
    xml2::xml_find_all(".//tr[contains(@style, 'background-color')]") 
  
  da_sem_classe1 <- purrr::map(html, function(html) {
    tibble::tibble(
      classe1 = NA_character_,
      classe2 = html |> 
        xml2::xml_find_all("./td[1]") |>
        xml2::xml_text(trim=TRUE),
      classe3 = html |> 
        xml2::xml_find_all("./td[2]") |>
        xml2::xml_text(trim=TRUE),
      classe4 = html |> 
        xml2::xml_find_all("./td[3]") |>
        xml2::xml_text(trim=TRUE),
      classe5 = html |> 
        xml2::xml_find_all("./td[4]") |>
        xml2::xml_text(trim=TRUE),
      classe6 = html |> 
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
      sigla = html |> 
        xml2::xml_find_all("./td[10]") |>
        xml2::xml_text(trim=TRUE),
      alteracoes = html |> 
        xml2::xml_find_all("./td[11]") |>
        xml2::xml_text(trim=TRUE),
      glossario = html |> 
        xml2::xml_find_all("./td[12]") |>
        xml2::xml_text(trim=TRUE),
      dt_publicacao = html |> 
        xml2::xml_find_all("./td[13]") |>
        xml2::xml_text(trim=TRUE),
      dt_alteracao = html |> 
        xml2::xml_find_all("./td[14]") |>
        xml2::xml_text(trim=TRUE),
      dt_inativacao = html |> 
        xml2::xml_find_all("./td[15]") |>
        xml2::xml_text(trim=TRUE),
      dt_reativacao = html |> 
        xml2::xml_find_all("./td[16]") |>
        xml2::xml_text(trim=TRUE)
    ) 
  }) |> 
    dplyr::bind_rows() |> 
    dplyr::mutate(id = dplyr::row_number()*2)
  
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
    )   
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
