# download ----------------------------------------------------------------

tipos <- c("A", "C", "M") 

tipos |> 
  purrr::map(sgt_download, atual = FALSE)

# parse -------------------------------------------------------------------

sgt <- fs::dir_ls("data-raw/sgt/") |> 
  purrr::map_dfr(sgt_parse) |> 
  sgt_tidy()

usethis::use_data(sgt, overwrite = TRUE)
