#' Replaces every NA in some columns by the last non null string observed.
#' 
#' @param d a data frame.
#' @return d with different columns names.
type_fix <-
function(type){
  
  type <- tolower(type)
  
  movs <- "mov"
  classe <- "clas"
  assunto <- "ass"
  
  ifelser::test_if(stringr::str_detect(type, movs)) %>% 
    ifelser::if_true("Movimentos") %>% ifelser::if_false() %>%
    ifelser::test_if(stringr::str_detect(type, classe)) %>%
    ifelser::if_true("Classes") %>% ifelser::if_false() %>%
    ifelser::test_if(stringr::str_detect(type, assunto)) %>% 
    ifelser::if_true("Assuntos") %>% ifelser::if_false('')
}

#' Replaces every NA in some columns by the last non null string observed.
#' 
#' @param d a data frame.
#' @return d with different columns names.
court_fix <-
  function(court){
    
    type <- tolower(court)
    
    estadual <- "est"
    federal <- "fed"
    eleitoral <- "ele"
    militar_estadual <- "militar estadual"
    militar_federal <- "militar federal|militar uniao"
    

    ifelser::test_if(stringr::str_detect(court, militar_estadual)) %>% 
      ifelser::if_true("Justica Militar Estadual") %>% ifelser::if_false() %>%
      ifelser::test_if(stringr::str_detect(court, militar_federal)) %>% 
      ifelser::if_true("Justica Militar Uniao") %>% ifelser::if_false() %>% 
      ifelser::test_if(stringr::str_detect(court, estadual)) %>% 
      ifelser::if_true("Justica Estadual") %>% ifelser::if_false() %>%
      ifelser::test_if(stringr::str_detect(court, federal)) %>%
      ifelser::if_true("Justica Federal") %>% ifelser::if_false() %>%
      ifelser::test_if(stringr::str_detect(court, eleitoral)) %>% 
      ifelser::if_true("Justica Eleitoral") %>% ifelser::if_false() %>% 
      ifelser::test_if(stringr::str_detect(court, "cnj")) %>% 
      ifelser::if_true("CNJ") %>% ifelser::if_false() %>% 
      ifelser::test_if(stringr::str_detect(court, "stf")) %>% 
      ifelser::if_true("STF") %>% ifelser::if_false() %>% 
      ifelser::test_if(stringr::str_detect(court, "cjf")) %>% 
      ifelser::if_true("CJF") %>% ifelser::if_false() %>% 
      ifelser::test_if(stringr::str_detect(court, "stj")) %>% 
      ifelser::if_true("STJ") %>% ifelser::if_false('')
}

#' Replaces every NA in some columns by the last non null string observed.
#' 
#' @param d a data frame.
#' @return d with different columns names.
level_fix <-
  function(level){
    
    level <- tolower(level)
    
    prim_grau <- "primeiro grau|1º grau|1 grau|1grau"
    sec_grau <- "segundo grau|2º grau|2 grau|2grau"
    especial <- "esp"
    recursal <- "rec"
    
    ifelser::test_if(stringr::str_detect(level, prim_grau)) %>% 
      ifelser::if_true("1º Grau") %>% ifelser::if_false() %>%
      ifelser::test_if(stringr::str_detect(level, sec_grau)) %>%
      ifelser::if_true("2º Grau") %>% ifelser::if_false() %>%
      ifelser::test_if(stringr::str_detect(level, especial)) %>% 
      ifelser::if_true("Juizado Especial") %>% ifelser::if_false() %>% 
      ifelser::test_if(stringr::str_detect(level, recursal)) %>% 
      ifelser::if_true("Turmas Recursais") %>% ifelser::if_false('')
}
