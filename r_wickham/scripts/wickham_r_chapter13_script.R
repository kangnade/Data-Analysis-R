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

# From Other Types
# You may want to switch between a date-time and a date
# That's the job of as_datetime() and as_date()
as_datetime(today())
as_date(now())

# Sometimes you get date/times as numeric offsets from the Unix Epoch. If in seconds, use as_datetime()
# if in days use as_date()
as_datetime(60 * 60 * 10)
as_date(365 * 10 + 2)

# Exercises
# 1. What happens if you parse a string that contains invalid dates?
ymd(c(20101010, "banana"))
# "2010-10-10" NA          
# Warning message:
#   1 failed to parse. 

# 2. What does the tzone argument to today() do? Why is it important?
?today
# a character vector specifying which time zone you would like to find the current date of. 
# tzone defaults to the system time zone set on your computer.

# 3. Use the appropriate lubridate function to parse each of the following dates;
d1 <- "January 1, 2010"
d2 <- "2015-Mar-07"
d3 <- "06-Jun-2017"
d4 <- c("August 19 (2015)", "July 1 (2015)")
d5 <- "12/30/14" # Dec 30, 2014
mdy(d1)
ymd(d2)
dmy(d3)
mdy(d4)
mdy(d5)

# Date-Time Components
# Focus on accessor functions that let you get and set individual components
# You can pull out individual part of the date with accessor functions year(), month(),mday()(day of month)
# yday() (day of the year), wday(day of the week), hour(), minute(), and second()
datetime <- ymd_hms("20160708 12:34:56")
datetime
year(datetime)
month(datetime)
mday(datetime)
yday(datetime)
wday(datetime)
# For month() and wday() you can set label = TRUE to return the abbreviated name of the month or day of the week.
# Set abbr = FALSE to return to full name.
month(datetime, label = TRUE)
wday(datetime, label = TRUE, abbr = FALSE)
# If you do not use the label, it returns the number

# We can use wday() to see that more flights depart during the week than on the weekend
flights_dt %>%
  mutate(wday = wday(dep_time, label = TRUE)) %>%
  ggplot(aes(x = wday)) +
  geom_bar()

# There is an interesting pattern if we look at the average departure delay by minute within the hour
# It looks like flights leaving 20 - 30 and 50 - 60 have much lower delays than the rest of the hour
flights_dt %>%
  mutate(minute = minute(dep_time)) %>%
  group_by(minute) %>%
  summarise(avg_delay = mean(arr_delay, na.rm = TRUE),
            n = n()) %>%
  ggplot(aes(minute, avg_delay)) + 
  geom_line()

# But if we look at scheduled depature time, we won't see such a strong pattern
sched_dep <- flights_dt %>%
  mutate(minute = minute(sched_dep_time)) %>%
  group_by(minute) %>%
  summarize(avg_delay = mean(arr_delay, na.rm = TRUE),
            n = n())
ggplot(sched_dep, aes(minute, avg_delay)) +
  geom_line()

# So why do we see that pattern? Data collected by humans, there is a strong bias toward
# flights leaving at "nice" departure times
ggplot(sched_dep, aes(minute, n)) +
  geom_line()

# Rounding
# Round the date to a nearby unit of time, with floor_date(), round_date(), and ceiling_date()
# Each ceiling_date() function takes a vector of dates to adjust and then the name of the unite to
# round down(floor), round up(ceiling), or round to.
# Example:
flights_dt %>%
  count(week = floor_date(dep_time, "week")) %>%
  ggplot(aes(week, n)) +
  geom_line()

# Setting Components
# You can also use each accessor function to set the components of date/time
datetime <- ymd_hms("20160708 12:34:56")
datetime
year(datetime) <- 2020
datetime
month(datetime) <- 12
datetime
day(datetime) <- 04
datetime
# Alternatively, rather than modifying in place, you can create a new date-time with update()
update(datetime, year = 2020, month = 12, mday = 4, hour = 0)
# If your values are too big, they will roll over
ymd(20150201) %>%
  update(mday = 31)

