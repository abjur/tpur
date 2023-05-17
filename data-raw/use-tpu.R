# use tpu

# download -----------------------------------------------------------------

# assuntos
sgt |> 
  dplyr::filter(
    # atual,
    tipo == "Assuntos"
  ) |> 
  dplyr::pull(id) |> 
  purrr::map(tpu_assunto_download)

# classes

sgt |> 
  dplyr::filter(
    # atual,
    tipo == "Classes"
  ) |> 
  dplyr::pull(id) |> 
  purrr::map(tpu_classe_download)

# parse -------------------------------------------------------------------
cria_csv <- function(dados, nome_arquivo){
  path_file <- paste0(path_csv, "/", fs::path_ext_set(basename(nome_arquivo), ".csv"))
  readr::write_csv(dados, path_file)
}

# assuntos
path <- "data-raw/tpu/A"
path_csv <- "data-raw/csv/A"

fs::dir_ls(path) |> 
  purrr::map(tpu_assunto_parse) |> 
  purrr::map(tpu_assunto_tidy) |> 
  purrr::iwalk(cria_csv)

fs::dir_ls(path_csv) |> 
  purrr::walk(piggyback::pb_upload, tag = "classes", overwrite = TRUE)

# classes
path <- "data-raw/tpu/C"
path_csv <- "data-raw/csv/C"

fs::dir_ls(path) |> 
  purrr::map(tpu_classe_parse) |> 
  purrr::map(tpu_classe_tidy) |> 
  purrr::iwalk(cria_csv)

fs::dir_ls(path_csv) |> 
  purrr::walk(piggyback::pb_upload, tag = "classes", overwrite = TRUE)



# criar releases (rodar só uma vez)

# piggyback::pb_new_release(tag = "classes")
