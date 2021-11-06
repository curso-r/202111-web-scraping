# pacotes -----------------------------------------------------------------

library(httr)
library(magrittr)
library(jsonlite)

u_base <- "https://pokeapi.co/api/v2"
endpoint <- "/pokemon/caterpie"
u_pokemon <- paste0(u_base, endpoint)
r_pokemon <- GET(u_pokemon)


# pegar o conteúdo da requisição ------------------------------------------

lista <- content(r_pokemon)
b <- content(r_pokemon, as = "parsed", simplifyDataFrame = TRUE)
a <- content(r_pokemon, as = "text")

# de a até b?
resultado <- fromJSON(a, simplifyDataFrame = TRUE)
identical(b, resultado)

# menos utilizado
content(r_pokemon, as = "raw")

# browseURL("https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/versions/generation-viii/icons/10.png")


# listando pokemons -------------------------------------------------------

r <- GET(
  # paste0(u_base, "/pokemon?limit=10&offset=100"),
  paste0(u_base, "/pokemon"),
  query = list(
    limit = 10,
    offset = 100
  )
)
r

lista <- content(r)

length(lista$results)
lista$results


# salvando nosso resultado em disco ---------------------------------------

r_disco <- GET(
  # paste0(u_base, "/pokemon?limit=10&offset=100"),
  paste0(u_base, "/pokemon"),
  query = list(
    limit = 10,
    offset = 100
  ),
  write_disk("output/meus_poke.json", overwrite = TRUE)
)

