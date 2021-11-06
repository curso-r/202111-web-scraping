
# pacotes -----------------------------------------------------------------

library(httr)
library(magrittr)
library(jsonlite)

u_base <- "https://mananciais.sabesp.com.br/api/Mananciais/ResumoSistemas/"
endpoint <- "2021-10-21"
u_sabesp <- paste0(u_base, endpoint)

# todas as opcoes
# httr_options() %>% View()

r_sabesp <- GET(u_sabesp, config(ssl_verifypeer = FALSE))

resultado <- content(r_sabesp, as = "parsed", simplifyDataFrame = TRUE)

tabela <- resultado$ReturnObj$sistemas %>% 
  tibble::as_tibble() %>% 
  janitor::clean_names()


# transformando em uma função ---------------------------------------------

baixa_reservatorios <- function(data) {
  u_base <- "https://mananciais.sabesp.com.br/api/Mananciais/ResumoSistemas/"
  # endpoint <- "2021-10-21"
  u_sabesp <- paste0(u_base, data)
  
  # todas as opcoes
  # httr_options() %>% View()
  
  r_sabesp <- GET(u_sabesp, config(ssl_verifypeer = FALSE))
  
  resultado <- content(r_sabesp, as = "parsed", simplifyDataFrame = TRUE)
  
  tabela <- resultado$ReturnObj$sistemas %>% 
    tibble::as_tibble() %>% 
    janitor::clean_names()
  
  tabela
}

baixa_reservatorios("2021-11-03")

remotes::install_github("beatrizmilz/mananciais")
mananciais::dados_mananciais()

# mananciais:::
# mananciais:::obter_dia("2021-11-03")




funcao <- function(x) {
  x
}

funcao <- function(x) {
  
  if (x > 10) {
    return(x+1)
  } else {
    y <- x-10
    return(y)
  }
  
  
}