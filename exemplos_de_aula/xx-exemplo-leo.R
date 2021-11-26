u <- "https://br.investing.com/commodities/brent-oil-historical-data"

r <- httr::GET(u)

# TASK 1: acessar a tabela principal OK

tab <- r |> 
  xml2::read_html() |> 
  xml2::xml_find_first("//*[@id='curr_table']") |> 
  rvest::html_table()

# TASK 2: mudar o parametro da telinha

u_ajax <- "https://br.investing.com/instruments/HistoricalDataAjax"

body <- list(
  "curr_id" = "8833",
  "smlID" = "300028",
  "header" = "Petróleo Brent Futuros Dados Históricos",
  "st_date" = "26/11/2020",
  "end_date" = "25/11/2021",
  "interval_sec" = "Daily",
  "sort_col" = "date",
  "sort_ord" = "DESC",
  "action" = "historical_data"
)

r_ajax <- httr::POST(
  u_ajax, 
  body = body, 
  httr::add_headers(.headers = c(
    "x-requested-with" = "XMLHttpRequest"
  )),
  encode = "form"
)

tab <- r_ajax |> 
  xml2::read_html() |> 
  xml2::xml_find_first("//*[@id='curr_table']") |> 
  rvest::html_table()
