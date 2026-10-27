library(tidyverse)
library(rvest) #harvest
library(httr2)
library(jsonlite)
library(purrr)
library(dplyr)

#setting link value
link <- "https://en.wikipedia.org/wiki/List_of_counties_of_Nova_Scotia"
page <- read_html(link)

#Bringing table in from website - county info into variable nsC
nsC <- data.frame(page %>%
       html_element("table.wikitable.sortable") %>%
       html_table())

library(knitr)

kable(nsC, caption = "Table scraped from Wikipedia for class, showing a list of the counties in Nova Scotia, Canada.")

names(nsC)[names(nsC) == 'Population.2021..7.'] <- 'Population_2021' #cleaning up row names
names(nsC)[names(nsC) == 'Population.2016..7.'] <- 'Population_2016'

nsC$Population_2021 <- gsub(",","", nsC$Population_2021) #replace the "," with " ".
nsC$Population_2021 <- as.numeric(as.character(nsC$Population_2021))

max(nsC$Population_2021) #this is the total counties pop. because we brought in that row as well
# Two ways to exclude the total row in the range
max(nsC$Population_2021[1:18])
max(nsC$Population_2021[-19])
