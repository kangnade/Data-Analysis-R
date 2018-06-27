### PART 2, WRANGLING DATA ###
### CHAPTER 7 TIBBLES WITH TIBBLE ###

### LOAD PACKAGE ###
library(tidyverse)

### Content ###

# If you want to coerce a data frame to a tibble, use as_tibble()
# For instance, we change the data iris into a tibble:
as_tibble(iris)

# You can also create a new tibble from individual vectors with tibble()
tibble(
  x = 1:5,
  y = 1,
  z = x^3 + y
)

# tibble never changes the type of inputs, nor names of variables nor create row names
tb <- tibble(
  ':)' = "smile",
  ':(' = "sad",
  'World Cup' = "string"
)
tb

# Another way to create a tibble is tribble(), meaning transposed tibble
# tribble() is customized for data entry in code: column headings are defined by
# formulas and entries are separated by commas. This makes it possible to lay out
# small amounts of data in easy-to-read form:
# Note column headings start with ~
# It contains #--/--/---- as a comment to indicate the position of the headings
tribble(
  ~x, ~y, ~z,
  #--/--/----
  "a", 2, 3.6,
  "b", 1, 8.5
)

# Tibbles Versus data.frame
# Printing
tibble(
  a = lubridate::now() + runif(1e3) * 86400,
  b = lubridate::today() + runif(1e3) * 30,
  c = 1:1e3,
  d = runif(1e3),
  e = sample(letters, 1e3, replace = TRUE)
)

# Sometimes you need more options than the default display from the tibble
# there are a few options
# First you can explicitly print() the data frame and control the number of rows (n)
# and the width of the display width = Inf will display all columns:

nycflights13::flights %>%
  print(n = 10, width = Inf)

# You can also control the default print behavior by setting options:
# options(tibble.print_max = n, tibble.print_min = m):
# if more than m rows print only n rows. Use options(dplyr.print_min = Inf) to
# always show all rows

# Use options(tibble.width = Inf) to always print all columns, regardless of the
# width of the screen

# Always check package?tibble for questions

# Another option is to use R's built-in data viewer View()
nycflights13::flights %>%
  View()

# Subsetting
# If you want to pull out a single variable, you need some new tools
# $ and [[
# [[ can extract by name or position; $ only extracts by name but is a little less typing
df <- tibble(
  x = runif(5),
  y = rnorm(5)
)
df

# Extract by name
df$x
df[["x"]]

# Extract by position
df[[1]]

# To use these in a pipe, you'll need to use the special placeholder .:
df %>% .$x
df %>% .[["x"]]

# Interacting with Older Code
# Some older functions do not work with tibbles
# If you encounter one of these functions, use as.data.frame() to turn
# a tibble back to a data.frame

# Exercises
# 1. How can you tell if an object is a tibble? (Hint: try printing mtcars, which is regular)
print(mtcars)
# it prints more than the first 10 rows so it is not a tibble because tibble is designed 
# to print or show only the first 10 rows

# 2. Compare and contrast the following operations on a data.frame and equivalent tibble.
# What is different? Why might the default data frame behaviors cause you frustration?
df <- data.frame(abc = 1, xyz = "a")
df$x
df[,"xyz"]
df[, c("abc", "xyz")]

# 3. If you have the name of a variable stored in an object, e.g. var <- "mpg"
# how can you extract the reference variable frmo a tibble?
# You can either extract by name or by position

# 4. Practice referring to nonsyntactic names in the following data frame by:
# a. Extract the variable called 1
# b. Plotting a scatterplot of 1 versus 2
# c. Creating a new column called 3, which is 2 divided by 1
# d. Renaming the columns to one, two, and three
annoying <- tibble(
  `1` = 1:10,
  `2` = `1` * 2 + rnorm(length(`1`))
)
annoying

# a. There are four ways to do so:
annoying$`1`
annoying[['1']]
annoying %>% .$`1`
annoying %>% .[['1']]

# b.
ggplot(data = annoying) +
  geom_point(mapping = aes(x = `1`, y = `2`))

# c.
new_annoying <- annoying %>%
  mutate(`3` = `2` / `1`)

# d.
?rename
rename(new_annoying, one = `1`, two = `2`, three = `3`)

# 5. What does tibble::enframe() do? When might you use it?
?tibble::enframe
# enframe() converts named atomic vectors or lists to two-column data frames. 
# For unnamed vectors, the natural sequence is used as name column
enframe(1:3)
enframe(c(a = 5, b = 7))

# 6. What option controls how many additional column names are printed
# at the footer of a tibble
# tibble.width
