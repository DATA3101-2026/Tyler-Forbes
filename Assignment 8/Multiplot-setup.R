library(tidyverse)
library(httr2)
library(rinat)
library(RJSONIO)
library(sf) # Simple Features for R
library(cowplot) # Streamlined Plot Theme and Plot Annotations for GGPLOT2
library(ggplot2)
# Search area around Sackville: c(south lat, west lon, north lat, east lon)
bounds <- c(45.55, -64.7, 46, -64.25)

#Location of dunn building
lat <- 45.902055
lon <- -64.373069

heron <- get_inat_obs(query = "Great Blue Heron", bounds = bounds)

obs <- get_inat_obs(bounds = bounds, maxresults = 3000) 

#saving dataframe created so observations don't change each time, plot will be accurate
heronJson <- toJSON(heron)
write(heronJson, "heron.json")

obsJson <- toJSON(obs)
write(obsJson, "obs.json")

plot(heron$longitude, heron$latitude,
     xlim = c(bounds[2], bounds[4]),
     ylim = c(bounds[1], bounds[3]),
     xlab = "Longitude (degrees)", ylab = "Latitude (degrees)",
     main = "Great Blue Heron sightings near campus",
     sub = "Source: iNaturalist",
     pch = 19, col = "blue")

daily <- obs %>%
  mutate(date = as.Date(observed_on)) %>%
  count(date, sort = TRUE)

daily_uploads <- obs %>%
  mutate(date = as.Date(created_at)) %>%
  count(date, sort = TRUE)

heron_daily <- heron %>%
  mutate(datetime = as.Date(created_at)) %>%
  count(datetime, sort = TRUE)

ggplot(heron_daily, aes(datetime, n)) +
  geom_col() +
  labs(x = "Date observed", y = "Number of observations",
       title = "Total iNaturalist observations of Blue Herons near campus")

ggplot(daily, aes(date, n)) +
  geom_col() + 
  labs(x = "Date observed", y = "Number of observations",
       title = "iNaturalist observations near campus")

heron_map <- inat_map(heron, plot = FALSE)

heron_map + coord_sf(
  xlim = c(-64.7, -64.2), ylim = c(45.5, 46), expand = FALSE) +
  borders('world', xlim = c(bounds[2], bounds[4]), ylim = c(bounds[1], bounds[3])) +
  scale_size_area() + theme_bw()

weather_hist <- request("https://archive-api.open-meteo.com/v1/archive") %>%
  req_url_query(
    latitude = lat, longitude = lon,
    start_date = "2026-01-01", end_date = "2026-11-18",
    daily = "temperature_2m_mean,precipitation_sum",
    timezone = "America/Halifax"
  ) %>%
  req_perform() %>%
  resp_body_json()
