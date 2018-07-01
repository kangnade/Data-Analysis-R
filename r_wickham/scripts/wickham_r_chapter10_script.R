### Chapter 10 Relational Data with dplyr ###

### LOAD PACKAGES ###
library(tidyverse)
library(nycflights13)

### CONTENT ###
# nycflights13 contains 4 tibbles that are related to flights table in chapter 3
# airlines offers the full names of airlines 
airlines

# airports gives informationa bout each airport
airports

# planes gives information about each plane
planes

# weather gives informationa about the weather at each NYC airport for each hour
weather

# --- flights connects to planes via a single variable tailnum
# --- flights connects to airplines through the carrier varaible
# --- flights connects to airports in two ways: via the origin and dest variables
# --- flights connects to weather via origin and year, month, day, and hour

# Exercises:
# 1. Imagine you wanted to draw (approximately) the route each plane flies from its origin 
# to its destination. What variables would you need? What tables would you need to combine?

# We need origin and dest from flights table
# We also need lat and lon from airports table
# Then merge flights with airports to get origin and dest

# 2. I forgot to draw the relationship between weather and airports. 
# What is the relationship and how should it appear in the diagram?

# faa in airports matches with origin in weather

# 3. weather only contains information for the origin (NYC) airports. 
# If it contained weather records for all airports in the USA, 
# what additional relation would it define with flights?

# year, month, day, hour, origin in weather would be matched to year, month, day, hour, dest in flight

# 4. We know that some days of the year are “special”, and fewer people than usual 
# fly on them. How might you represent that data as a data frame? What would be the 
# primary keys of that table? How would it connect to the existing tables?

# Add table of special dates, key is date, use year, month, day to match flights

# Keys
# The variables used to connect each pair of tables are called keys.
# A key is a variable (or set of variables) that uniquely identifies an observation.

# A primary key uniquely identifies an observation in its own table. For example, 
# planes$tailnum is a primary key because it uniquely identifies each plane in the planes table.

# A foreign key uniquely identifies an observation in another table. 
# For example, the flights$tailnum is a foreign key because it appears in the flights table 
# where it matches each flight to a unique plane.


# Once you’ve identified the primary keys in your tables, it’s good practice to verify 
# that they do indeed uniquely identify each observation. One way to do that is to count() 
# the primary keys and look for entries where n is greater than one:

planes %>%
  count(tailnum) %>%
  filter(n > 1)

# same applies to weather table
weather %>%
  count(year, month, day, hour, origin) %>%
  filter(n > 1)

# In flights table, data plus flight or date plus tailnum are not primary keys
flights %>%
  count(year, month, day, flight) %>%
  filter(n > 1)

flights %>%
  count(year, month, day, tailnum) %>%
  filter(n > 1)

# It appears that each flight number flies more than once per day
# If a table lacks a primary key, use mutate() and two_number() to add one

# A primary key and the corresponding foreign key in another table form a relation

# Exercises
# 1. Add a surrogate key to flights
# Use arrange and then use row_number() as flight_id
flights %>%
  arrange(year, month, day, sched_dep_time, carrier, flight) %>%
  mutate(flight_id = row_number()) %>%
  glimpse()

# 2. Identify the keys in the following datasets:
# 2-1. Lahman::Batting
Lahman::Batting
# Check playerID year ID and stint
Lahman::Batting %>%
  count(playerID, yearID, stint) %>%
  filter(n > 1)

# 2-2 babynames::babynames
# No data

# 2-3 nasaweather::atmos
# No data

# 2-4 fueleconomy:vehicles
# No data

# 2-5 ggplot2::diamonds
ggplot2::diamonds
# Check the distinct rows in diamonds
ggplot2::diamonds %>% 
  distinct() %>%
  nrow()
# Check the total rows
ggplot2::diamonds %>%
  nrow()
# No unique key

# Mutating Joins
# A mutating join allows you to combine variables from two tables. It first matches observations by their keys, 
# then copies across variables from one table to the other.
# Like mutate(), the join functions add variables to the right

flights2 <- flights %>%
  select(year:day, hour, origin, dest, tailnum, carrier)
flights2

# If you want to add full airline name to flights2 data, you can combine the airlines and flights2 with left_join()

flights2 %>%
  select(-origin, -dest) %>%   # get rid of origin and dest
  left_join(airlines, by = "carrier")

# In R's base language setting:
flights2 %>%
  select(-origin, -dest) %>%
  mutate(name = airlines$name[match(carrier, airlines$carrier)])

