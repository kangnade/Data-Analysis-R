setwd("C:/Users/nade/Desktop/Data Analysis R")
### QUESTIONS ###
# 1. Full season: did the Giants win more games before or after the All-star break?
# 2. Buster Posey: Are the Giants more likely to win in games where Buster Posey
# was walked at least once?

### LOAD PACKAGES ###
library(dplyr)

### READ IN DATA ###
# READ FULL SEASON DATA
data <- read.table("data/rcourse_lesson3_data.txt", header = T, sep = "\t")

# READ PLAYER BUSTER POSEY DATA 
data_posey <- read.table("data/rcourse_lesson3_data_posey.txt", header = T, sep = "\t")

### CLEANING DATA ###
# We want columns that refer to the Giants and their opponents
# We start making a column for whether Giants were the home or visiting team
# To make this column, we need mutate() method and ifelse() method
# Giant's home stadium is "SFN", this is the condition
# We write either home or visitor

### Add column to full season data to make data set specific to the Giants
data_clean <- data %>% 
  mutate(home_visitor = ifelse(home_team == "SFN", "home","visitor")) %>%
  # Since we asked whether time was before or after All-Star break
  # we need to make a column whether a game was before or after All-Star break
  # the date of All-Star was July 13, 2010, data has YYYYMMDD format
  # We use another mutate() and ifelse() methods
  mutate(allstar_break = ifelse(date < 20100713, "before", "after")) %>%
  # The last column we make is for the dependent variable for our logistic regression
  # A series of ifelse() statements to determine:
  # 1. The Giants were home team or not
  # 2. The home team or the visitor scored more runs
  # If the first is true, Giants home and scored more, we use 1
  # If the Giants were away, and home team scored fewer, we use also 1
  # Any other situation will be given 0
  mutate(win = ifelse(home_team=="SFN" & home_score > visitor_score, 1, 
                       ifelse(visitor_team=="SFN" & home_score < visitor_score, 1, 0))) %>%
  # Make columns for Giants stats
  mutate(giants_hits = ifelse(home_team=="SFN", home_hits, visitor_hits)) %>%
  mutate(giants_pitchers_used = ifelse(home_team=="SFN", home_pitchers_used, visitor_pitchers_used)) %>%
  mutate(giants_errors = ifelse(home_team=="SFN", home_errors, visitor_errors)) %>%
  # Make columns for other team stats
  mutate(other_hits = ifelse(home_team != "SFN", home_hits, visitor_hits)) %>%
  mutate(other_pitchers_used = ifelse(home_team != "SFN", home_pitchers_used, visitor_pitchers_used)) %>%
  mutate(other_errors = ifelse(home_team != "SFN", home_errors, visitor_errors)) %>%
  # Make a column for game number
  arrange(date) %>%
  mutate(game_number = row_number())


### Combine cleaned full-season data with Posey's
data_posey_clean <- data_posey %>%
  # Join with full season data
  inner_join(data_clean) %>%
  # Make a column for if walked or not
  mutate(walked = ifelse(walks > 0, "yes", "no"))

# Check data
dim(data_posey)
dim(data_posey_clean)

