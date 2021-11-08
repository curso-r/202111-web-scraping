# install.packages("rtweet")

library(tidyverse)
library(rtweet)

trends <- rtweet::get_trends("Brazil")

# 1. postar

rtweet::post_tweet(
  "Estou tuitando para o curso de Web Scraping da @curso_r, usando o pacote {rtweet}! #rstats"
)

# 2. timeline

minha_timeline <- rtweet::get_timeline("curso_r")

# 3. mencoes

minhas_mencoes <- rtweet::get_mentions()

# 4. pegar tweets que usam uma certa hashtag

dados_hashtag <- rtweet::search_users("#rstats", n = 100)
