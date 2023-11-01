# use tpu

# download -----------------------------------------------------------------

datas <- unique(sgt$data_versao)

for(data in datas[30:57]) {
  sgt |> 
    dplyr::filter(
      tipo == "Classes",
      data_versao == data
    ) |> 
    dplyr::pull(id) |> 
    purrr::map(tpu_classe_download)
  
  Sys.sleep(300)
}

# verificação
list <- fs::dir_ls("data-raw/tpu/C")

versao <- rev(list)[33]
versao <- rev(list)[1]
versao <- list[1]

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

# parse -----------------------------------------------------------
# preparação
list <- fs::dir_ls("data-raw/tpu/C")
path_csv <- "data-raw/csv/C"

# cria csv
for(path_versao in rev(list)) {
  
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
    cria_csv(path_csv = path_csv)
}

# coloca csv no releases
fs::dir_ls(path_csv) |> 
  purrr::walk(piggyback::pb_upload, tag = "classes", overwrite = TRUE)


# readme ----------------------------------------------------------
path_csv <- "data-raw/csv/C"

# faz a tabela resumindo todos os releases
classes <- tibble::tibble(
  file = basename(fs::dir_ls(path_csv)),
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

readr::write_csv(classes, "inst/extdata/classes.csv")
usethis::use_data(classes, overwrite = TRUE)
