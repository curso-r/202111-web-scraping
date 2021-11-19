library(xml2)
library(httr)
library(magrittr)
library(purrr)

# 0. nossa missão é baixar várias páginas da wikipedia pro computador

# 1. listar links

url0 <- 'https://en.wikipedia.org/wiki/R_(programming_language)'
url_wiki <- "https://en.wikipedia.org"

links <- read_html(url0) %>% 
  xml_find_all(".//a") %>% 
  #xml_find_all("//*[@id='mw-content-text']/div[1]/p[2]/a[1]")
  xml_attr("href") %>% 
  stringr::str_c(url_wiki, .) %>% 
  na.omit() %>% 
  # tirar os NAs
  as.character()

links_para_baixar <- links[1:20]

# 2. preparar o terreno para as repeticoes

### RASCUNHO: 

link_inicial <- links[6]
diretorio <- "pasta_da_wiki/"

nome_do_arquivo <- link_inicial %>% 
  fs::path_file() %>% 
  stringr::str_replace_all("[:punct:]", "_") %>% 
  stringr::str_to_lower() %>% 
  fs::path(diretorio, . , ext = "html")

httr::GET(link_inicial, httr::write_disk(nome_do_arquivo, overwrite = TRUE))

### FIM DO RASCUNHO ^^

baixa_pagina_da_wiki <- function(link, dir){
  
  nome_do_arquivo <- link %>% 
    fs::path_file() %>% 
    stringr::str_replace_all("[:punct:]", "_") %>% 
    stringr::str_to_lower() %>% 
    fs::path(dir, . , ext = "html")
  
  httr::GET(link, httr::write_disk(nome_do_arquivo, overwrite = TRUE))
  
  return(nome_do_arquivo)
  
}

# 3. iterar (repetir downloads parecidos várias vezes)

purrr::map(links[1:3], baixa_pagina_da_wiki, dir = "D:/202111-web-scraping/pasta_da_wiki")
