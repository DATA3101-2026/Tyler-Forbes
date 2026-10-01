library(tidyverse)
library(dplyr)
library(nycflights13)

mutate(flights, gain = dep_delay - arr_delay, na.rm = TRUE)

showflightsinenv <- flights
sf <- showflightsinenv

flights_gain <- flights %>%
  mutate(
    gain = dep_delay - arr_delay, 
  )

flights_delay_gain <- flights_gain %>%
  mutate(
    gain_per_hour = gain / (air_time / 60),
    kmph = distance / (air_time / 60)
  )