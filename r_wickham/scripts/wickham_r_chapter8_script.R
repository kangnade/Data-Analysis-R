### Chapter 8 Data Import with readr ###

### LOAD PACKAGE ###
library(tidyverse)

### CONTENT ###
# Most readr's functions are converned with turning flat files into data frames:
# read_csv() reads comma-delimited files
# read_csv2() reads semicolon-separated files
# read_tsv() reads tab-delimited files
# read_delim() reads in files with any delimiter
# read_fwf() reads fixed width files
# read_table() reads a common variation of fixed-width files where columns are sperated
# by white space
# read_log reads Apache style log files

# We focus on read_csv()
# NO REAL DATA UPLOADED
heights <- read_csv("data/heights.csv")

# Sometimes there are a few lines of metadata at the top of the file.
# You can use skip = n to skip the first n lines, or use comment = "#"
# to drop all lines that start with (e.g.)#
read_csv("skip the first two rows", skip = 2)
read_csv("drop all lines starting with #", comment = "#")

# Sometimes the data might not have column names. You can use col_names = FALSE to
# tell read_csv() not to treat the first row as headings, and instead lable them 
# subsequentially from X1 to Xn
read_csv("do not trat first row as headings", col_names = FALSE)
# "\n" is a convenient shortcut for adding a new line
# Alternatively you can pass col_names a character vector, which will be used as the
# column names:
read_csv("pass column names", col_names = c("x", "y", "z"))

# Another issue is the na
# Tweaking with the missing values
read_csv("tweak missing values as .", na = ".")

# Getting Started - Exercises
?read_csv
# 1. What function woudl you use to read a file where fields are separated with "|" ?
read_delim("file", '|')

# 2. Apart from file, skip and comment, what other arguments do read_csv() and read_tsv()
# have in common?
# col_types, locale, na, quote_na, trim_ws, n_max, guess_max, progress

# 3. What are the most important arguments to read_fwf() ?
?read_fwf
# Unfortunately, it's painful to parse because you need to describe the length of every field. 
# Readr aims to make it as easy as possible by providing a number of different ways to describe the field structure.











































