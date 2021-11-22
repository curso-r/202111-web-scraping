r0 <- httr::GET("https://app.glueup.com")

u_login <- "https://app.glueup.com/account/login/iframe"

body <- list(
  email = "teste@abj.org.br",
  password = "teste123",
  forgotPassword = '{"value":"Forgot password?","url":"\\/account\\/forgot-password"}',
  stayOnPage = "",
  showFirstTimeModal = "true"
)

r_app <- httr::POST(
  u_login, body = body,
  # encode = 
  httr::write_disk("test.html"), 
)

r_pagina <- httr::GET("https://app.glueup.com/my/home/",
                      httr::write_disk("output/teste_home_glueup.html"))

# "jtrecenti/scrapr"
# scrapr::html_view(r_app)
# scrapr:::html_view.response
# scrapr:::vis

# abjutils::chrome_to_body("email: teste@abj.org.br
# password: teste123")
