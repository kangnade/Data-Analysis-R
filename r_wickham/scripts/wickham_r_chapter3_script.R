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
# Combining Multiple Operations with the pipe

by_dest <- group_by(flights, dest)
delay <- summarize(by_dest, count = n(), 
                   dist = mean(distance, na.rm = TRUE),
                   delay = mean(arr_delay, na.rm = TRUE))
delay <- filter(delay, count > 20, dest != "HNL")
ggplot(data = delay, mapping = aes(x = dist, y = delay)) +
  geom_point(aes(size = count), alpha = 1/3) +
  geom_smooth(se = FALSE)

# There is another way to tackle the same pronlem with pipe
delays <- flights %>%
  group_by(dest) %>%
  summarize(count = n(),
            dist = mean(distance, na.rm = TRUE),
            delay = mean(arr_delay, na.rm = TRUE)) %>%
  filter(count > 20, dest != "HNL")
ggplot(data = delays, mapping = aes(x = dist, y = delay)) +
  geom_point(aes(size = count), alpha = 1/3) +
  geom_smooth(se = FALSE)

# removing NA
flights %>% group_by(year, month, day) %>%
  summarize(mean = mean(dep_delay, na.rm = TRUE))

# we canh also tackle by removing cancelled flights
not_cancelled <- flights %>% filter(!is.na(dep_delay), !is.na(arr_delay)) 
not_cancelled %>% group_by(year, month, day) %>%
  summarize(mean = mean(dep_delay))

# Counts
# whenever we do aggregation, it is always good to include a count n()
# so that we know we are not drawing conclusions on very small amounts of data
delays <- not_cancelled %>%
  group_by(tailnum) %>%
  summarize(delay = mean(arr_delay))

ggplot(data = delays, mapping = aes(x = delay)) +
  geom_freqpoly(bindwidth = 10)

# If we draw a scatterplot of number of flights versus average delay:
delays <- not_cancelled %>%
  group_by(tailnum) %>%
  summarize(delay = mean(arr_delay, na.rm = TRUE),
            n = n())
ggplot(data = delays, mapping = aes(x = n, y = delay)) +
  geom_point(alpha = 1/10)

delays %>%
  filter(n > 25) %>%
  ggplot(mapping = aes(x = n, y = delay)) +
  geom_point(alpha = 1/10)

# How the average performance of batters in baseball is related to the number
# of times they're at bat
# Convert to a tibble so it prints nicely
batting <- as_tibble(Lahman::Batting)
batting

batters <- batting %>%
  group_by(playerID) %>%
  summarize(
    ba = sum(H, na.rm = TRUE) / sum(AB, na.rm = TRUE),
    ab = sum(AB, na.rm = TRUE))
batting
batters

batters %>%
  filter(ab > 100) %>%
  ggplot(mapping = aes(x = ab, y = ba)) +
  geom_point() +
  geom_smooth(se = FALSE)

# sort desc(ba), the people with the best batting average are clearly lucky not skilled
batters %>%
  arrange(desc(ba))

# Useful Summary Functions
# mean() median() 
# subsetting will be discussed on page 304
not_cancelled %>%
  group_by(year, month, day) %>%
  summarize(# average delay
    avg_delay1 = mean(arr_delay),
    # average positive delay)
    avg_delay2 = mean(arr_delay[arr_delay > 0]))

# Measure of spread, sd(x), IQR(x), mad(x)
# IQR interquantile range
# mad is median absolute deviation is robust equivalent that may be more useful for outliers

# Why is distance to some destinations more variable
# than to others?
not_cancelled %>%
  group_by(dest) %>%
  summarize(distance_sd = sd(distance)) %>%
  arrange(desc(distance_sd))

# When do the first and last flights leave each day?
not_cancelled %>%
  group_by(year, month, day) %>%
  summarise(first = min(dep_time),
            last = max(dep_time))

# Measure of position first(x), nth(x, 2), last(x)
not_cancelled %>%
  group_by(year, month, day) %>%
  summarize(first_dep = first(dep_time),
            last_dep = last(dep_time))

# These functions are complementary to filtering on ranks
# Filterding gives you all variables with each obs in a separte row:

not_cancelled %>%
  group_by(year, month, day) %>%
  mutate(r = min_rank(desc(dep_time))) %>%
  filter(r %in% range(r))

# You've seen n(), it takes no argument but returns the size of the current group
# To count the number of non-missing values, use sum(!is.na(x))
# To count the number of distinct/unique values, use n_distinct(x)

# Which destinations have the most carriers?

not_cancelled %>%
  group_by(dest) %>%
  summarize(carriers = n_distinct(carrier)) %>%
  arrange(desc(carriers))

# Counts are so useful that dplyr provides a simple helper
not_cancelled %>%
  count(dest)

# You can optionally provide a weight variable.
# You could use this to count the totla number of miles a plane flew
not_cancelled %>%
  count(tailnum, wt = distance)

# Counts and proportions of logical values sum(x >10), mean(y == 0)
# When used with numeric functions, TRUE is converted to 1, and FALSE is 0
# This makes sum() and mean() very useful

# How many flights left before 5 am?
not_cancelled %>%
  group_by(year, month, day) %>%
  summarize(n_early = sum(dep_time < 500))


# What proportion of flights are delayedby more than an hour?
not_cancelled %>%
  group_by(year, month, day) %>%
  summarize(hour_perc = mean(arr_delay > 60))

# Grouping by Multiple Variables
daily <- group_by(flights, year, month, day)
daily
(per_day <- summarize(daily, flights = n()))
(per_month <- summarize(per_day, flights = sum(flights)))
(per_year <- summarize(per_month, flights = sum(flights)))

# Ungrouping
# If you need to remove grouping, and return to operations on ungrouped data
# use ungroup():
daily %>%
  ungroup %>%
  summarize(flights = n()) # all flights

# Grouped Mutates (and Filters)
# Grouping is most useful in conjunction with summarize(), but you
# can also do convenient operations with mutate() and filter()

# Find the worst members of each group
flights_sml %>%
  group_by(year, month, day) %>%
  filter(rank(desc(arr_delay)) < 10)

# Find all groups bigger than a threshold
popular_dests <- flights %>%
  group_by(dest) %>%
  filter(n() > 365)
popular_dests

# Standardize to compute per group metrics
popular_dests %>%
  filter(arr_delay > 0) %>%
  mutate(prop_delay = arr_delay / sum(arr_delay)) %>%
  select(year:day, dest, arr_delay, prop_delay)













































