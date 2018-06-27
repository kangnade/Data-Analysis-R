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