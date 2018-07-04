
# Chapter 16 Vectors ------------------------------------------------------

### LOAD PACKAGES ###
library(tidyverse)
library(purrr)


# Important Type of Vectors Exercises -------------------------------------

# 1. Describe the difference between is.finite(x) and !is.infinite(x).
test <- c(0, -Inf, Inf, NA, NaN)
is.finite(test)
# For is.finite():
# 0 is finite
# -Inf, Inf, NA, NaN are not considered as finite

!is.infinite(test)
# For !is.infinite()
# 0 is not infinite, NA and NaN are also not infinite
# -Inf and Inf are infinite

# 2. read source code for dplyr::near() How does it work?
dplyr::near
# Instead of checking for exact equality, it checks that two numbers are within a certain value that's
# extremely small, the tol.

# 3. A logical vector can take 3 possible values. How many possible values can an integer vector take? How many
# possible values can a double take? Use Google to do some research.
?.Machine
# sizeof.longdouble only tells you the amount of storage allocated for a long double (which are normally used 
# internally by R for accumulators in e.g. sum, and can be read by readBin). Often what is stored is the 80-bit 
# extended double type of IEC 60559, padded to the double alignment used on the platform — this seems to be the 
# case for the common R platforms using ix86 and x86_64 chips.

# 4. Brainstorm at least four functions that allow you to convert a double to an integer. How do they differ? Be precise.

# 5. What functions from the readr package allow you to turn a string into logical, integer, and double vector?
parse_logical() parse_integer() parse_double()


# Using Atomic Vectors Exercises ------------------------------------------

# 1. What does mean(is.na(x)) tell you about a vector x? What about sum(!is.finite(x))?
x <- c(NA, 2, 4, 6, 7)
is.na(x)
# This is sending outputs of boolean values
mean(is.na(x))
# The result tells you the weighting or proportion of NA's in vector x

is.finite(x)
sum(is.finite(x))
# This tells you the number of finite values within vector x

# 2. Carefully read the documentation of is.vector(). 
# What does it actually test for? Why does is.atomic() not agree with the definition of atomic vectors above?
?is.vector
# is.vector returns TRUE if x is a vector of the specified mode having no attributes other than names. It returns FALSE otherwise.
?is.atomic
# is.atomic returns TRUE if x is of an atomic type (or NULL) and FALSE otherwise.

# 3.Compare and contrast setNames() with purrr::set_names().
?setNames
# setNames(object = nm, nm)
setNames(c(1, 2, 4), c("one", "two", "four"))

?purrr::set_names
# set_names(x, nm = x, ...)
set_names(1:4, c("a", "b", "c", "d"))
set_names(1:4, letters[1:4])
set_names(1:4, "a", "b", "c", "d")

# Create functions that take a vector as input and returns:

# 1. The last value. Should you use [ or [[?

# Use [[]] to extract a single element from a vector
last_element <- function(x){
  if(length(x) > 0){
    x[[length(x)]]
  }else{
    x
  }
}
last_element(c(1:20))
last_element(1)
last_element(numeric())

# 2. The elements at even numbered positions.

?seq_along
test <- c(1,2,3,4,5,6,7,8)
seq_along(test)
input <- (seq_along(test) %% 2 == 0)
input
test[input]
input2 <- (test[] %% 2 == 0)
input2
# No need to use seq_along()

even_position <- function(x){
  if(length(x) > 0){
    test[test[] %% 2 == 0]
  }else{
    x
  }
}
even_position(test)

# 3.Every element except the last value.

except_last <- function(x){
  if(length(x) > 0){
    x[-length(x)]
  }else{
    x
  }
}
except_last(test)

# 4, Only even numbers (and no missing values).
test %% 2
TRUE & 1
TRUE & 0
only_even <- function(x){
  x[(!is.na(x) & (x %% 2 == 0))]
}
only_even(test)

# 5. Why is x[-which(x > 0)] not the same as x[x <= 0]?
test[-which(test > 0)]
which(test > 0)
# In test, everything is greater than 0, and this function basically deletes everything
# in the test vector
test[-c(1,2,3,4)] # [-c(...)] deletes the elements within the vector c()
test
test[test <= 0]
# They will treat missing values differently.

# 6. What happens when you subset with a positive integer that’s bigger 
# than the length of the vector? What happens when you subset with a name that doesn’t exist?
test[10]
# You get NA, if you subset a value bigger than the length
# When you subset a name that doesn't exist, you get an error


# Recursive Vectors(Lists) Exercises --------------------------------------

# 1. Draw the following lists as nested sets:
# Cannot show here

# 2. What happens if you subset a tibble as if you’re subsetting a list? What are the key differences between a list and a tibble?
# Subsetting a tibble works the same way as a list; a data frame can be thought of as a list of columns. The
# key different between a list and a tibble is that a tibble (data frame) has the restriction that all its elements
# (columns) must have the same length.

