# use tpu

# download -----------------------------------------------------------------

datas <- unique(sgt$data_versao)

# assuntos
for(data in datas) {
  sgt |> 
    dplyr::filter(
      # atual,
      tipo == "Assuntos",
      data_versao == data
    ) |> 
    dplyr::pull(id) |> 
    purrr::map(tpu_assunto_download)
}

# classes
for(data in datas) {
  sgt |> 
    dplyr::filter(
      # atual,
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

# assuntos
path_a <- fs::dir_ls("data-raw/tpu/A")
path_a_csv <- "data-raw/csv/A"

for(path_versao in path_a) {
  
  versao <- path_versao |> 
    stringr::str_extract("[0-9]+")
  
  path_csv <- path_a_csv
  
  fs::dir_ls(path_versao) |>
    purrr::map_dfr(tpu_assunto_parse) |>
    tpu_assunto_tidy() |>
    dplyr::distinct() |>
    cria_csv(glue::glue("{path_a_csv}/A_{versao}.csv"))
}

fs::dir_ls(path_a_csv) |> 
  purrr::walk(piggyback::pb_upload, tag = "assuntos", overwrite = TRUE)

# classes
path_c <- fs::dir_ls("data-raw/tpu/C")
path_c_csv <- "data-raw/csv/C"


for(path_versao in rev(path_c)) {
  # print(path_versao)

  versao <- path_versao |> 
    stringr::str_extract("[0-9]+")
  
  path_csv <- path_c_csv
  
  fs::dir_ls(path_versao) |> 
    purrr::map_dfr(tpu_classe_parse) |> 
    tpu_classe_tidy() |> 
    dplyr::distinct() |> 
    cria_csv(glue::glue("{path_c_csv}/A_{versao}.csv"))
}

fs::dir_ls(path_c_csv) |> 
  purrr::walk(piggyback::pb_upload, tag = "classes", overwrite = TRUE)

# criar releases (rodar só uma vez)

# piggyback::pb_new_release(tag = "classes")
