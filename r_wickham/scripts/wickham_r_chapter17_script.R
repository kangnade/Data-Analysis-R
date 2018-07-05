
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

# It is better to use list because list allows us the show the names of each column
output3 <- vector("list", ncol(flights))
for(i in seq_along(flights)){
  output3[i] <- typeof(flights[[i]])
}
output3

# Bue this one doesn't show the names of each column
output3 <- vector("character", ncol(flights))
names(output3) <- names(flights)
for(i in names(flights)){
  output3[i] <- typeof(flights[[i]])
}
output3
# 1c. Compute the number of unique values in each column of iris.
# load data
iris
output4 <- vector("double", ncol(iris))
names(output4) <- names(iris)
for(i in names(iris)){
  output4[i] <- length(unique(iris[[i]]))
}
output4
# Need to use length to calculate the length of a vector, cannot use count

# 1d.
n <- 10
meanv <- c(-10, 0, 10, 100)
output5 <- vector("list", length(meanv))
for (i in seq_along(output5)) {
  output5[[i]] <- rnorm(n, mean = meanv[i])
}
output5


# Eliminate the for loop in each of the following examples by taking advantage of an existing function that works with vectors:
out <- ""
for (x in letters) {
  out <- stringr::str_c(out, x)
}

x <- sample(100)
sd <- 0
for (i in seq_along(x)) {
  sd <- sd + (x[i] - mean(x)) ^ 2
}
sd <- sqrt(sd / (length(x) - 1))

x <- runif(100)
out <- vector("numeric", length(x))
out[1] <- x[1]
for (i in 2:length(x)) {
  out[i] <- out[i - 1] + x[i]
}

# first, use str_c to collapse
library(stringr)
str_c(letters, collapse = "")        

# second, just use the sd() function to compute standard deviation
x <- sample(100)
sd(x)

# third
?runif
# runif generates random deviates
# cumulative sum
x <- runif(100)
out <- vector("numeric", length(x))
all.equal(cumsum(x),out)

# 3. Combine your function writing and for loop skills:
# 1. Write a for loop that prints() the lyrics to the children’s song “Alice the camel”.
# 2. Convert the nursery rhyme “ten in the bed” to a function. Generalise it to any number of people in
# any sleeping structure.
# 3. Convert the song “99 bottles of beer on the wall” to a function. Generalise to any number of any vessel
# containing any liquid on surface.

### all from Jeffrey B. Arnold's solutions, I haven't heard of these songs so not quite familiar
humps <- c("five", "four", "three", "two", "one", "no")
for (i in humps) {
  cat(str_c("Alice the camel has ", rep(i, 3), " humps.",
            collapse = "\n"), "\n")
  if (i == "no") {
    cat("Now Alice is a horse.\n")
  } else {
    cat("So go, Alice, go.\n")
  }
  cat("\n")
}

numbers <- c("ten", "nine", "eight", "seven", "six", "five",
             "four", "three", "two", "one")
for (i in numbers) {
  cat(str_c("There were ", i, " in the bed\n"))
  cat("and the little one said\n")
  if (i == "one") {
    cat("I'm lonely...")
  } else {
    cat("Roll over, roll over\n")
    cat("So they all rolled over and one fell out.\n")
  }
  cat("\n")
}

bottles <- function(i) {
  if (i > 2) {
    bottles <- str_c(i - 1, " bottles")
  } else if (i == 2) {
    bottles <- "1 bottle"
  } else {
    bottles <- "no more bottles"
  }
  bottles
}
beer_bottles <- function(n) {
  # should test whether n >= 1.
  for (i in seq(n, 1)) {
    cat(str_c(bottles(i), " of beer on the wall, ", bottles(i), " of beer.\n"))
    cat(str_c("Take one down and pass it around, ", bottles(i - 1),
              " of beer on the wall.\n\n"))
  }
  cat("No more bottles of beer on the wall, no more bottles of beer.\n")
  cat(str_c("Go to the store and buy some more, ", bottles(n), " of beer on the wall.\n"))
}
beer_bottles(3)

