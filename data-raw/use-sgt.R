# download ----------------------------------------------------------------

tipos <- c("A", "C", "M") 

path <- "data-raw/sgt"

fs::dir_create(path)

tipos |> 
  purrr::map(tpur:::sgt_download, atual = FALSE)

# parse -------------------------------------------------------------------

sgt <- fs::dir_ls(path) |> 
  purrr::map_dfr(tpur:::sgt_parse) |> 
  tpur:::sgt_tidy()

fs::dir_ls(path) |> 
  purrr::map(fs::file_delete)

usethis::use_data(sgt, overwrite = TRUE)
