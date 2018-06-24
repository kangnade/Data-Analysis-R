# install.packages("tidyverse")
setwd("C:/Users/nade/Desktop/Data Analysis R")

### LOAD PACKAGE ###
library(tidyverse)

### Chapter 3 Data Transformation with dplyr
# LOAD DATA 
flights <- nycflights13::flights

### dplyr basics
# pick observations by using filter()
# reorder the rows arrange()
# pick variables by select()
# create new variables with functions of existing variables by mutate()
# collapse many values down to a single summary by summarize()

# These can all be used in conjunction with group_by() which changes the scope
# of each function from operating on the entire dataset to operating on it
# group by group

# data frame -> verbs of transformation -> new data frame

# filter(data frame, arg1, arg2, ...)
filter(flights, month == 1, day == 1)

# Comparisons, same like Java's expressions
# Logical Operators: !x, &, |, or()

filter(flights, month == 11 | month == 12)
# shorthand for for this is:
# x %in% y. This will select every row ehere x is one of the values in y

# Exercises
# 1. Find all flights that:
# a. Had an arrival delay of two or more hours
View(flights)
?flights
filter(flights, arr_delay > 120) # because arr_delay is in minutes

# b. Flew to Houston (IAH or HOU)
iahhou <- filter(flights, dest %in% c("IAH", "HOU"))
View(iahhou)

# c. Were operated by United, American, or Delta
uad <- filter(flights, carrier %in% c("UA", "AA", "DL"))
View(uad)

# d. Departed in summer (July, August, September)
summer <- filter(flights, month %in% c(7,8,9))
View(summer)

# e. Arrived more than two hours late, but didn't leave late
questionE <- filter(flights, arr_delay > 120 & dep_delay <= 0)
View(questionE)

# f. Were delayed by at least an hour, but made up over 30 minutes in flight
# the absolute value between arr_time and sched_arr_time should be less than 30
delayMadeup <- filter(flights, dep_delay > 60 & abs(arr_time - sched_arr_time) < 30)
View(delayMadeup)

# g. Departed between midnight and 6 a.m. inclusive
midnight6 <- filter(flights, dep_time >= 0 & dep_time <= 600) # 0 is midnight and 600 is 6 am
View(midnight6)