# 4. It’s common to see for loops that don’t preallocate the output and instead increase the length of a vector at each step:
non_preallocate <- function(x){
  output <- vector("integer", 0)
  for (i in seq_along(x)) {
    output <- c(output, i)
  }
  output
}
# Here the preallocate has a pre-allocated output vector
preallocate <- function(y){
  output_pre <- vector("integer", y)
  for(i in seq_along(y)){
    output_pre[[i]] <- i
  }
  output_pre
}

# According to the solution manual, we can use the microbenchmark package
# install.packages("microbenchmark")
library(microbenchmark)
?microbenchmark
microbenchmark(non_preallocate(10000), times = 5)
microbenchmark(preallocate(10000), times = 5)
# With longer and larger data, preallocate is more efficient than the non_preallocate


# For Loop Variation Exercises --------------------------------------------


# 1. Imagine you have a directory full of CSV files that you want to read in. 
# You have their paths in a vector, files <- dir("data/", pattern = "\\.csv$", full.names = TRUE), 
# and now want to read each one with read_csv(). Write the for loop that will load them into a single data frame.
df <- vector("list", length(files))
for (i in seq_along(files)) {
  df[[i]] <- read_csv(files[[i]])
}
df <- bind_rows(df)

# 2. What happens if you use for (nm in names(x)) and x has no names? 
# What if only some of the elements are named? What if the names are not unique?
x <- 1:10
print(names(x))
for (i in names(x)) {
  print(i)
  print(x[[i]])
}

# 3. Write a function that prints the mean of each numeric column in a data frame, 
# along with its name. For example, show_mean(iris) would print
iris

?str_pad
str_pad("hadley", 30, "left")
1L
?str_c

show_mean <- function(df, digits = 2){
  # To format the output, we need to know the length of the
  # names of each column in the dataset
  longest <- max(str_length(names(df)))
  # Write the for loop
  for(i in names(df)){
    # check if the data values are numeric, so can compute mean
    if(is.numeric(df[[i]])){
      # Use cat() function
      cat(str_c(
        str_pad(str_c(i, ":"), longest+1, "right"),
        format(mean(df[[i]]), digits = digits, nsmall = digits),
        sep = " "
      ), "\n")
    }
  }
}
show_mean(iris)

# 4. What does this code do? How does it work?
# This code mutates the disp and am columns:
# disp is multiplied by 0.0163871
# am is replaced by a factor variable.


# For Loops Versus Functionals Exercises ----------------------------------

# 1.Read the documentation for apply(). In the 2d case, what two for loops does it generalise?
?apply
# It generalizes looping over the rows or columns of a matrix or data-frame.

# 2. Adapt col_summary() so that it only applies to numeric columns You might want to start with an is_numeric() 
# function that returns a logical vector that has a TRUE corresponding to each numeric column.

test <- c(TRUE, TRUE, FALSE, TRUE)
x <- seq_along(test)
x

# some tests
iris
is_num <- c(TRUE, TRUE, TRUE, TRUE, FALSE)
iris[is_num]
index <- seq_along(iris)[is_num]
index


col_summary_num <- function(df, fun){
  # need a vector to indicate whether the column is numeric
  is_num <- vector("logical", length(df))
  for(i in seq_along(df)){
    is_num[[i]] <- is.numeric(df[[i]])
  }
  # we now have a boolean vector, and can extract the indices
  # of the columns that are numeric
  index <- seq_along(df)[is_num]
  # Since is_numeric is boolean T or F, we can sum the total
  # number of numeric columns
  num <- sum(is_num)
  # Now with this information, we can get our output vector
  result <- vector("double", num)
  for(i in index){
    result[i] <- fun(df[[i]])
  }
  result
}
col_summary_num(iris, mean)


