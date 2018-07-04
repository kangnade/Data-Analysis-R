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

# To create headers. use CTRL-SHIFT-R

# Loading data ------------------------------------------------------------


# Testing -----------------------------------------------------------------



# Functions Are For Humans and Computers Exercise -------------------------

# 1. Read the source code for each of the following three functions, puzzle out what they do, and then brainstorm better names.

# f1 tests if a vector of string's values have common substring 
f1 <- function(string, prefix) {
  substr(string, 1, nchar(prefix)) == prefix
}
f1(c("str_c", "str_foo", "abc"), "str_")

# f2 drops the last element/value in a vector
f2 <- function(x) {
  if (length(x) <= 1) return(NULL)
  x[-length(x)]
}
f2(c(1,2,3,4,5))
# returns 1 2 3 4

# f3 replicates the value of y and make it in a list that has a length of x
# or The function f3 repeats y once for each element of x.
f3 <- function(x, y) {
  rep(y, length.out = length(x))
}
?rep
x <- c(1,2,3,4,5,6,7,8,9)
y <- c(1,2,3,4,5)
f3(y, x)
f3(x, y)
f3(1:3, 9)

# 2. Take a function that you’ve written recently and spend 5 minutes brainstorming a better name for it and its arguments.

# 3. Compare and contrast rnorm() and MASS::mvrnorm(). How could you make them more consistent?
?rnorm
# Copied from solution manual:
# rnorm samples from the univariate normal distribution, while MASS::mvrnorm samples from the multivariate
# normal distribution. The main arguments in rnorm are n, mean, sd. The main arguments is MASS::mvrnorm
# are n, mu, Sigma. To be consistent they should have the same names. However, this is difficult. In general,
# it is better to be consistent with more widely used functions, e.g. rmvnorm should follow the conventions of
# rnorm. However, while mean is correct in the multivariate case, sd does not make sense in the multivariate
# case. Both functions an internally consistent though; it would be bad to have mu and sd or mean and Sigma.

# 4. Make a case for why norm_r(), norm_d() etc would be better than rnorm(), dnorm(). Make a case for the opposite.
# Copied from solution manual:
# If named norm_r and norm_d, it groups the family of functions related to the normal distribution. If named
# rnorm, and dnorm, functions related to are grouped into families by the action they perform. r* functions
# always sample from distributions: rnorm, rbinom, runif, rexp. d* functions calculate the probability density
# or mass of a distribution: dnorm, dbinom, dunif, dexp.


# Conditional Execution ---------------------------------------------------
# || IS OR, && US AND, these are for logical expressions
# | and & are vectorized expressions not for logical expressions
# == is also vectorized
# Either check the length is 1, or, collapse with all() or any(), or use
# non-vectorized identical(). identical() returns single TRUE or FALSE

# Multiple Conditions is the same as Java
# if(){} else if(){} else{}

# If you end up with many if's, consider rewriting the code
# use switch() function. It allows you to evaluate selected code based on position or name

# Exercises:
# 1.What’s the difference between if and ifelse()? Carefully read the help and construct three examples that illustrate the key differences.
?ifelse
# ifelse returns a value with the same shape as test which is filled with elements 
# selected from either yes or no depending on whether the element of test is TRUE or FALSE.

# 2. Write a greeting function that says “good morning”, “good afternoon”, or “good evening”, depending on the time of day. 
# (Hint: use a time argument that defaults to lubridate::now(). That will make it easier to test your function.)
greeting <- function(time = lubridate::now()){
  hour <- hour(time)
  if(hour < 12){
    print("Good Morning")
  }else if(hour < 17){
    print("Good Afternoon")
  }else{
    print("Good Evening")
  }
}
greeting()

# 3. Implement a fizzbuzz function. It takes a single number as input. If the number is divisible by three, it returns “fizz”. 
# If it’s divisible by five it returns “buzz”. If it’s divisible by three and five, it returns “fizzbuzz”. 
# Otherwise, it returns the number. Make sure you first write working code before you create the function.

! 9 %% 3
!(15 %% 3) & !(15 %% 5)
!15%%3
!!15%%3

fizzbuzz <- function(x){
  stopifnot(length(x) == 1)
  stopifnot(is.numeric(x))
  if(!(x %% 3) & !(x %% 5)){
    print("fizzbuzz")
  }else if(! (x %% 3)){
    print("fizz")
  }else if(! (x %% 5)){
    print("buzz")
  }
}
fizzbuzz(9)
fizzbuzz(20)
fizzbuzz(15)

# 4. How could you use cut() to simplify this set of nested if-else statements?
if (temp <= 0) {
  "freezing"
} else if (temp <= 10) {
  "cold"
} else if (temp <= 20) {
  "cool"
} else if (temp <= 30) {
  "warm"
} else {
  "hot"
}

# Answer:
?cut
x = c(-30, 5, 10, 15, 20, 25, 30, 35, 100)
cut(x, c(-Inf, 0, 10, 20, 30, Inf), right = TRUE, labels = c("freezing", "cold", "cool", "warm", "hot"))
# right = TRUE means logical, indicating if the intervals should be closed on the right (and open on the left) or vice versa.

# 5. What happens if you use switch() with numeric values?
?switch
# It selects that number argument from ....
switch(2, "one", "two", "three")

# 6. What does this switch() call do? What happens if x is “e”?
# Doesn't work here


# Function Arguments ------------------------------------------------------

# Exercises:
# 1. What does commas(letters, collapse = "-") do? Why?
# ERROR, because commas() function contains str_c(), which contains collapes = ","
# now it becomes str_c(..., collapse = ",", collapse = "-")

# 2. It’d be nice if you could supply multiple characters to the pad argument, 
# e.g. rule("Title", pad = "-+"). Why doesn’t this currently work? How could you fix it?
# It does not work because it duplicates pad by the width minus the length of the string. This is implicitly
# assuming that pad is only one character. 

# 3. What does the trim argument to mean() do? When might you use it?
?mean
# the fraction (0 to 0.5) of observations to be trimmed from each end of x before the mean is computed. 
# Values of trim outside that range are taken as the nearest endpoint.
# If trim is zero (the default), the arithmetic mean of the values in x is computed, 
# as a numeric or complex vector of length one. If x is not logical (coerced to numeric), 
# numeric (including integer) or complex, NA_real_ is returned, with a warning.
# If trim is non-zero, a symmetrically trimmed mean is computed with a fraction of trim 
# observations deleted from each end before the mean is computed.

# 4. The default value for the method argument to cor() is c("pearson", "kendall", "spearman"). 
# What does that mean? What value is used by default?
# It means that the method argument can take one of those three values. The first value, "pearson", is used
# by default.