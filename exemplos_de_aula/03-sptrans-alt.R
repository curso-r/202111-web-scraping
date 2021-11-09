# tentando obter a API key pelo site --------------------------------------

consulta_inicial <- httr::GET("http://olhovivo.sptrans.com.br/")
creds <- teste$headers[["set-cookie"]] |> 
  stringr::str_extract("(?<==)[A-Z0-9]+")

r <- httr::GET(
  "http://olhovivo.sptrans.com.br/data/Corredor",
  httr::set_cookies(apiCredentials = creds)
)

httr::content(r)

# vamos tentar aplicar isso na API ----------------------------------------

u_sptrans <- "http://api.olhovivo.sptrans.com.br/v2.1"
endpoint <- "/Posicao"
u_sptrans_busca <- paste0(u_sptrans, endpoint)

r_busca <- httr::GET(
  u_sptrans_busca,
  httr::set_cookies(apiCredentials = creds)
)

# nao funciona
httr::content(r_busca)

# mas mudando a url base, olha o que acontece... --------------------------

u_sptrans <- "http://olhovivo.sptrans.com.br/data"
endpoint <- "/Posicao"
u_sptrans_busca <- paste0(u_sptrans, endpoint)

r_busca <- httr::GET(
  u_sptrans_busca,
  httr::set_cookies(apiCredentials = creds)
)

httr::content(r_busca)
# lol

