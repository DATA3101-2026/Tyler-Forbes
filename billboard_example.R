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
bb_long

#ggplot 2 work
ggplot(bb_long,
       aes(x = week, y = rank, colout = artist)) + geom_point()

example_songs <- bb_long %>%
  filter(track %in% c("Say My Name", "Give Me You", "Jumpin' Jumpin'", "Deep Inside"))

#Today in class, we learned about tidying data, and formatting it in Long and Wide formats, altering column/row numbers to adjust data for different purposes.
#Tidy data is essential for effective results, proper visualizations, and collaboration.

ggplot(example_songs, aes(x = week, y = rank, group = track, color = track)) +
  geom_line(linewidth = 1.2) +
  geom_point(size = 2) +
  #reverse the y axis, ranks start at the very top of the graph, like places in a race
  scale_y_reverse(breaks = c(1,10,20,50,100)) +
  #Look into color brewer
  scale_color_brewer(palette = "Set1") +
  labs(
    title = "Billboard Hot 100 Performance in 2000",
    subtitle = "Weekly billboard place of selected hit singles",
    x = "Weeks on Chart",
    y = "Chart Rank (top is higher)",
    color = "Song Title",
    caption = "Data Source: tidyr::billboard"
  )

