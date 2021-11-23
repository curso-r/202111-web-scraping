library(webdriver)
library(magrittr)

u_pesqele <- "https://rseis.shinyapps.io/pesqEle/"

httr::GET(u_pesqele, httr::write_disk("output/pesqele.html"))

# cria o processo do pjs
pjs <- run_phantomjs()
ses <- Session$new(port = pjs$port)

ses$go(u_pesqele)
ses$takeScreenshot("output/pesqele.png")

# elems <- ses$findElements(css = ".info-box-number")
elems <- ses$findElements(xpath = "//span[@class='info-box-number']")

elems[[1]]$getText()

# usando nossos poderes de purrr para pegar todos
textos <- purrr::map_chr(elems, ~.x$getText())

# vamos filtrar os resultados para pesquisas presidenciais e clicar

radio <- ses$findElement(xpath = "//input[@name='abrangencia' and @value='nacionais']")
radio$click()

ses$takeScreenshot("output/pesqele_clicado.png")

elems <- ses$findElements(xpath = "//span[@class='info-box-number']")
textos_presidente <- purrr::map_chr(elems, ~.x$getText())

# vamos voltar para todas as pesquisas
radio <- ses$findElement(xpath = "//input[@name='abrangencia' and @value='todas']")
radio$click()
elems <- ses$findElements(xpath = "//span[@class='info-box-number']")
textos_denovo <- purrr::map_chr(elems, ~.x$getText())

## matar o navegador
# ses$delete()
## matar o serviço de criar navegadores
# pjs$process$kill()

# acessar dados de uma aba do dash ----------------------------------------

tab <- ses$findElement(xpath = "//a[@href='#shiny-tab-empresas']")
tab$click()
ses$takeScreenshot()

elem <- ses$findElement(xpath = "//select[@name='DataTables_Table_0_length']/option[@value='200']")

script <- '$("#DataTables_Table_0_length > label > select > option:nth-child(5)").attr("value", "200")'

elem$executeScript(script)

elem$click()
ses$takeScreenshot()

html <- ses$getSource()

readr::write_file(html, "output/arquivo_pesqele.html")

tab <- "output/arquivo_pesqele.html" %>% 
  xml2::read_html() %>% 
  xml2::xml_find_first("//table") %>% 
  rvest::html_table()

tab %>% 
  janitor::clean_names()

