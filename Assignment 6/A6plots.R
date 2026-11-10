library(tidyverse)
library(rvest) #harvest
library(httr2)
library(jsonlite)
library(purrr)
library(dplyr)
library(tidytuesdayR)
library(knitr)
library(ggplot2) 

tuesdata <- tidytuesdayR::tt_load('2026-03-31')

ocean_temperature <- tuesdata$ocean_temperature
ocean_temperature_deployments <- tuesdata$ocean_temperature_deployments

ocean_temp <- cross_join(ocean_temperature, ocean_temperature_deployments, copy = FALSE) %>%
  filter(date >= start_date, date <= end_date)


#Plot 1

ggplot(ocean_temp) +
  geom_area(
    mapping = aes(
      x = date,
      y = mean_temperature_degree_c,
      colour = deployment_id,
      fill = deployment_id
    )
  ) +
  labs(
    title = "Ocean Temperature over Time",
    subtitle = "Data sourced from the tidytuesdayR package",
    x = "Date",
    y = "Mean Temperature in Degrees Celsius"
  )

#plot 2

dplmnt8 <- ocean_temp %>%
  filter(deployment_id == "depl_08")

ggplot(dplmnt8) +
  geom_line(
    mapping = aes(
      x = date,
      y = mean_temperature_degree_c,
    ),
    colour = "cyan" # I found that moving it outside of mapping made it cyan instead of red or black :D
  ) +
  labs(
    title = "Mean Ocean Temperature over Deployment 8, 2022",
    subtitle = "Data sourced from the tidytuesdayR package",
    x = "Date",
    y = "Mean Temperature in Degrees Celsius"
  )

#Plot 3

dplmnt13 <- ocean_temp %>%
  filter(deployment_id == "depl_13")

ggplot(dplmnt13) +
  geom_line(
    aes(x = date,
        y = mean_temperature_degree_c + sd_temperature_degree_c),
    colour = "black"
  ) +
  geom_line(
    aes(x = date,
        y = mean_temperature_degree_c - sd_temperature_degree_c),
    colour = "black"
  ) +
  geom_line(
    mapping = aes(
      x = date,
      y = mean_temperature_degree_c,
    ),
    colour = "red" 
  ) +
  labs(
    title = "Mean Ocean Temperature over Deployment 13, 2024-2025",
    subtitle = "Data sourced from the tidytuesdayR package",
    x = "Date",
    y = "Mean Temperature in Degrees Celsius"
  ) 