# Mutating Joins Exercises
# Compute the average delay by destination, then join on the airports data frame so you can show the spatial
# distribution of delays. Here’s an easy way to draw a map of the United States:

library(purrr)

airports %>%
  semi_join(flights, c("faa" = "dest")) %>%
  ggplot(mapping = aes(lon, lat)) +
  borders("state") +
  geom_point() +
  coord_quickmap()

# You might want to use the size or color of the points to display the average delay for each airpot
avg_dest_delay <- flights %>%
  group_by(dest) %>%
  summarise(delay = mean(arr_delay, na.rm = TRUE)) %>%
  inner_join(airports, by = c(dest = "faa"))
avg_dest_delay %>%
  ggplot(mapping = aes(lon, lat, colour = delay)) +
  borders("state") +
  geom_point() +
  coord_quickmap()

# 2. Add the location of the origin and destination (i.e. the lat and lon) to flights
airports
flights_loc <- flights %>%
  left_join(airports, by = c(dest = "faa")) %>%
  left_join(airports, by = c(origin = "faa")) %>%
  head()
flights_loc

# 3. Is there a relationship between the age of a plane and its delay?
plane_age <- planes %>%
  mutate(age = 2018 - year) %>%
  select(tailnum, age)
flights %>%
  inner_join(plane_age, by = "tailnum") %>%
  group_by(age) %>%
  filter(!is.na(dep_delay)) %>%
  summarise(delay = mean(dep_delay)) %>%
  ggplot(mapping = aes(x = age, y = delay)) +
  geom_point() +
  geom_line()
# There is no relationship between the age of a plane and its delay

# 4. What weather conditions make it more likely to see a delay?
weather
flight_weather <- flights %>%
  inner_join(weather, by = c("origin" = "origin", "year" = "year",
                             "month" = "month", "day" = "day",
                             "hour" = "hour"))
flight_weather %>%
  group_by(precip) %>%
  summarise(delay = mean(dep_delay, na.rm = TRUE)) %>%
  ggplot(mapping = aes(x = precip, y = delay)) +
  geom_line() + geom_point()

# Any precipitation is associated with delay

# 5. What happened on June 13, 2013? Display the spatial pattern of the delays, and then use
# Google to cross-reference with the weather.

# storms in Southeastern US
library(viridis)
flights %>%
  filter(year == 2013, month == 6, day == 13) %>%
  group_by(dest) %>%
  summarise(delay = mean(dep_delay, na.rm = TRUE)) %>%
  inner_join(airports, by = c("dest" = "faa")) %>%
  ggplot(aes(y = lat, x = lon, size = delay, colour = delay)) +
  borders("state") +
  geom_point() +
  coord_quickmap() +
  scale_color_viridis()


# Filtering Joins
# 1. What does it mean for a flight to have a missing tailnum? 
# What do the tail numbers that don’t have a matching record in planes have in common? 
# (Hint: one variable explains ~90% of the problems.)

flights %>% 
  anti_join(planes, by = "tailnum") %>%
  count(carrier, sort =TRUE)

# AA and MQ do not report tail numbers.

# 2. Filter flights to only show flights with planes that have flown at least 100 flights
planes_al100 <- filter(flights) %>%
  group_by(tailnum) %>%
  count() %>%
  filter(n > 100)
planes_al100
flights %>%
  semi_join(planes_al100, by = "tailnum")

# 3. No Data

# 4. Find the 48 hours that have the worst delays. Cross-reference it with the weather data.
flights %>%
  group_by(year, month, day) %>%
  summarise(all_24 = sum(dep_delay, na.rm = TRUE) + sum(arr_delay, na.rm = TRUE)) %>%
  mutate(all_48 = all_24 + lag(all_24)) %>%
  arrange(desc(all_48))

# 5. What does anti_join(flights, airports, by = c("dest" = "faa")) tell you? What does
# anti_join(airports, flights, by = c("dest" = "faa")) tell you?

# The first tells you the flights going to foreign airports, which are not in FAA
# The second tells you the airports that have no planes from NYC

# 6. You might expect that there’s an implicit relationship between plane and airline, because each plane is flown
# by a single airline. Confirm or reject this hypothesis using the tools you’ve learned above.
airplane_multi_carrier <- flights %>%
  group_by(tailnum, carrier) %>%
  count() %>%
  filter(n() > 1) %>%
  select(tailnum) %>%
  distinct()
airplane_multi_carrier
# No such thing in this dataset.







