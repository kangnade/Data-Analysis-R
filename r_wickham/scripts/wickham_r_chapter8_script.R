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

# 4. Sometimes strings in a CSV file contain commas. To prevent them from cuasing problems they need
# to be surrounded by a quoting character, like " or '. By convention, read_csv() assumes that the quoting
# character will be ", and if you want to change it you'll need to use read_delim() instead. What arguments do
# you need to specify to read the following text into a data frame?
"x,y\n1,'a,b'"
?read_delim

# Parsing a Vector
# Numbers: 1. people write numbers differently such as 1.23 (US) and 1,23 (EU)
# To address this problem:
parse_double("1.23")
parse_double("1,23", locale = locale(decimal_mark = ","))

# Numbers: 2. numbers are often surrounded by other characters such as $1000 or 10%
# parse_number() solves this situation because it ignores non-numeric characters before
# and after the number. This is particularly useful for currencies and percentages
# but works to extract numbers embedded in text.
parse_number("$100")
parse_number("20%")
parse_number("it costs $2000")

# Numbers: 3. numbers often contain "grouping" characters to make them easier to read like:
# 100,000,000 and so on
# This problem can be addressed by the combination of parse_number() and the locale as parse_number()
# will ignore the grouping mark:
# Used in America
parse_number("$123,456,789")

# Used in many parts of Europe
parse_number(
  "123.456.789",
  locale = locale(grouping_mark = ".")
)

# Used in Switzerland
parse_number(
  "123'456'789",
  locale = locale(grouping_mark = "'")
)

# Strings
# In R, we can get at the underlying representation of a string using charToRaw()
charToRaw("Nade")
# ASCII does a great job of representing English characters because it's the American Standard Code
# for Information Interchange
# UTF-8 can encode just about every character used by humans today, as well as many extra symbols emoji

# readr uses UTF-8 everywhere. But this fails for data produced by older systems that do not understand UTF-8
# If this happens, your string looks weird when you print them
x1 <- "El Ni\xf1o was particularly bad this year"
x2 <- "\x82\xb1\x82\xf1\x82\xc9\x82\xbf\x82\xcd"

x1
x2

# To fix this problem, you'll need to specify the encoding in parse_character()
parse_character(x1, locale = locale(encoding = "Latin1"))
parse_character(x2, locale = locale(encoding = "Shift-JIS"))

# How do you find the correct encoding? Assume we are unlucky, readr provides guess_encoding()
#Try:
guess_encoding(charToRaw(x1))
guess_encoding(charToRaw(x2))
parse_character(x2, locale = locale(encoding = "KOI8-R"))

# Factors
# R uses factors to represent categorical variables that have a known set of possible values
# Give parse_factor() a vector of known levels to generate a warning whenever an unexpected
# value is present:
fruit <- c("apple", "banana")
parse_factor(c("apple", "banana", "bananana"), levels = fruit)

# Dates, Date-Times, and Times























