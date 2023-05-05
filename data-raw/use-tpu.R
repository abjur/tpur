# use tpu

# atual -------------------------------------------------------------------

# assunto -----------------------------------------------------------------

# download
sgt_atual |> 
  dplyr::filter(tipo == "Assuntos") |> 
  head(1) |>
  dplyr::pull(sigla) |> 
  purrr::map(tpu_assunto_download)

# parse

path <- "data-raw/tpu/A"
file <- fs::dir_ls(path) 

tpu_assunto <- fs::dir_ls(path) |> 
  purrr::map_dfr(tpu_assunto_parse) |> 
  tpu_assunto_tidy()

# classe ------------------------------------------------------------------

# download
sgt_atual |> 
  dplyr::filter(tipo == "Classes") |> 
  # head(1) |>
  dplyr::pull(sigla) |> 
  purrr::map(tpu_classe_download)

# parse

path <- "data-raw/tpu/C"
file <- fs::dir_ls(path) 

tpu_classe <- fs::dir_ls(path) |> 
  purrr::map_dfr(tpu_classe_parse) |> 
  tpu_classe_tidy()

