
# Chapter 17 Interation with purrr ----------------------------------------

### LOAD PACKAGES ###
library(tidyverse)


# For Loops ---------------------------------------------------------------

df <- tibble(
  a = rnorm(10),
  b = rnorm(10),
  c = rnorm(10),
  d = rnorm(10)
)
df
# a, b, c, d represent the columns in the tibble df
?vector
?ncol
ncol(df)
# vector(mode = "double", length = ncol of df)
output <- vector("double", ncol(df))
# seq_along(df) follows the sequence of each column, a b c d
seq_along(df)
# since we want to do a for loop, we need to know how many times we are running the loop
# to compute each value. There are total 4 columns, and we need 4 values in the vector
# So, the for loop is for i in seq_along(df)
df[[1]] # gives the values in the first column, this drops the names and gives a vector of numeric value
df[1] # only gives the tibble form of first column, doesn't drop the name, so not numeric value
# Can we do calculation with df[1]?
median(df[1])
# No, this doesn't offer the numeric data
# For df[[1]] offers numeric data

for(i in seq_along(df)){
  output[[i]] <- median(df[[i]])
}
output
output[1]
output[[1]]

# Before running a for loop, always allocate sufficient space for output
# output <- vector("double", length(x))


# For Loop Exercises ------------------------------------------------------

# 1. Write for loops to:

# Compute the mean of every column in mtcars.
# Determine the type of each column in nycflights13::flights.
# Compute the number of unique values in each column of iris.
# Generate 10 random normals for each of  
# μ=  −10,  0,  10, and  100.
# Think about the output, sequence, and body before you start writing the loop.

# 1a. mean for every column in mtcars
head(mtcars)
?names

seq_along(mtcars)
output1 <- vector("double", ncol(mtcars))
for (i in seq_along(mtcars)) {
  output1[i] <- mean(mtcars[[i]])
}
output1

# 1b. Determine the type of each column in flights
flights <- nycflights13::flights
ncol(flights)
# Total of 19 columns
# create a vector with mode = "character" and length = ncol(flights)
output2 <- vector("character", ncol(flights))
for(i in seq_along(flights)){
  output2[i] <- typeof(flights[[i]])
}
output2

# 1c. Compute the number of unique values in each column of iris.
