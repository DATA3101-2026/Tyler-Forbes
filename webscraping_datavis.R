library(tidyverse)
library(rvest) #harvest
library(httr2)
library(jsonlite)
library(purrr)
library(dplyr)
library(tidytuesdayR)
library(knitr)

#loading in data from the tidytuesdayR repository on github
tuesdata <- tidytuesdayR::tt_load('2026-03-31')

ocean_temperature <- tuesdata$ocean_temperature
ocean_temperature_deployments <- tuesdata$ocean_temperature_deployments

ocean_temp <- cross_join(ocean_temperature, ocean_temperature_deployments, copy = FALSE) %>%
  filter(date >= start_date, date <= end_date)

library(ggplot2) #visualization time!

ggplot(ocean_temp) +
  geom_area(mapping=aes(mean_temperature_degree_c, date, colour = deployment_id)) #rubbish plot

ggplot(ocean_temp) +
  geom_area(mapping=aes(date, mean_temperature_degree_c, colour = deployment_id))

#smoother colours
ggplot(ocean_temp) +
  geom_area(mapping=aes(date, mean_temperature_degree_c, colour = deployment_id, fill = deployment_id))
