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

# 2. Another dplyr filtering helper is between(). What does it do? Can you use it to simplify
# the code needed to answer the previous challenges?
?between
# shortcut for x >= left and x <= right
# Using 1.g. as an example
midnight6_2 <- filter(flights, between(dep_time, 0, 600))
View(midnight6_2)

# 3. How many flights have a missing dep_time? What other variables are missing?
# What might these rows represnet?
missing_dep_time <- filter(flights, is.na(dep_time))
missing_dep_time

# 4. Why is NA ^ 0 not missing? Why is NA | True not missing? Why is FALSE & NA not
# missing?
# Anything to the power of zero is 1
# Anything or True is True
# Anything ^ False is False

# Arrange Rows with arrange()
# Instead of selecting rows, arrange() changes order
# e.g.
arrange(flights, year, month, day)
# Use desc() to reorder by a column in descending order:
arrange(flights, desc(arr_delay))
# Missing values are always sorted at the end

# Arrange Rows with arrange() Exercises

# 1. How could you use arrange() to sort all missing values to the start? (hint: use is.na())
arrange(flights, desc(is.na(dep_time))) # just put the column title in the is.na(title)

# 2. Sort flights to find the most delayed flights. Find the flights that left earliest.
arrange(flights, desc(dep_delay))
# flights left earliest
arrange(flights, dep_time)

# 3. Sort flights to find the fastest flights
arrange(flights, abs(arr_time - dep_time)) # absolute value of the difference between arr_time and dep_time

# 4. Which flights traveled the longest? Which traveled the shortest?
# Need to check the distance, shortest
shortDis <- arrange(flights, distance)
View(shortDis)
# Check the longest
longDis <- arrange(flights, desc(distance))
View(longDis)

# Select Columns with select()
# e.g.
select(flights, year, month, day)
# select all columns between year and day
select(flights, year:day)
# select all columns except those from year to day inclusive
select(flights, -(year:day))

# Also use: start_with("abc") matches names starting with abc
# ends_with(), contains(), matches, num_range("x",1:3)

# Select Exercises
# 1. Brainstorm as many ways as possible to select dep_time, dep_delay,
# arr_time, arr_delay from flights
select(flights, dep_time, dep_delay, arr_time, arr_delay)
select(flights, starts_with("dep"), starts_with("arr"))
select(flights, contains("p_d"), contains("r_t"))

# 2. What happens if you include one variable in a select call multiple times?
select(flights, day, day, day)
# it ignores the redundant ones

# 3.What does the one_of() function do? Why might it be helpful in conjunction 
# with this vector?
?one_of
vars <- c("year", "month", "day", "dep_delay", "arr_delay")
select(flights, one_of(vars))

# 4. Does the result of running the following code ?
select(flights, contains("TIME"))

# Add New Variables with mutate()
flights_sml <- select(flights, year:day, ends_with("delay"), distance, air_time)
mutate(flights_sml, gain = arr_delay - dep_delay, speed = distance/air_time*60)
# Now we can further modify
mutate(flights_sml, gain = arr_delay - dep_delay, hours = air_time/60, gain_per_hour = gain/hours)
# IF YOU ONLY WANT TO KEEP THE NEW VARIABLES, USE transmute()
transmute(flights, gain = arr_delay - dep_delay, hours = air_time/60, gain_per_hour = gain/hours)

# Grouped Summaries with sumarize() 
# summarize() collapses a data frame to a single row
summarize(flights, delay = mean(dep_delay, na.rm = TRUE))
# summarize() is not terribly useful unless we pair it with group_by()
by_day <- group_by(flights, year, month, day)
summarize(by_day, delay = mean(dep_delay, na.rm = TRUE))

# THE REST OF THE NOTES ARE INCLUDED IN THE dplyr tutorial practice