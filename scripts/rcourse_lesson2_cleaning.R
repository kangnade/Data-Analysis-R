setwd("C:/Users/nade/Desktop/Data Analysis R")
### LOAD LIBRARY ###
library(dplyr)
data = read.table("data/rcourse_lesson2_data.txt", header = T, sep = "\t")

### to check the data and take a glimpse ###
head(data)

### We will be focusing on one name, at your own choice ###

### CLEAN DATA ###
data_clean <- data %>% filter(name == "Nicole") %>% mutate(name = factor(name))
# mutate() makes a new column or changes existing one
# in our case, we are changing the existing column "name" to have it
# recreate the levels to only include the ones after our filter() call
# that's what the factor() function does here
# to double check the data_clean
xtabs(~name, data_clean)

### Further more, we are only looking at data from 1901 to 2000 ###
data_clean <- data %>% filter(name == "Nicole") %>% 
  mutate(name = factor(name)) %>%
  filter(year > 1900) %>%
  filter(year <= 2000) %>%
  # adding log transform
  # apply mutate() to make new columns
  # we added loge and log10
  mutate(prop_loge = log(prop)) %>%
  mutate(prop_log10 = log10(prop))

### to confirm the year range ###
max(data_clean$year)
min(data_clean$year)
### data year ranges from 1937 to 2000 in Nicole's case ###





