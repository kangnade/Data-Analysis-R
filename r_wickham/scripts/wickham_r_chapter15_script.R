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

