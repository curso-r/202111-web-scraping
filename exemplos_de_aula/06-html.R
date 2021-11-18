#install.packages("xml2")

library(xml2)

download.file("https://raw.githubusercontent.com/curso-r/main-web-scraping/master/exemplos_de_aula/html_exemplo.html",
              "exemplos_de_aula/html_exemplo.html")

html <- read_html('exemplos_de_aula/html_exemplo.html')

class(html)

html

todos_os_p <- xml_find_all(html, "//p")

p_filho_de_body <- xml_find_all(html, "./body/p")

body <- xml_find_all(html, "./body")

xml_text(todos_os_p)
xml_text(body)

xml_attrs(todos_os_p)

xml_attr(todos_os_p, "style") <- "color:green"
