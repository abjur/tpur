# use tpu


# atual -------------------------------------------------------------------

# download
sgt_atual |> 
  # head(1) |> 
  dplyr::pull(sigla) |> 
  purrr::map(tpu_download)

# parse

file <- fs::dir_ls("data-raw/tpu/") 

tpu <- fs::dir_ls("data-raw/tpu/") |> 
  purrr::map_dfr(tpu_parse) |> 
  tpu_tidy()
