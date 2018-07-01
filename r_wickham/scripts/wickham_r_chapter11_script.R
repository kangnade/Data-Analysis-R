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

