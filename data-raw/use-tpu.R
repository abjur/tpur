# use tpu

# assuntos -----------------------------------------------------------------

# download
sgt_atual |> 
  dplyr::filter(
    tipo == "Assuntos"
    # justica == "Justiça Estadual",
    # tabela == "Estadual 1° Grau"
  ) |> 
  # head(1) |>
  dplyr::pull(sigla) |>
  purrr::map(tpu_assunto_download)

# parse

path <- "data-raw/tpu/A"
file <- fs::dir_ls(path)

tpu_assunto <- fs::dir_ls(path) |> 
  purrr::map_dfr(tpu_assunto_parse, .id = "file") |> 
  tpu_assunto_tidy()

# criar releases (rodar só uma vez)

# piggyback::pb_new_release(tag = "assuntos")

# classe ------------------------------------------------------------------

# download
sgt_atual |> 
  dplyr::filter(tipo == "Classes") |> 
  # head(1) |>
  dplyr::pull(sigla) |> 
  purrr::map(tpu_classe_download)

# parse

path <- "data-raw/tpu/C"
file <- fs::dir_ls(path)[1]

file |> 
  stringr::str_remove(glue::glue("{path}/C_")) |> 
  stringr::str_remove("\\.html") |> 
  stringr::str_to_lower() |> 
  stringr::str_split("_")

path_csv <- "data-raw/csv/C/"

fs::dir_ls(path) |> 
  purrr::map(tpu_classe_parse) |> 
  purrr::map(tpu_classe_tidy) |> 
  purrr::iwalk(function(dados, nome_arquivo){
    path_file <- paste0(path_csv, fs::path_ext_set(basename(nome_arquivo), ".csv"))
    readr::write_csv(dados, path_file)
    }
  )

fs::dir_ls(path_csv) |> 
  purrr::walk(piggyback::pb_upload, tag = "classes", overwrite = TRUE)


# criar releases (rodar só uma vez)

# piggyback::pb_new_release(tag = "classes")
