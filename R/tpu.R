download_tpu <- function(sig, path = "data-raw/tpu") {
  load("data/sgt_atual.rda")
  
  u_tpu <- sgt_atual |>
    dplyr::filter(sigla == sig) |> 
    dplyr::pull(link)
  
  file <- glue::glue("{path}/tpu_{sig}.html")
  
  r_tpu <- httr::GET(u_tpu, httr::write_disk(file, overwrite = TRUE))
}
