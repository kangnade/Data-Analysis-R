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












