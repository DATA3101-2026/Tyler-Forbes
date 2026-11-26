library(tidyverse)
library(httr2)
library(rinat)
library(RJSONIO)
library(sf) # Simple Features for R
library(cowplot) # Streamlined Plot Theme and Plot Annotations for GGPLOT2
library(ggplot2)
library(maps)
# Search area around Sackville: c(south lat, west lon, north lat, east lon)
bounds <- c(45.55, -64.7, 46, -64.25)

#Location of dunn building
lat <- 45.902055
lon <- -64.373069

#Part 1
heron <- get_inat_obs(query = "Great Blue Heron", bounds = bounds)

obs <- get_inat_obs(bounds = bounds, maxresults = 3000) #maxresults has a default cap to break for sensible reasons

#saving dataframe created so observations don't change each time, plot will be accurate
heronJson <- toJSON(heron)
write(heronJson, "heron.json")

obsJson <- toJSON(obs)
write(obsJson, "obs.json")

# R Plot with some help and map to outline a rough coastline
plot(heron$longitude, heron$latitude,
     xlim = c(bounds[2], bounds[4]),
     ylim = c(bounds[1], bounds[3]),
     xlab = "Longitude (degrees)", ylab = "Latitude (degrees)",
     main = "Great Blue Heron sightings near campus",
     sub = "Source: iNaturalist",
     pch = 19, col = "blue")
map("world", add = TRUE, fill = TRUE, col = "lightgray", border = "darkgray")


#Part 2

daily <- obs %>%
  mutate(date = as.Date(observed_on)) %>%
  count(date, sort = TRUE)

daily_2026 <- daily %>% #Filtering to 2026! YTD on Nov 25
  filter(lubridate::year(date) == 2026)

obs_plot <- ggplot(daily_2026, aes(date, n)) +
  geom_col() +
  scale_x_date(
    limits = c(as.Date("2026-01-01"), max(daily_2026$date)),
    date_breaks = "1 month", date_labels = "%b",
    oob = scales::oob_keep
  ) +
  labs(x = "Date observed", y = "Number of observations",
       title = "iNaturalist observations near campus in 2026") +
  theme_bw()

print(min(daily_2026$date))

#Part 3

print(head(daily_2026)) 

daily_uploads <- obs %>%
  mutate(date = as.Date(created_at)) %>%
  count(date, sort = TRUE)

print(head(daily_uploads)) #Same date range! Procrastinating students.

#Part 4

heron_2026 <- heron %>%
  mutate(date = as.Date(observed_on)) %>%
  filter(lubridate::year(date) == 2026)

heron_daily <- heron_2026 %>%
  count(date, sort = TRUE)

start_date <- min(heron_daily$date)
end_date <- max(heron_daily$date)

# Panel A
map_plot <- ggplot(heron_2026, aes(longitude, latitude)) +
  borders("world", fill = "lightgray", colour = "darkgray",
          xlim = c(bounds[2], bounds[4]), ylim = c(bounds[1], bounds[3])) + #So this fixes the not being able to see the blue dots under the grey! no map
  geom_point(colour = "blue") +
  coord_sf(xlim = c(bounds[2], bounds[4]),
           ylim = c(bounds[1], bounds[3]), expand = FALSE) +
  labs(x = "Longitude (degrees)", y = "Latitude (degrees)",
       title = "Great Blue Heron sightings near campus in 2026") +
  theme_bw()

# Panel B
dates_plot <- ggplot(heron_daily, aes(date, n)) +
  geom_col() +
  scale_x_date(
    limits = c(as.Date("2026-01-01"), max(daily_2026$date)),
    date_breaks = "1 month", date_labels = "%b",
    oob = scales::oob_keep
  ) +
  labs(x = "Date observed", y = "Number of sightings",
       title = "Great Blue Heron sightings by date") +
  theme_bw()

#Panel C
weather_hist <- request("https://archive-api.open-meteo.com/v1/archive") %>%
  req_url_query(
    latitude = lat, longitude = lon,
    start_date = "2026-01-01", end_date = "2026-11-25", #Date of code finished
    daily = "temperature_2m_mean,precipitation_sum",
    timezone = "America/Halifax"
  ) %>%
  req_perform() %>%
  resp_body_json()

weatherJson <- toJSON(weather_hist)
write(weatherJson, "weather_hist.json") #saving data!

weather_daily <- data.frame(
  date = as.Date(unlist(weather_hist$daily$time)),
  temperature_2m_mean = unlist(weather_hist$daily$temperature_2m_mean),
  precipitation_sum = unlist(weather_hist$daily$precipitation_sum)
)

weather_daily

weather_heron <- weather_daily %>%
  left_join(heron_daily, by = "date") %>%
  mutate(n = replace_na(n, 0))

weather_plot <- weather_daily %>%
  rename(`Temperature (°C)` = temperature_2m_mean,
         `Precipitation (mm)` = precipitation_sum) %>% #Much prettier
  pivot_longer(-date, names_to = "measure", values_to = "value") %>% #reshapes the data from wide to long
  ggplot(aes(date, value)) +
  geom_line() +
  facet_wrap(~measure, ncol = 1, scales = "free_y") +
  scale_x_date(limits = c(start_date, end_date),
               date_breaks = "1 month", date_labels = "%b") +
  labs(x = "Date", y = "", title = "Historical weather near campus") +
  theme_bw()

combined_plot <- plot_grid(
  plot_grid(map_plot, dates_plot,
            labels = c("A", "B"), ncol = 1),
  plot_grid(weather_plot, labels = "C"),
  ncol = 2
) #reworked to have C on the side, it's still messy but a lot easier to look at at now it has all the information needed.



combined_plot
