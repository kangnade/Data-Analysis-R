# install.packages("tidyverse")
setwd("C:/Users/nade/Desktop/Data Analysis R")

### LOAD PACKAGE ###
library(tidyverse)

### Chapter 3 Exploratory Data Analysis
# Visualizing Distrinution
# For categorical values we use bar plot
ggplot(data = diamonds) +
  geom_bar(mapping = aes(x = cut))

# Compute the height of the bars manually
diamonds %>%
  count(cut)

# For continuous variables we use histogram
ggplot(data = diamonds) +
  geom_histogram(mapping = aes(x = carat), binwidth = 0.5)

# Compute manually
diamonds %>%
  count(cut_width(carat, 0.5))
# Need to set the width because histogram separates x-axis into equally spaced bins

# If we only want to check the diamonds within three carats
smaller <- diamonds %>%
  filter(carat < 3)

ggplot(data = smaller, mapping = aes(x = carat)) +
  geom_histogram(binwidth = 0.1)

# If you want to overlay many histograms in the same plot, use geom_freqpoly
ggplot(data = smaller, mapping = aes(x = carat, color = cut)) +
  geom_freqpoly(binwidth = 0.1)

# in general
ggplot(data = smaller, mapping = aes(x = carat)) +
  geom_histogram(binwidth = 0.01)

# The only evidence of outliers is the unusually wide limites on the y-axis
ggplot(diamonds) +
  geom_histogram(mapping = aes(x=y), binwidth = 0.5)

# To see outliers, we can zoom in to small values of the y-axis with coord_cartesian()
ggplot(diamonds) +
  geom_histogram(mapping = aes(x = y), binwidth = 0.5) +
  coord_cartesian(ylim = c(0,50))

# Exercises
# 2. Explore the distribution of price. Do you discover anything unusual or surprising?
# Think careful about the bin width and make sure you try a wide range of values
ggplot(data = diamonds, mapping = aes(x = price)) +
  geom_histogram(binwidth = 0.5)
ggplot(data = diamonds, mapping = aes(x = price)) +
  geom_histogram(binwidth = 1)
ggplot(data = diamonds, mapping = aes(x = price)) +
  geom_histogram(binwidth = 5)
ggplot(data = diamonds, mapping = aes(x = price)) +
  geom_histogram(binwidth = 10)
ggplot(data = diamonds, mapping = aes(x = price)) +
  geom_histogram(binwidth = 100)
ggplot(data = diamonds, mapping = aes(x = price)) +
  geom_histogram(binwidth = 1000)
# manually calculate with width 100
diamonds %>%
  count(cut_width(price, 100))

# 2. How many diamonds are 0.99 carat? How many are 1 carat? What do you think is the cause of the
# difference?
ninetynine <- diamonds %>%
  filter(carat == 0.99) %>%
  summarize(ninetyninecarat =  n())
ninetynine
# there are 23 diamonds with 0.99 carat
one <- diamonds %>%
  filter(carat == 1)
one %>%
  summarize(count = n())
# But there are 1558 diamonds with 1 carat
# Interesting, not sure why because I am not quite familiar with diamonds

# 4. Compare and contrast corrd_cartesian() versus xlim() or ylim() when
# zooming in on a histogram. What happens if you leave binwidth unset? What
# happens if you try to zoom so only half a bar shows.
q4test <- ggplot(data = diamonds, mapping = aes(x = price)) +
  geom_histogram(binwidth = 100)
# zoom in from y-axis
q4test1 <- ggplot(data = diamonds, mapping = aes(x = price)) +
  geom_histogram(binwidth = 100) +
  coord_cartesian(ylim = c(0, 200))
q4test1 # It shows only from 0 to 200 on y-axis
# zoom in from x-axis
q4test2 <- ggplot(data = diamonds, mapping = aes(x = price)) +
  geom_histogram(binwidth = 100) +
  coord_cartesian(xlim = c(0, 10000))
q4test2 # It shows only from 0 to 10000 on x-axis
# leaving binwidth unset
q4test3 <- ggplot(data = diamonds, mapping = aes(x = price)) +
  geom_histogram()
q4test3 # If you leave the binwidth unset, ggplot2 will set a default one for you
# otherwise, the smallest binwidth for diamonds price taks a long time for R to process

# Missing Values
# To deal with unusual or strange values, the best approach is to
# replace it with NA 
diamonds2 <- diamonds %>%
  mutate(y = ifelse(y < 3 | y > 20, NA, y))
# plot based on x and y
ggplot(data = diamonds2, mapping = aes(x = x, y = y)) +
  geom_point()
# to supress the warning
ggplot(data = diamonds2, mapping = aes(x = x, y = y)) +
  geom_point(na.rm = TRUE)

# Exercises
# 1. What happens to missing values in a histogram? What happens to missing values in a bar chart?
# Why is there a difference?
? histogram
? barplot
# 2. What does na.rm = TRUE do in mean() and sum()
# It changes the mean value and mean is greater if na.rm = TRUE, because the sum of total obs is decreased
# while the sum values do not change

# Covariation
# A Categorical and Continuous Variable
# sometimes it is not good to simply use freqpoly because smaller ones are hard to see
ggplot(diamonds) +
  geom_bar(mapping = aes(x = cut))

# To make comparision easier, we swap what is displayed on y-axis.
# Instead of count, we use density, which is the counter standardized so that the area
# under each frequency polygon is one
ggplot(data = diamonds,mapping = aes(x = price, y = ..density..)) +
  geom_freqpoly(mapping = aes(color = cut), binwidth = 500)
# Low quality diamonds have the highest price

# Another way to interpret is to display continuous variable broken down by a categorical
# variable----->>> boxplot
diamonds_boxplot <- ggplot(data = diamonds, mapping = aes(x = cut, y = price)) +
  geom_boxplot(mapping = aes(color = cut)) +
  ggtitle(expression(atop("Diamonds Prices Separated", "by Various Cuts"))) +
  xlab("Cut (Quality") +
  ylab("Price") +
  theme(plot.title = element_text(hjust = 0.5), text = element_text(size = 14),
        title = element_text(size = 16))
png("r_wickham/figures/chapter5/r_for_data_science_wickham_textbook_diamonds_cut_boxplot.png")
diamonds_boxplot
pdf("r_wickham/figures/chapter5/r_for_data_science_wickham_textbook_diamonds_cut_boxplot.pdf")
diamonds_boxplot
dev.off()

# cut is an ordered factor, fair is worse than good, and is worse than very good and so on
# Many categorical variables do not have such an intrinsic order
# Take the mpg dataset as an example
mpg_boxplot <- ggplot(data = mpg, mapping = aes(x = class, y = hwy)) +
  geom_boxplot(mapping = aes(color = class)) +
  ggtitle(expression(atop("Cars Highway Miles Per Gallon", "by Various Classes"))) +
  xlab("Class") +
  ylab("Highway Miles Per Gallon") +
  theme(plot.title = element_text(hjust = 0.5), text = element_text(size = 10),
        title = element_text(size = 14))
png("r_wickham/figures/chapter5/r_for_data_science_wickham_textbook_mpg_class_boxplot.png")
mpg_boxplot
pdf("r_wickham/figures/chapter5/r_for_data_science_wickham_textbook_mpg_class_boxplot.pdf")
mpg_boxplot
dev.off()











