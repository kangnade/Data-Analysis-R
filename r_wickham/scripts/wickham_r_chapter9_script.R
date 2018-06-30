### Chapter 9 Tidy Data with tidyr

### LOAD PACKAGE ###
library(tidyverse)

### CONTENT ###
# Two common problems in tidying data
# 1. One variable might be spread across multiple columns
# 2. One observation might be scattered across multiple rows
# I would be really unlucky to encounter both
# To fix these problems, use tidyr: gather() and spread()

# Gathering
table4a
# Take table4a for example, the column names 1999 and 2000 represent
# values of the year variable, and each row represents two observations.
# To tidy, we need to gather those columns into a new pair of variable
# 1. The set of columns that represent values, not variables. (1999,2000)
# 2. The name of the variable whose values form the column names (key: year)
# 3. The name of the variable whose values are spread over the cells (value, # of cases)

table4a %>%
  gather(`1999`, `2000`, key = "year", value = "cases")

# We can do the same to table4b
# The only difference is the variable stored in cell values:
table4b
table4b %>%
  gather(`1999`,`2000`, key = "year", value = "population")

# To combine the tidied versions of table3a and table4b into a single tibble,
# we need to use dplyr::left_join(), which you'll learn in Chapter10
tidy4a <- table4a %>%
  gather(`1999`, `2000`, key = "year", value = "cases")
tidy4b <- table4b %>%
  gather(`1999`,`2000`, key = "year", value = "population")
left_join(tidy4a, tidy4b)

# Spreading
# Spreading is the opposite of gathering, you use it when an observation is scattered
# acrpss multiple rows.
table2
# Column that contains variable names, the key column, here in 4a is type
# Column that contains values forms multiple variables, the value column, in 4a is count
spread(table2, key = type, value = count)

# The key and value arguments, spread() and gather() are complements. gather() makes wide
# tables narrower and longer; spread() makes long tables shorter and wider
























