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

# Exercises:
# 1. Why are gather() and spread() not perfectly symmetrical?
# Carefully consider the following example:
stocks <- tibble(
  year   = c(2015, 2015, 2016, 2016),
  half  = c(   1,    2,     1,    2),
  return = c(1.88, 0.59, 0.92, 0.17)
)
stocks
stocks %>% 
  spread(year, return) %>% 
  gather("year", "return", `2015`:`2016`)

# The functions spread and gather are not perfectly symmetrical because column type 
# information is not transferred between them. In the original table the column year 
# was numeric, but after running spread() and gather() it is a character vector. 
# This is because variable names are always converted to a character vector by gather().

# 2. Why does this code fail?

table4a %>% 
  gather(1999, 2000, key = "year", value = "cases")

# Use `1999`, `2000`

# 3. Why does spreading this tibble fail? How could you add a new column to fix the problem?
people <- tribble(
  ~name,             ~key,    ~value,
  #-----------------|--------|------
  "Phillip Woods",   "age",       45,
  "Phillip Woods",   "height",   186,
  "Phillip Woods",   "age",       50,
  "Jessica Cordero", "age",       37,
  "Jessica Cordero", "height",   156
)

people
# There are two rows with Phillip woods and age.
people <- tribble(
  ~name,             ~key,    ~value, ~obs,
  #-----------------|--------|------|------
  "Phillip Woods",   "age",       45, 1,
  "Phillip Woods",   "height",   186, 1,
  "Phillip Woods",   "age",       50, 2,
  "Jessica Cordero", "age",       37, 1,
  "Jessica Cordero", "height",   156, 1
)
spread(people, key, value)

# 4. Tidy this simple tibble. Do you need to spread or gather it?
# What are the variables?
preg <- tribble(
  ~pregnant, ~male, ~female,
  "yes",     NA,    10,
  "no",      20,    12
)
gather(preg, sex, count, male, female)

# Separating and Pull
# table3 has a different problem: column rate contains two variables (case and population)
# To fix it, we need separate() function

# Separate
# separate() pulls apart one column into multiple columns, by splitting wherever a separator
# character appears. Take table3:
table3
# We need to separate the rate variable into cases and populatiohn
table3 %>%
  separate(rate, into = c("cases", "population"))
# By default, separate() will split values wherever it sees a non-alphanumeric character,
# which isn't a number nor letter. In table3, it splits with /
# We can rewrite it:
table3 %>%
  separate(rate, into = c("case", "population"), sep = "/")
# By default, separate leaves the column type as it is. Here, both case and population after
# separation remains as character columns
# Here, however, character columns are not very useful because they are numbers. We can ask
# separate() to try and convert to better types using convert = TRUE:
table3 %>%
  separate(rate, into = c("case", "population"),
           convert = TRUE)











