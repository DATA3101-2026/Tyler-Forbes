# Assignment 6: Plotting Coastal Ocean Temperatures in R

## Tyler Forbes, November 9, 2026

###Overview

For this assignment I loaded the TidyTuesday ocean temperature data using the tidytuesdayR package and joined the daily temperature readings to the deployment table so each reading was matched to the individual deployment thati t came from. I used ggplot2 to plot temperature over the whole record and zoomed in on a single deployment for different vizualisations.

###Graph 1: Ocean Temperature over Time

![Graph 1: Ocean Temperature over Time](plot1.png)

This is an area chart of mean daily ocean temperature from 2018 to 2025, with each deployment shown in its own colour. To get here I cross joined the temperature data with the deployments table and kept only the rows where the date fell between each deployment's start and end dates. The yearly pattern stands out right away, with temperatures climbing every summer and dropping back down each winter.

###Graph 2: Mean Ocean Temperature over Deployment 8, 2022

![Graph 2: Mean Ocean Temperature over Deployment 8](plot2.png)

**Deployment chosen:** Deployment 8, which ran from May 12 to November 3, 2022.

**Notes:** At first my line kept showing up red or black as i tweaked the placement of colour = and also tried fill. I figured out that if I set the colour outside of `aes()` instead of inside it, ggplot uses it as a fixed colour, which is how I got the line to be cyan. The line also looks jagged because there are readings at seven depths (2m to 40m) for every day, so the plot jumps between depths on the same date. Water near the surface warmed up a lot more than deep water. The warmest reading was about 21C at 2m in early September, while the 40 m sensor never got above about 13C.

###Graph 3: Mean Ocean Temperature over Deployment 13, 2024-2025

![Graph 3: Mean Ocean Temperature over Deployment 13](plot3.png)

**Deployment chosen:** Deployment 13, which ran from November 21, 2024 to May 2, 2025.

**Notes:** I added two black lines for the mean plus and minus one standard deviation around the red mean line. That took three separate `geom_line()` layers, I ended up putting the main red after the standard deviation lines because they originally covered up the main temp line no matter the colour. Since this deployment covers the winter, it's basically the opposite of Graph 2. The water started around 8C in late November and kept cooling until it bottomed out at about 1C in late February, then only warmed up slowly through April. The black lines stay pretty close to the red one most of the time because the daily variation is small, usually under 0.2, although there were a few days in early February where it went past 1C.

###Sources

Markdown Guide, Basic Syntax Cheat Sheet: https://www.markdownguide.org/cheat-sheet/
TidyTuesday GitHub repository, Coastal Ocean Temperature by Depth (2026-03-31): https://github.com/rfordatascience/tidytuesday/tree/main/data/2026/2026-03-31
Data Science Learning Community (2024). Tidy Tuesday: A weekly social data project. https://tidytues.day

