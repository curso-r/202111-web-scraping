library(magrittr)

# acesso ------------------------------------------------------------------

u_cdg <- "http://www.chancedegol.com.br/br19.htm"
r_cdg_raw <- httr::GET(u_cdg)

r_cdg_raw <- httr::GET(u_cdg, httr::write_disk("output/cdg.html", overwrite = TRUE))

readr::guess_encoding("output/cdg.html")


# parse -------------------------------------------------------------------

cdg_html <- httr::content(r_cdg_raw, type = "text/html", encoding = "ISO-8859-1")

tabela <- cdg_html %>% 
  xml_find_all("/html/body/div/font/table")

tabela_jeito_simples_all <- cdg_html %>% 
  xml_find_all("//table")

tabela_jeito_simples_first <- cdg_html %>% 
  xml_find_first("//table")

tabela_preliminar <- tabela_jeito_simples_first %>% 
  rvest::html_table(header = TRUE) %>% 
  janitor::clean_names()

tabela_tidy <- tabela_preliminar %>% 
  dplyr::mutate(
    data = lubridate::dmy(data),
    vitoria_do_mandante = readr::parse_number(vitoria_do_mandante)/100,
    empate = readr::parse_number(empate)/100,
    vitoria_do_visitante = readr::parse_number(vitoria_do_visitante)/100
  ) %>% 
  dplyr::rename(placar = x)

# versão do código com pipeline reduzido

tabela_tidy <- httr::content(r_cdg_raw, type = "text/html", encoding = "ISO-8859-1") %>% 
  xml_find_first("//table") %>% 
  rvest::html_table(header = TRUE) %>% 
  janitor::clean_names() %>% 
  dplyr::mutate(
    data = lubridate::dmy(data),
    vitoria_do_mandante = readr::parse_number(vitoria_do_mandante)/100,
    empate = readr::parse_number(empate)/100,
    vitoria_do_visitante = readr::parse_number(vitoria_do_visitante)/100
  ) %>% 
  dplyr::rename(placar = x)


