# atual  -----------------------------------------------------------------
# download
tipos <- c("A", "C", "M") 

tipos |> 
  purrr::map(sgt_atual_download)

# parse
sgt_atual <- fs::dir_ls("data-raw/sgt_atual/") |> 
  purrr::map_dfr(sgt_atual_parse) |> 
  sgt_tidy()

usethis::use_data(sgt_atual, overwrite = TRUE)

# anterior -------------------------------------------------------------------
# download
tipos <- c("A", "C", "M")

tipos |> 
  purrr::map(sgt_anterior_download)

# parse
sgt_anterior <- fs::dir_ls("data-raw/sgt_anterior/") |> 
  purrr::map_dfr(sgt_anterior_parse) |> 
  sgt_tidy()

usethis::use_data(sgt_anterior, overwrite = TRUE)

# tidy --------------------------------------------------------------------
sgt_unificado <- sgt_atual |> 
  dplyr::bind_rows(sgt_anterior)

usethis::use_data(sgt_unificado, overwrite = TRUE)
