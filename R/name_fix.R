name_fix <-
function(d){
  old_names <- names(d)
  new_names <- old_names
  
  nodes <- stringr::str_detect(old_names, "processuais")
  
  new_names[nodes] <- stringr::str_c("n",1:sum(nodes))
  names(d) <- new_names
  
  return(d)
}