# You can use update() to show the distribution of flights across the course of the day for every day of the year
flights_dt %>%
  mutate(dep_hour = update(dep_time, yday = 1)) %>%
  ggplot(aes(dep_hour)) +
  geom_freqpoly(binwidth = 300)

# Exercises
# 1. How does the distribution of flights times within a day change over the course of the year?
# We change the time into 2400 hours, and make a factor of month
flights_dt %>%
  mutate(time = hour(dep_time) * 100 + minute(dep_time),
         month_number = as.factor(month(dep_time))) %>%
  ggplot(aes(x = time, color = month_number, group = month_number)) +
  geom_freqpoly(binwidth = 100)
# we can also use ..density.. to normalize the count
flights_dt %>%
  mutate(time = hour(dep_time) * 100 + minute(dep_time),
         month_number = as.factor(month(dep_time))) %>%
  ggplot(aes(x = time, y = ..density.., color = month_number, group = month_number)) +
  geom_freqpoly(binwidth = 100)

# 2. Compare dep_time, sched_dep_time, and dep_delay. Are they consistent?
# If consistent, dep_time is the sum of the rest two variables
?flights
flights_dt %>%
  mutate(dep_time_ = sched_dep_time + dep_delay) %>%
  filter(dep_time_ != dep_time) %>%
  select(dep_time_, dep_time, sched_dep_time, dep_delay)
# There is problems here. The code needs to check if the departure time is less than the scheduled departure time
# Adding delay time is better

# 3. Compare air_time with the duration between the departure and arrival. 
# Explain your findings. (Hint: consider the location of the airport.)
flights_dt %>%
  mutate(flight_time = as.numeric(arr_time - dep_time),
         air_time_minutes = air_time,
         difference = flight_time - air_time_minutes) %>%
  select(origin, dest, flight_time, air_time_minutes, difference)

# 4. How does the average delay time change over the course of a day? Should you use dep_time or sched_dep_time?
# Why?
# Use sched_dep_time, dep_time coUld be delayed and thus biased
flights_dt %>%
  mutate(dep_hour = hour(sched_dep_time)) %>%
  group_by(dep_hour) %>%
  summarise(dep_delay = mean(dep_delay)) %>%
  ggplot(aes(x = dep_hour, y = dep_delay)) +
  geom_point() +
  geom_smooth()

# 5. On what day of the week should you leave if you want to minimize the chance of a delay?
flights_dt %>%
  mutate(dayofweek = wday(sched_dep_time, label = TRUE, abbr = FALSE)) %>%
  group_by(dayofweek) %>%
  summarise(dep_delay = mean(dep_delay, na.rm =TRUE),
            arr_delay = mean(arr_delay, na.rm =TRUE))
# 6. What makes the distribution of diamonds$carat and flights$ sched_dep_time similar?
ggplot(diamonds, aes(x = carat %% 1 * 100)) +
  geom_histogram(binwidth = 1)
# above is diamonds carat plot, and below is sched_dep_time plot
ggplot(flights_dt, aes(x = minute(sched_dep_time))) +
  geom_histogram(binwidth = 1)

# 6. Confirm my hypothesis that the early departures of flights in minutes 20-30 and 50-60 are caused by scheduled
# flights that leave early. Hint: create a binary variable that tells you whether or not a flight was delayed.
flights_dt %>%
  mutate(early = dep_delay < 0,
         minute = minute(sched_dep_time) %% 10) %>%
  group_by(minute) %>%
  summarise(early = mean(early)) %>%
  ggplot(aes(x = minute, y = early)) +
  geom_point()

# Time Spans
# Durations: an exact number of seconds
# Periods: human units like weeks and months
# Intervals: starting and ending points

# Durations:
# How old is Nade?
n_age <- today() - ymd(19901204)
n_age
# But this results in the number of days, so lubridate provides:
as.duration(n_age)
# Durations come with a bunch of convenient constructors:
dseconds(15)
dminutes(10)
dhours(c(12,24))
ddays(0:5)
dweeks(3)
dyears(1)

