# isso funciona, mas pode ser que não seja reprodutível
u_covid <- "https://mobileapps.saude.gov.br/esus-vepi/files/unAFkcaNDeXajurGB7LChj8SgQYS2ptm/a71f796436008700baff33364a71322c_HIST_PAINEL_COVIDBR_08nov2021.7z"
httr::GET(u_covid)

# vamos tentar obter o arquivo 7z automaticamente -------------------------

# isso retorna um arquivo cheio de javascripts que não contêm o caminho do arquivo
r0 <- httr::GET("https://covid.saude.gov.br", 
                httr::write_disk("output/covid_home.html"))


# vasculhando no site, identificamos essa url aqui, que potencialmente
# retorna o que queremos

u_portal_geral <- "https://xx9p7hp1p7.execute-api.us-east-1.amazonaws.com/prod/PortalGeral"
r_portal_geral <- httr::GET(u_portal_geral)

# o status code é 200
r_portal_geral$status_code

# mas o resultado...
httr::content(r_portal_geral)

# oh não


# vamos tentar com user agent
user_agent <- "Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/94.0.4606.104 Safari/537.36"

r_portal_geral <- httr::GET(
  u_portal_geral, 
  httr::user_agent(user_agent)
)
r_portal_geral$status_code
httr::content(r_portal_geral)


# adicionar um header
r_portal_geral <- httr::GET(
  u_portal_geral,
  httr::add_headers(`x-parse-application-id` = "unAFkcaNDeXajurGB7LChj8SgQYS2ptm")
)

headers <- jsonlite::read_json("output/headers_firefox.json") |> 
  purrr::pluck(1, 1) |> 
  purrr::map(~purrr::set_names(.x$value, .x$name)) |> 
  unlist()

r_portal_geral$status_code
link_acesso <- httr::content(r_portal_geral) |> 
  purrr::pluck("results", 1, "arquivo", "url")

# abjutils::chrome_to_body('referer: https://covid.saude.gov.br/
# sec-ch-ua: ";Not A Brand";v="99", "Chromium";v="94"
# sec-ch-ua-mobile: ?0
# sec-ch-ua-platform: "Linux"
# sec-fetch-dest: empty
# sec-fetch-mode: cors
# sec-fetch-site: cross-site
# user-agent: Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/94.0.4606.104 Safari/537.36
# x-parse-application-id: unAFkcaNDeXajurGB7LChj8SgQYS2ptm')


# agora vamos tentar pegar o x-parse-application-id automaticamente -------

u_js <- "https://covid.saude.gov.br/14-es2015.d9ae86a9db5bc4696730.js"
r_js <- httr::GET(u_js)
x_parse_app_id <- r_js |> 
  httr::content("text") |> 
  stringr::str_extract('(?<="X-Parse-Application-Id",")[0-9a-zA-Z]+')


# funcao final ------------------------------------------------------------

# (empiricamente) verificamos que não precisa
u_js <- "https://covid.saude.gov.br/14-es2015.d9ae86a9db5bc4696730.js"
r_js <- httr::GET(u_js)

x_parse_app_id <- r_js |> 
  httr::content("text") |> 
  stringr::str_extract('(?<="X-Parse-Application-Id",")[0-9a-zA-Z]+')

x_parse_app_id <- "unAFkcaNDeXajurGB7LChj8SgQYS2ptm"

# tambem verificamos que esse "xx9p7hp1p7" nao muda
u_portal_geral <- "https://xx9p7hp1p7.execute-api.us-east-1.amazonaws.com/prod/PortalGeral"

r_portal_geral <- httr::GET(
  u_portal_geral,
  httr::add_headers(`x-parse-application-id` = x_parse_app_id)
)

link_acesso <- httr::content(r_portal_geral) |> 
  purrr::pluck("results", 1, "arquivo", "url")

httr::GET(link_acesso, httr::write_disk("output/resultado.7z"))

