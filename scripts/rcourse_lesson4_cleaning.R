setwd("C:/Users/nade/Desktop/Data Analysis R")
# 1. Series: Is a given species more or less likely to 
# become extinct in "Star Trek: The Original Series" 
# or "Star Trek: The Next Generation?

# 2. Alignment: Is a given species more or less likely to become 
# extinct if it is a friend or foe of the Enterprise (the main 
# starship on "Star Trek")?

# 3. Series x Alignment: Is there an interaction between these variables?

# install.packages("purrr")

### LOAD PACKAGES ###
library(dplyr)
library(purrr)

# We have three data files, and we want to read them at the same time
# and then combine them into one data file
# As a result, we need to use the purrr library
# purrr allows to read multiple files with list.files() method
# then perform the same action on each file with map() method
# then use reduce() method to combine all of them into one data frame
# read.table() assumes all files have the same number of columns and same name of columns
# "na.strings = c("", NA)" empty cells are named NA

### READ IN DATA ###
data = list.files(path = "data/rcourse4", full.names = T) %>%
  map(read.table, header = T, sep = "\t", na.strings = c("", NA)) %>%
  reduce(rbind)

# note I built a new folder called rcourse4 in the path, because all the data
# from lesson1 to lesson4 are mixed together, the original Page's code won't work
# because lesson1,2,3's data frames will be read as well, thus column numbers won't
# match

### 1. First, we only want to look at data from "The Original Series" and 
# "The Next Generation", so we're going to drop any data from "The Animated Series"
# The function factor is used to encode a vector as a factor (the terms 'category' 
# and 'enumerated type' are also used for factors).

### CLEAN DATA ###

# Currently there is a column called "conservation", which is coded for the 
# likelihood of a species becoming extinct. The codings are: 1) LC - least concern, 
# 2) NT - near threatened, 3) VU - vulnerable, 4) EN - endangered, 5) CR - critically 
# endangered, 6) EW - extinct in the wild, and 7) EX - extinct. If you look at the data 
# you'll see that most species have the classification of "LC", so for our analysis 
# we're going to look at "LC" species versus all other species as our dependent variable. 

# First we're going to filter out any data where "conservation" is an "NA"
# We can do this with the handy "!is.na()" call. Recall that an "!" means "is not" 
# so what we're saying is "if it's not an "NA" keep it", this was why we wanted 
# to make sure empty cells were read in as "NA"s earlier

# Next we'll make a new column called "extinct" for our logistic regression 
# using the "mutate()" call, where an "LC" species gets a "0", not likely to 
# become extinct, and all other species a "1", for possible to become extinct

# There's still one more thing we need to do in our cleaning script. 
# The data reports all species that appear or are discussed in a given episode. 
# As a result, some species occur more than others if they are in several episodes. 
# We don't want to bias our data towards species that appear on the show a lot, 
# so we're only going to include each species once per series. To do this we'll 
# do a "group_by()" call including "series", "alignment", and "alien", we then 
# do an "arrange()" call to order the data by episode number, and finally 
# we use a "filter()" call with "row_number()" to pull out only the first row, 
# or the first occurrence of a given species within our other variables. 
# For a more detailed explanation of the code watch the video above. 
# The last line ungroups our data.

data_clean = data %>%
  filter(series != "tas") %>%
  mutate(series = factor(series)) %>%
  filter(alignment == "foe" | alignment == "friend") %>%
  mutate(alignment = factor(alignment)) %>%
  filter(!is.na(conservation)) %>%
  mutate(extinct = ifelse(conservation == "LC", 0, 1)) %>%
  group_by(series, alignment, alien) %>%
  arrange(episode) %>%
  filter(row_number() == 1) %>%
  ungroup()

### DONE ###


