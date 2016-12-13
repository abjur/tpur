type_fix <-
function(type){
  
  type <- tolower(type)
  
  movs <- "mov"
  classe <- "clas"
  assunto <- "ass"
  
  test_if(str_detect(type, movs)) %>% 
    if_true("Movimentos") %>% if_false() %>%
    test_if(str_detect(type, classe)) %>%
    if_true("Classes") %>% if_false() %>%
    test_if(str_detect(type, assunto)) %>% 
    if_true("Assuntos") %>% if_false('')
}
