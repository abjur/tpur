# use tpu-a

# download -----------------------------------------------------------------

dt_ja_tem <- tpur::classes |> 
  dplyr::distinct(dt_ini) |> 
  dplyr::pull()

datas <- sgt |> 
  tibble::as_tibble() |> 
  dplyr::filter(!data_versao %in% dt_ja_tem) |> 
  dplyr::distinct(data_versao) |> 
  dplyr::pull()

for(data in datas) {
  sgt |> 
    dplyr::filter(
      tipo == "Assuntos",
      data_versao == data
    ) |> 
    dplyr::pull(id) |> 
    purrr::map(tpur:::tpu_assunto_download)
}

# verificação
list <- fs::dir_ls("data-raw/tpu/A")

erros <- tibble::tibble()
for(versao in rev(list)) {
  file <- fs::dir_ls(versao)[1]
  
  erro1 <- file.info(file) |> 
    dplyr::pull(size) < 1000
  
  erro2 <- xml2::read_html(file) |>
    xml2::xml_find_first("//table") |> 
    xml2::xml_find_all("./tr[contains(@style, 'background-color')]") |> 
    length() == 0
  
  erros_versao <- tibble::tibble(
    versao = versao,
    erro1 = erro1,
    erro2 = erro2
  )
  
  erros <- erros |> 
    dplyr::bind_rows(erros_versao)
}

# erro1 = arquivo NOT FOUND, mas é o comportamento no próprio site das TPU
# erro2 = erro na importação, tem que melhorar a função de download()
erros |> 
  dplyr::filter(erro1) |> 
  dplyr::pull(versao) |> 
  purrr::map(fs::dir_delete)

# parse -------------------------------------------------------------------

# preparação
list <- fs::dir_ls("data-raw/tpu/A")
path_csv <- "data-raw/csv/A"

# cria csv 
for(path_versao in rev(list)) {
  
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
    cria_csv(path_csv = path_csv) 
}

# coloca csv no releases
fs::dir_ls(path_csv) |> 
  purrr::walk(piggyback::pb_upload, tag = "assuntos", overwrite = TRUE)


# readme ------------------------------------------------------------------
path_csv <- "data-raw/csv/A"

# faz a tabela resumindo todos os releases
assuntos <- tibble::tibble(
  file = basename(fs::dir_ls(path_csv)),
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

readr::write_csv(assuntos, "inst/extdata/assuntos.csv")
usethis::use_data(assuntos, overwrite = TRUE)
