### Chapter 15 Functions ###

### LOAD PACKAGES ###
library(tidyverse)

### CONTENT ###

# Introduction Exercises
# 1. Why is TRUE not a parameter to rescale01()? What would happen if x contained a single missing value, and na.rm was FALSE?
rescale01_test <- function(x) {
  rng <- range(x, na.rm = FALSE)
  (x - rng[1]) / (rng[2] - rng[1])
}
# Let's try to set na.rm = FALSE in the function:
rescale01_test(c(0, 5, NA, 10))
# If we let na.rm = FALSE, all the results become NA
# The function basically doesn't do his job.

# 2. In the second variant of rescale01(), infinite values are left unchanged. Rewrite rescale01() so that -Inf is mapped to 0, and Inf is mapped to 1.
rescale01 <- function(x) {
  rng <- range(x, na.rm = TRUE, finite = TRUE)
  y <- (x - rng[1]) / (rng[2] - rng[1])
  y[y == -Inf] <- 0
  y[y == Inf] <- 1
  y
}
rescale01(c(Inf, -Inf, 0:5, NA))

# 3. Practice turning the following code snippets into functions. Think about what each function does. 
# What would you call it? How many arguments does it need? Can you rewrite it to be more expressive or less duplicative?
mean(is.na(x))

x / sum(x, na.rm = TRUE)

sd(x, na.rm = TRUE) / mean(x, na.rm = TRUE)

# Answer 1:
na_proportion <- function(x){
  mean(is.na(x))
}
na_proportion(c(NA, 1, NA, 2, NA, 3, NA, 4))
# Answer 2:
weighting <- function(x){
  x / sum(x, na.rm = TRUE)
}
test <- weighting(0:6)
test
sum(test)
# For positive values, this weighting function standardize the values so the results sum up to 1

# Answer 3:
# coefficient of variance
coeff_var <- function(x){
  sd(x, na.rm = TRUE) / mean(x, na.rm = TRUE)
}

test3 <- coeff_var(c(1,2,3,4,5,6,7,8,9,14))
test3

# 4. Follow http://nicercode.github.io/intro/writing-functions.html to write your own functions to compute 
# the variance and skew of a numeric vector.

variance <- function(x) {
  # remove missing values
  x <- x[!is.na(x)]
  n <- length(x)
  m <- mean(x)
  sqError <- (x - m) ^ 2
  sum(sqError) / (n - 1)
}
variance(1:100)
var(1:100)
# Result is the same as the default variance function in R

skew <- function(x){
  x <- x[!is.na(x)]
  n <- length(x)
  m <- mean(x)
  upper <- sum((x - m)^3)/n
  lower <- sqrt(sum((x - m)^2)/(n-1))^3
  upper / lower
}
skew(rgamma(10, 1, 1))


# 5. Write both_na(), a function that takes two vectors of the same length and returns the number of positions 
# that have an NA in both vectors.
TRUE & FALSE
sum(TRUE & FALSE, TRUE&TRUE, FALSE&FALSE)
sum(TRUE, FALSE, FALSE)
sum(FALSE, FALSE, FALSE)

# Answer:
both_na <- function(x, y){
  sum(is.na(x) & is.na(y))
}

x <- c(NA, NA, NA, 2, 4)
y <- c(1, NA, NA, 2, 2)
both_na(x, y)

# 6. What do the following functions do? Why are they useful even though they are so short?
is_directory <- function(x) file.info(x)$isdir
is_readable <- function(x) file.access(x, 4) == 0
# The is_directory checks whether x is a path, and is_readable checks whether the path in x is readable, or
# is it able to access the file in the path

