library(tidyverse)
library(dplyr)
library(nycflights13)

flights

# Q1
flights_delay_180 <- filter(flights, dep_delay>=180)

flights_delay_180 <- flights %>%
  filter(dep_delay>=180)

# Q2
sep_13_flights <- flights %>%
  filter(year == 2013, month == 9, day == 17)

# T3
dep_time_flights <- flights %>%
  arrange(desc(dep_time))

# T4
longest_dep_delay <- flights %>%
  arrange(desc(dep_delay))

# Q5
maybe_duplicate_rows <- flights %>%
  distinct()
# This implies there are no duplicate entries

# Q6
distinct_origins <- flights %>%
  distinct(origin, dest)

# 224 unique pairs of origins and destinations exist from 2013 New York City flights