# Durations always record the time span in seconds
# You can add and multiply with durations
2 * dyears(1)
dyears(1) + dweeks(15) + ddays(13)
# You can subtract durations or add from days
tomorrow <- today() + ddays(1)
tomorrow
last_year <- today() - dyears(1)
last_year

# However, since durations represent an exact number of seconds,
# sometimes, you might get an unexpected result:
one_pm <- ymd_hms("20180312 13:00:00",
                  tz = "America/New York")
one_pm
one_pm + ddays(1)

# Periods
# lubridate provides periods. Periods are time spans but do not have a fixed length in seconds
# instead, they work with uhman times, like days and months
one_pm
one_pm + days(1)

# Like durations, periods can be created with a number of friendly constructor functions
seconds(15)
minutes(10)
hours(c(12,24))
days(7)
months(1:6)
weeks(3)
years(1)

# You can add and multiply periods
10 * (months(6) + days(1))
days(50) + hours(25) + minutes(2)

# Add them to dates. Compared to durations, periods are more likely to do what you expect:
# a leap year
ymd(20160101) + dyears(1)
ymd(20160101) + years(1)

# Daylight savings time
one_pm + ddays(1)
one_pm + days(1)

# Let's use periods to fix an oddity related to our flights dates.
# Some planes appear to have arrived at their dest before they departured from NYC
flights_dt %>%
  filter(arr_time < dep_time)
# These are ocernight flights, we used the same date info for both departure and arrival times
# but these flights arrived the following day, we can fix it by adding days(1) to the arrival
# time of each overnight flight
flights_dt %>%
  mutate(overnight = arr_time < dep_time,
         arr_time = arr_time + days(overnight * 1),
         sched_arr_time = sched_arr_time + days(overnight * 1))
# use overnight * 1 is because TRUE * 1 = 1, while FALSE *1 = 0
TRUE * 1
FALSE * 1

# Intervals
dyears(1) / ddays(365) # this is because durations is in seconds
years(1) / days(1) # gives an estimate with 2015 has 365 while 2016 has 366
# If you want an accurate estimate, you'll have to use an interval
# An interval is a duration with a starting point, that makes it precise
# so you can determine exactly how long it is
next_year <- today() + years(1)
next_year
(today() %--% next_year) / ddays(1)

# To find out how many periods fall into an interval, you need to use integer division
(today() %--% next_year) %/% days(1)
today() %--% next_year
today() %--% today()
# %--% is a duration operator

# Exercises
# 1. Why is there months() but no dmonths()?
# different months have different number of days

# 2. Explain days(overnight * 1) how does it work?
# use overnight * 1 is because TRUE * 1 = 1, while FALSE *1 = 0
TRUE * 1
FALSE * 1

# 3. Create a vector of dates giving the first day of every month in 2015, Create a vector
# of dates giving the first day of every month in the current year
# do calculation with months():
ymd(20150101) + months(1)
ymd(20150101) + months(1:2)
# So to get all full months in 2015, just add months(0:11)
ymd(20150101) + months(0:11)

# to get this year:
today()
floor_date(today(), unit = "year")
# the result is 2018-01-01, so we add months(0:11)
floor_date(today(), unit = "year") + months(0:11)

# 4. Write a function that given your birthday (as a date), returns how old you are in years.
age <- function(birthday){
  (birthday %--%today()) %/% years(1)
}
age(ymd(19901204))

# 5. Why can’t (today() %--% (today() + years(1)) / months(1) work?
(today() %--% (today() + years(1))) %/% months(1)
(today() %--% (today() + years(1))) / months(1)  
# it is because it doesn't work with negative periods?
# it works here:
next_year <- today() + years(1)
next_year
today() %--% next_year %/% months(1)

# Time Zones
# Your own time zone:
Sys.timezone()
# Let's see the complete list of OlsonNames()
length(OlsonNames())
head(OlsonNames())
