
library(magrittr)

u <- "https://dejt.jt.jus.br/dejt/f/n/diariocon"

r0 <- httr::GET(u, httr::config(ssl_verifypeer = FALSE))

state <- r0 %>% 
  xml2::read_html() %>% 
  xml2::xml_find_first("//*[@name='javax.faces.ViewState']") %>% 
  xml2::xml_attr("value")

body <- list(
  "corpo:formulario:dataIni" = "25/11/2021",
  "corpo:formulario:dataFim" = "25/11/2021",
  "corpo:formulario:tipoCaderno" = "",
  "corpo:formulario:tribunal" = "",
  "corpo:formulario:ordenacaoPlc" = "",
  "navDe" = "1",
  "detCorrPlc" = "",
  "tabCorrPlc" = "",
  "detCorrPlcPaginado" = "",
  "exibeEdDocPlc" = "",
  "indExcDetPlc" = "",
  "org.apache.myfaces.trinidad.faces.FORM" = "corpo:formulario",
  "_noJavaScript" = "false",
  "javax.faces.ViewState" = state,
  "source" = "corpo:formulario:botaoAcaoPesquisar"
)

r <- httr::POST(
  u, 
  body = body, 
  httr::config(ssl_verifypeer = FALSE),
  encode = "form",
  httr::write_disk("output/dejt_inicial.html", overwrite = TRUE)
)

tabela <- r %>% 
  xml2::read_html() %>% 
  ## não funcionou, pois tem varias tabelas assim
  # xml2::xml_find_all("//table[contains(@class, 'tabelaSelecao')]")
  xml2::xml_find_first("//div[@id='diarioCon']/fieldset/table")

tabela_data <- rvest::html_table(tabela) %>% 
  janitor::clean_names()

botoes <- tabela %>% 
  xml2::xml_find_all(".//button") %>% 
  xml2::xml_attr("onclick") %>% 
  stringr::str_extract("corpo:formulario:plcLogicaItens[^']+")

tabela_data$number_baixar <- botoes

tabela_data

baixar_pdf <- function(id_documento, body) {
  
  body$source <- id_documento
  
  id_pdf <- id_documento %>% 
    stringr::str_extract("[0-9]+")
  
  nm_arquivo <- stringr::str_glue("output/pdf/{id_pdf}.pdf")
  # nm_arquivo <- paste0("output/pdf/", id_pdf, ".pdf")
  
  r <- httr::POST(
    u, 
    body = body, 
    httr::config(ssl_verifypeer = FALSE),
    encode = "form",
    httr::write_disk(nm_arquivo, overwrite = TRUE)
  )
  
  nm_arquivo
  
}

purrr::map(tabela_data$number_baixar, baixar_pdf, body = body)

