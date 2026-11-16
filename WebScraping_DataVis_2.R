library(tidyverse) 
library(rvest)
library(httr2)
library(jsonlite)
library(purrr)
library(dplyr)

# test rvest with wikipedia article about the area surrounding the dataset we are looking at today

link <- "https://en.wikipedia.org/wiki/List_of_counties_of_Nova_Scotia"
page <- read_html(link)

# This is a long variable name. What would you shorten it to?
novaScotiaCounties <- data.frame(page |> 
                                   html_element("table.wikitable.sortable") |> 
                                   html_table())

#---- I'll use this name for my code ----

nsc <- data.frame(page |> 
                    html_element("table.wikitable.sortable") |> 
                    html_table())
#---- Test out the command in your console below. What do the numbers mean? ----
# > dim(final)

#---- Let's look at the names of the dataframe ---- 

colnames(nsc) # What are the numbers in these columns from? Check out the wiki page if you don't know!

#--- What if we want to see which population number is biggest? ----

# Let's clean up the 2021 population name
names(nsc)[names(nsc) == 'Population.2021..7.'] <- 'Population_2021'

# What happens when we run this?
#nsc$Population_2021 <- as.numeric(as.character(nsc$Population_2021))

# ---- Let's try again.  ----
# Comment out the previous command and run up to this line.
nsc$Population_2021 <- gsub(",","", nsc$Population_2021) #What does this line do?
nsc$Population_2021 <- as.numeric(as.character(nsc$Population_2021)) # How does it work now?

#----- Let's do this with New Brunswick counties ----


# I've quickly renamed my variables. Where could you find some errors in the code?
nblink <- "https://en.wikipedia.org/wiki/List_of_counties_of_New_Brunswick"
nbpage <- read_html(nblink)


#---- I'll use this name for my code ----

nbc <- data.frame(nbpage |> 
                    html_element("table.wikitable.sortable") |> 
                    html_table())


#---- Let's look at the names of the dataframe ---- 

colnames(nbc) # What are the numbers in these columns from? Check out the wiki page if you don't know!


# Preparation for assignment 7
library(RJSONIO)

# ---- How can we figure out the coordinates for where our classroom is? -----
lat <- 45.902055  # Dunn building coords
lon <- -64.373069

# ---- Creating an API request ----
resp <- request("https://api.open-meteo.com/v1/forecast") |>
  req_url_query(
    latitude = lat,
    longitude = lon,
    current = "temperature_2m,wind_speed_10m,wind_direction_10m,cloud_cover"
  ) |>
  req_perform()

weather <- resp_body_json(resp)
weather$current



# ---- species in the area -----
inat <- request("https://api.inaturalist.org/v1/observations") |>
  req_url_query(lat = lat, lng = lon, radius = 1, per_page = 50,
                quality_grade = "research") |>
  req_perform() |>
  resp_body_json()

species <- sapply(inat$results, \(x) x$taxon$name)
table(species)

# ---- Saving to a json file

# Weather dataset turned to json for saving

weatherJson <- toJSON(weather)

write(weatherJson, "weather-test.json")

library(rinat)

monarchs <- get_inat_obs(query = "Monarch Butterfly", year = 2026, month = 8)

#which taxa were returned?
unique(monarchs$scientific_name)

##search by bounds
bounds <- c(45.44, -64.7, 46, -64.25)
heron <- get_inat_obs(query = "Great Blue Heron", bounds = bounds)
plot(heron$longitude, heron$latitude)

#Saving species data

specJSON <- toJSON(species)
write(specJSON, "species_test.json")
