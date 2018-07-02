### Chapter 13 Date and Times with lubridate ###

### LOAD PACKAGES ###
library(tidyverse)
library(lubridate)

### CONTENT ###

# Creating Date/Times
# To get current date or date-time, use today() or now()
today()
now()

# Other sources of date and time:
# 1. string
# 2. individual date-time component
# 3. existing date/time object

# From Strings
# We can use hms from P134, but also from lubridate
# To use them, identify the order in which year, month, 
# and day appear in your dates, then arrange “y”, “m”, and “d” in the same order. 
# That gives you the name of the lubridate function that will parse your date. 
ymd("2018-07-02")
mdy("January 31st, 2018")
dmy("31-Jan-2018")
# These functions also take unquoted numbers
ymd(20181204)
ymd_hms("20181204 20:11:39") # can take unquoted date
ymd_hms("2019/12/04 20:12:12")

# You can also force the creation of a date-time from a date by supplying a time zone
ymd(20181204, tz = "UTC")

# From Individual Components
flights <- nycflights13::flights
flights %>% select(
  year, month, day, hour, minute
)

# To create from this sort of input, use make_datetime() for date-times
flights %>%
  select(year, month, day, hour, minute) %>%
  mutate(departure = make_datetime(year, month, day, hour, minute))

# Let's do the same thing for each of the four time columns in flights
# The times are represented in a slightly odd format, so we use modulus arithmetic
# to pull out the hour and minute components.
# Once I've created the date-time variables, I focus on the variables we'll explore
# for the rest of the chapter
make_datetime_100 <- function(year, month, day, time){
  make_datetime(year, month, day, time%/%100, time%%100)
}

flights_dt <- flights %>%
  filter(!is.na(dep_time), !is.na(arr_time)) %>%
  mutate(dep_time = make_datetime_100(year, month, day, dep_time),
         arr_time = make_datetime_100(year, month, day, arr_time),
         sched_dep_time = make_datetime_100(year, month, day, sched_dep_time),
         sched_arr_time = make_datetime_100(year, month, day, sched_arr_time)) %>%
  select(origin, dest, ends_with("delay"), ends_with("time"))
  
flights_dt

# With this data, I can visualize the distribution of departure times across the year
flights_dt %>%
  ggplot(aes(dep_time)) +
  geom_freqpoly(binwidth = 86400) # 86400 seconds = 1 day

# Or within a single day:
flights_dt %>%
  filter(dep_time < ymd(20130102)) %>%
  ggplot(aes(dep_time)) +
  geom_freqpoly(binwidth = 600) # 600 = 10 min

