# use tpu

# download -----------------------------------------------------------------

datas[56] <- unique(sgt$data_versao)


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
cria_csv <- function(da, path_csv){
  fs::dir_create(path_csv)
  id <- da |> 
    dplyr::distinct(id) |> 
    dplyr::pull()
  path_file <- paste0(path_csv, "/", id, ".csv")
  readr::write_csv(da, path_file)
}

# assuntos_parse ----------------------------------------------------------
# preparação
list_a <- fs::dir_ls("data-raw/tpu/A")
path_csv_a <- "data-raw/csv/A"

# cria csv 
for(path_versao in rev(list_a)) {
  
  versao <- path_versao |> 
    stringr::str_extract("[0-9]+")
  
  fs::dir_ls(path_versao) |>
    purrr::map_dfr(tpu_assunto_parse) |>
    tpu_assunto_tidy() |> 
    dplyr::distinct() |>
    dplyr::mutate(
      id = glue::glue("A_{versao}")
    ) |> 
    dplyr::select(id, dplyr::everything()) |> 
    cria_csv(path_csv = path_csv_a) 
}

# coloca csv no releases
fs::dir_ls(path_csv_a) |> 
  purrr::walk(piggyback::pb_upload, tag = "assuntos", overwrite = TRUE)

# classes_parse -----------------------------------------------------------
# preparação
list_c <- fs::dir_ls("data-raw/tpu/C")
path_csv_c <- "data-raw/csv/C"

# cria csv
for(path_versao in rev(list_c)) {

  versao <- path_versao |> 
    stringr::str_extract("[0-9]+")
  
  fs::dir_ls(path_versao) |> 
    purrr::map_dfr(tpu_classe_parse) |> 
    tpu_classe_tidy() |> 
    dplyr::distinct() |> 
    dplyr::mutate(
      id = glue::glue("C_{versao}")
    ) |> 
    dplyr::select(id, dplyr::everything()) |> 
    cria_csv(path_csv = path_csv_c)
}

# coloca csv no releases
fs::dir_ls(path_c_csv) |> 
  purrr::walk(piggyback::pb_upload, tag = "classes", overwrite = TRUE)

# readme ------------------------------------------------------------------

# assuntos_readme ---------------------------------------------------------
path_a_csv <- "data-raw/csv/A"

# faz a tabela resumindo todos os releases
assuntos <- tibble::tibble(
  file = basename(fs::dir_ls(path_a_csv)),
  release = piggyback::pb_download_url(file = file, tag = "assuntos")
) |> 
  dplyr::mutate(
    dt_ini = stringr::str_extract_all(file, "[0-9]+"),
    dt_ini = lubridate::ymd(dt_ini)
  ) |> 
  dplyr::arrange(desc(dt_ini)) |> 
  dplyr::mutate(
    dt_fim = dplyr::lag(dt_ini) - lubridate::day(1),
    dt_fim = tidyr::replace_na(dt_fim, lubridate::today())
  ) |> 
  dplyr::select(file, dt_ini, dt_fim, release)

readr::write_csv(assuntos, "inst/extdata/assuntos.csv", show_col_types = FALSE)
usethis::use_data(assuntos)
# classes_readme ----------------------------------------------------------
path_c_csv <- "data-raw/csv/C"

# faz a tabela resumindo todos os releases
classes <- tibble::tibble(
  file = basename(fs::dir_ls(path_c_csv)),
  release = piggyback::pb_download_url(file, tag = "classes")
) |> 
  dplyr::mutate(
    dt_ini = stringr::str_extract_all(file, "[0-9]+"),
    dt_ini = lubridate::ymd(dt_ini)
  ) |> 
  dplyr::arrange(desc(dt_ini)) |> 
  dplyr::mutate(
    dt_fim = dplyr::lag(dt_ini) - lubridate::day(1),
    dt_fim = tidyr::replace_na(dt_fim, lubridate::today())
  ) |> 
  dplyr::select(file, dt_ini, dt_fim, release)

readr::write_csv(classes, "inst/extdata/classes.csv", show_col_types = FALSE)
usethis::use_data(classes)
