# use tpu

# download -----------------------------------------------------------------

datas <- unique(sgt$data_versao)

# assuntos_download -------------------------------------------------------

for(data in datas) {
  sgt |> 
    dplyr::filter(
      tipo == "Assuntos",
      data_versao == data
    ) |> 
    dplyr::pull(id) |> 
    purrr::map(tpu_assunto_download)
}

# classes_download -------------------------------------------------------

for(data in datas) {
  sgt |> 
    dplyr::filter(
      tipo == "Classes",
      data_versao == data
    ) |> 
    dplyr::pull(id) |> 
    purrr::map(tpu_classe_download)
}

# parse -------------------------------------------------------------------
cria_csv <- function(dados, nome_arquivo){
  path_file <- paste0(path_csv, "/", fs::path_ext_set(basename(nome_arquivo), ".csv"))
  readr::write_csv(dados, path_file)
}


# assuntos_parse ----------------------------------------------------------
# preparação
path_a <- fs::dir_ls("data-raw/tpu/A")
path_a_csv <- "data-raw/csv/A"

# cria csv 
for(path_versao in rev(path_a)) {
  
  versao <- path_versao |> 
    stringr::str_extract("[0-9]+")
  
  path_csv <- path_a_csv
  
  fs::dir_ls(path_versao) |>
    purrr::map_dfr(tpu_assunto_parse) |>
    tpu_assunto_tidy() |>
    dplyr::distinct() |>
    dplyr::mutate(
      id = glue::glue("A_{versao}")
    ) |> 
    dplyr::select(id, dplyr::everything()) |> 
    cria_csv(glue::glue("{path_a_csv}/A_{versao}.csv"))
}

# coloca csv no releases
fs::dir_ls(path_a_csv) |> 
  purrr::walk(piggyback::pb_upload, tag = "assuntos", overwrite = TRUE)

# faz a tabela resumindo todos os releases
assuntos <- tibble::tibble(
    file = basename(fs::dir_ls(path_a_csv))
  ) |> 
  dplyr::mutate(
    dt_ini = stringr::str_extract_all(file, "[0-9]+"),
    dt_ini = lubridate::ymd(dt_ini)
  ) |> 
  dplyr::arrange(desc(dt_ini)) |> 
  dplyr::mutate(
    dt_fim = dplyr::lag(dt_ini) - lubridate::day(1),
    dt_fim = tidyr::replace_na(dt_fim, lubridate::today()),
    periodo_validade = lubridate::interval(start = dt_ini, end = dt_fim),
    release = piggyback::pb_download_url(file, tag = "assuntos")
  )

readr::write_csv(assuntos, "inst/extdata/assuntos.csv")

# classes_parse -----------------------------------------------------------
# preparação
path_c <- fs::dir_ls("data-raw/tpu/C")
path_c_csv <- "data-raw/csv/C"

# cria csv
for(path_versao in rev(path_c)) {

  versao <- path_versao |> 
    stringr::str_extract("[0-9]+")
  
  path_csv <- path_c_csv
  
  fs::dir_ls(path_versao) |> 
    purrr::map_dfr(tpu_classe_parse) |> 
    tpu_classe_tidy() |> 
    dplyr::distinct() |> 
    dplyr::mutate(
      id = glue::glue("C_{versao}")
    ) |> 
    dplyr::select(id, dplyr::everything()) |> 
    cria_csv(glue::glue("{path_c_csv}/C_{versao}.csv"))
}

# coloca csv no releases
fs::dir_ls(path_c_csv) |> 
  purrr::walk(piggyback::pb_upload, tag = "classes", overwrite = TRUE)

# faz a tabela resumindo todos os releases
classes <- tibble::tibble(
  file = basename(fs::dir_ls(path_c_csv))
) |> 
  dplyr::mutate(
    dt_ini = stringr::str_extract_all(file, "[0-9]+"),
    dt_ini = lubridate::ymd(dt_ini)
  ) |> 
  dplyr::arrange(desc(dt_ini)) |> 
  dplyr::mutate(
    dt_fim = dplyr::lag(dt_ini) - lubridate::day(1),
    dt_fim = tidyr::replace_na(dt_fim, lubridate::today()),
    periodo_validade = lubridate::interval(start = dt_ini, end = dt_fim),
    release = piggyback::pb_download_url(file, tag = "classes")
  )

readr::write_csv(classes, "inst/extdata/classes.csv")
