library(tidyverse)
library(httr)

u_sptrans <- "http://api.olhovivo.sptrans.com.br/v2.1"
endpoint <- "/Posicao"

u_sptrans_busca <- paste0(u_sptrans, endpoint)

r_sptrans <- httr::GET(u_sptrans_busca)
r_sptrans

httr::content(r_sptrans)

api_key <- "4af5e3112da870ac5708c48b7a237b30206806f296e1d302e4cb611660e2e03f"

# Sys.getenv("SENHA_API_OLHO_VIVO")
# usethis::edit_r_environ("project")

u_sptrans_login <- paste0(u_sptrans, "/Login/Autenticar")

r_sptrans_login <- httr::POST(u_sptrans_login, query = list(token = api_key))

r_sptrans_login

r_sptrans <- httr::GET(u_sptrans_busca)

# r_sptrans

lista <- httr::content(r_sptrans, simplifyDataFrame = TRUE)

tabela <- lista$l %>% 
  tibble::as_tibble() %>% 
  tidyr::unnest(vs)

# podemos replicar o comando abaixo para encontrar 
# os onibus de qualquer linha,
# varios onibus que vão pro mesmo lugar,
# etc...

onibus_filtrados <- tabela %>% 
  dplyr::filter(
    #stringr::str_detect(lt0, "BANDEIRA")
    stringr::str_detect(lt0, "SOCORRO"),
    stringr::str_detect(lt1, "LAPA")
  ) 

library(leaflet)

onibus_filtrados %>% 
  leaflet() %>% 
  addTiles() %>% 
  addMarkers(
    lng = ~px,
    lat = ~py,
    clusterOptions = markerClusterOptions()
  )
