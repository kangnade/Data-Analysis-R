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

# You can also pass a vector of inegers to sep.
# separate() will interpret the integers as positions to split at. Positive values start at 1
# on the far left of the strings; negative values start at -1 on the far right of the strings. 
# The length of sep should be one less than the number of names in into.
table3 %>%
  separate(year, into = c("century", "year"), sep = 2)

# Unite
# unite() is the inverse of separate(). It combines smultiple columns into a single column.
# You'll need it much less frequently than separate() but it is still a useful tool

# Unite and rejoin the century and year columns, we use table5
table5
table5 %>%
  unite(new, century, year)
# But this gives a _ between the numbers from different columns
# We do need to use the sep argument.
# The default is "_", we need ""
table5 %>%
  unite(new, century, year, sep = "")

# Exercises:
# 1. What do the extra and fill arguments do in separate()? 
# Experiment with the various options for the following two toy datasets
tibble(x = c("a,b,c", "d,e,f,g", "h,i,j")) %>% 
  separate(x, c("one", "two", "three"))

tibble(x = c("a,b,c", "d,e", "f,g,i")) %>% 
  separate(x, c("one", "two", "three"))
?separate
# The extra argument tells separate what to do if there are too many pieces, 
# and the fill argument if there aren't enough.
# Extra gets dropped
tibble(x = c("a,b,c", "d,e,f,g", "h,i,j")) %>%
  separate(x, c("one", "two", "three"), extra = "drop")
# Use merge
tibble(x = c("a,b,c", "d,e,f,g", "h,i,j")) %>%
  separate(x, c("one", "two", "three"), extra = "merge")
# In merging, f,g appears in the value cell

# In the other case, one of the entry columns has too few
tibble(x = c("a,b,c", "d,e", "f,g,i")) %>%
  separate(x, c("one", "two", "three"))
# So it prints a NA in the cell 
# Alternative option for fill is right, to fill missing values from the right with no warning
tibble(x = c("a,b,c", "d,e", "f,g,i")) %>%
  separate(x, c("one", "two", "three"), fill = "right")
# If we fill from left side
tibble(x = c("a,b,c", "d,e", "f,g,i")) %>%
  separate(x, c("one", "two", "three"), fill = "left")

# 2. Both unite() and separate() have a remove argument. What does it do? Why would you set it to FALSE?
# You would set it to FALSE if you want to create a new variable, but keep the old one.

# Missing Values
# ----Explicitly flagged with NA
# ----Implicitly not present in the data

# Illustrate with a simple example:
stocks <- tibble(
  year   = c(2015, 2015, 2015, 2015, 2016, 2016, 2016),
  qtr    = c(   1,    2,    3,    4,    2,    3,    4),
  return = c(1.88, 0.59, 0.35,   NA, 0.92, 0.17, 2.66)
)
stocks
# The return for the fourth quarter of 2015 is explicitly missing, 
# because the cell where its value should be instead contains NA.
# The return for the first quarter of 2016 is implicitly missing, 
# because it simply does not appear in the dataset.

# To show missing values, we can spread the stocks by year with values as return
stocks %>%
  spread(year, return)

# Additionally, you can set na.rm = TRUE in gather() to turn explicit missing values implicit
stocks %>%
  spread(year, return) %>%
  gather(year, return, `2015`:`2016`, na.rm = TRUE)

# Another important tool for making missing values explicit in tiday data is complete()
stocks %>%
  complete(year, qtr)
# complete() takes a set of columns, and finds all unique combinations. 
# It then ensures the original dataset contains all those values, filling in explicit NAs where necessary.
treatment <- tribble(
  ~ person,           ~ treatment, ~response,
  "Derrick Whitmore", 1,           7,
  NA,                 2,           10,
  NA,                 3,           9,
  "Katherine Burke",  1,           4
)
treatment
# You can fill in these missing values with fill(). It takes a set of columns 
# where you want missing values to be replaced by the most recent non-missing value 
# (sometimes called last observation carried forward).
treatment %>%
  fill(person)

# Exercises:
# 1. Compare and contrast the fill arguments to spread() and complete()
?spread
?complete
# In spread, the fill argument explicitly sets the value to replace NAs. In complete, 
# the fill argument also sets a value to replace NAs but it is named list, 
# allowing for different values for different variables. Also, both cases replace 
# both implicit and explicit missing values.

# 2. What does the direction argument to fill() do?
# With fill, it determines whether NA values should be replaced by the 
# previous non-missing value ("down") or the next non-missing value ("up").

# Case Study
who
# Need to gather all columNhs from new_sp_014 to newrel_f65
# We do not know what they are, so we give them the generic key
who1 <- who %>%
  gather(new_sp_m014:newrel_f65, key = "key",
         value = "cases",
         na.rm = TRUE)
who1
who1 %>%
  count(key)
# Fix names and try separate the data
who2 <- who1 %>%
  mutate(key = stringr::str_replace(key, "newrel", "new_rel"))
who2

who3 <- who2 %>%
  separate(key, c("new", "type", "sexage"), sep = "_")
who3
# We might as well drop the new column because it is constant in
# this dataset
who3 %>%
  count(new)
who4 <- who3 %>%
  select(-new, -iso2, -iso3)
who4
# Next we'll separate sexage into sex and age by splitting after the first character
who5 <- who4 %>%
  separate(sexage, c("sex", "age"), sep = 1) # sep=number number is the position
who5





