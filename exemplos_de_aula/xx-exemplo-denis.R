abjutils::chrome_to_body("co_obra: 
co_flag_periodico: 0
co_midia: 3
co_categoria: 22
co_autor: 
no_autor: 
ds_titulo: 
co_idioma: 
select_action: Submit")

qq <- list(
  # "org.apache.struts.taglib.html.TOKEN" = "5f33feed52d996b4cd77e5bd9836654e",
  "co_obra" = "",
  "co_flag_periodico" = "0",
  "co_midia" = "3",
  "co_categoria" = "22",
  "co_autor" = "",
  "no_autor" = "",
  "ds_titulo" = "",
  "co_idioma" = "",
  "select_action" = "Submit"
)

r <- httr::POST(
  "http://www.dominiopublico.gov.br/pesquisa/PesquisaObraForm.do",
  body = qq
)

scrapr::html_view(r)
