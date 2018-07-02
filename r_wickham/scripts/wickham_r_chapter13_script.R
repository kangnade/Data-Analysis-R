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
