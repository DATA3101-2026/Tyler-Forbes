library(tidyverse)
library(dplyr)
library(billboard)
library(tidyr)

#Looking at the data
billboard <- billboard

#trying pivot_longer
bb_long <- billboard %>%
  pivot_longer(
    cols = starts_with("wk"),
    names_to = "week",
    names_prefix = "wk",
    names_transform = as.integer,
    values_to = "rank",
    values_drop_na = TRUE
  )
# selecting the columns with each ranking, splitting each track into its per week value as a row.
# removing rows with na values for rank
billboard_longer

#ggplot 2 work
ggplot(bb_long,
       aes(x = week, y = rank, colout = artist)) + geom_point()

example_songs <- bb_long %>%
  filter(track %in% c("Say My Name", "Give Me You", "Jumpin' Jumpin'", "Deep Inside"))
