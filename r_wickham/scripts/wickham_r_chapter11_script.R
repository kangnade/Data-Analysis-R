### Strings with stringr ###

### LOAD PACKAGES ###
library(tidyverse)
library(stringr)

### CONTENT ###
# String Length
str_length("Texas Christian University")
str_length("TexasChristianUniversity")

# Combining Strings
str_c("Texas", "Christian", "University")
str_c("Texas", " Christian", " University")
str_c("Texas", " ", "Christian", " ", "University")

# Use sep to control how they are separated
str_c("Texas A&M University", " College Station", sep = ",")

# Missing values, use str_replace_na():
univ <- c("TCU", "TAMU", "SMU", NA)
str_replace_na(univ)

# str_c() is vectorized
str_c("TCU", str_c(" SMU", " TAMU"), " BAYLOR")

# Object with length 0 is silently dropped

# To collapse a vector of strings into a single string, use collapse
str_c(c("TCU", "SMU", "BAYLOR")) # separated
str_c(c("TCU", "SMU", "BAYLOR"), collapse = ",") # collapsed together

# Subsetting Strings
# You can extract part of the string with str_sub()
# The start, end arguments are inclusive portions of string
univ <- c("TCU", "TAMU", "SMU", "UT")
str_sub(univ, 1, 3)
# If one of the strings is too short, str_sub just returns as much as possible
str_sub(univ, 1, 4)

# You can also use the assignment form of str_sub() to modify strings:
str_sub(univ, 1, 1) <- str_to_lower(str_sub(univ, 1, 1))
univ

# Locales
univ <- c("TCU", "TAMU", "SMU", "UT")
str_sort(univ, locale = "en")
str_sort(univ, locale = "haw")

# String Basics Exercises
# In code that doesn’t use stringr, you’ll often see paste() and paste0(). What’s the difference between the
# two functions? What stringr function are they equivalent to? How do the functions differ in their handling
# of NA?

# The function paste separates strings by spaces by default, while paste0 does not separate strings with
# spaces by default.
paste(univ)
paste0(univ)
paste("a", "b", "c")
paste0("a", "b", "c")
# paste0 is similar to str_c()
str_c("a", "b", "c")

# However, str_c and the paste function handle NA differently. The function str_c propagates NA, if any
# argument is a missing value, it returns a missing value. This is in line with how the numeric R functions,
# e.g. sum, mean, handle missing values. However, the paste functions, convert NA to the string "NA" and then
# treat it as any other character vector.

str_c("TCU", NA)
paste("TCU", NA)
paste0("TCU", NA)

# 2. In your own words, describe the difference between the sep and collapse arguments to str_c().
# sep is the character that is inserted between the arguments
# collapse is used to separate elements into a single vector

# 3. Use str_length() and str_sub() to extract the middle character from a string. What will you do if the
# string has an even number of characters?

x <- c("T", "TCU", "TCCU", "TCCCU", "TCCCCU")
L <- str_length(x)
m <- ceiling(L / 2)
str_sub(x, m, m)

# 4. What does str_wrap() do? When might you want to use it?
?str_wrap
# The function str_wrap wraps text so that it fits within a certain width. This is useful for wrapping long
# strings of text to be typeset.

# 5. What does str_trim() do? What’s the opposite of str_trim()?
?str_trim
# str_trim(string, side = c("both", "left", "right"))
str_trim("  String with trailing and leading white space\t")

# The opposite of str_trim is str_pad which adds characters to each side.
str_pad("TCU", 5, side = "both")
str_pad("TCU", 5, side = "right")
str_pad("TCU", 5, side = "left")

# 6. Write a function that turns (e.g.) a vector c(“a”, “b”, “c”) into the string a, b, and c. Think carefully about
# what it should do if given a vector of length 0, 1, or 2.

# Chapter Programming

# Matching Patterns and Regular Expressions

