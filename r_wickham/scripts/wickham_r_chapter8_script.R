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
# Three parsers depending on:
# 1. Date (the number of days since 1970-01-01)
# 2. Date-Time (the number of seconds since minight 1970-01-01)
# 3. Time (the number of seconds since midnight)

# When called without any additional arguments:

# parse_datetime() expects an ISO8601 date-time, organized from biggest to smallest:
# year, month, day, hour, minute, second
parse_datetime("2010-10-01T2010")

# If time is ommited, it will be set to midnight
parse_datetime("20101001")

# parse_date() expects a fourt-digit year, a - or /, the month, a - or /, then the day:
parse_date("2010-10-01")

# parse_time() expects the hour, :, minutes, optionally : and seconds, and an optional a.m./p.m.
# specifier:
library(hms)
parse_time("01:10 am")
parse_time("20:10:01")
# Base R doesn't have a great built-in class for time data, so we use the one probided in hms
# package

# If these defaults don't work for your data you can supply your own date-time format,
# built up of the following pieces:
# Year %Y (4 digits), %y(2 digits; 00-69 -> 2000-2069, 70-99 -> 1970-1999)
# Month %m(2 digits), %b (abbreviated name, like "Jan) %B(full name, "January")
# Day %d(2 digits), %e (optional leading space)
# Time, %H (0-23 hour format), %I (-=12 must be used with %p), %p(a.m./p.m. indicator)
# Time, %M (minutes), %S (integer seconds), %OS (real seconds), %Z (time zone)
# %Z (time zone) a name e.g. America/Chicago
# Time, %z (as offset from UTC, e.g. +0800)

# Non-digits
# %. skip one nondigit character
# %* skip any number of nondigits

parse_date("01/02/15", "%m/%d/%y")
parse_date("01/02/15", "%d/%m/%y")
parse_date("01/02/15", "%y/%m/%d")

# If you use %b or %B with non-NGLISH month names, you'll ned to set the lang argument to
# locale(). date_names_langs(), or create your own with date_names():
parse_date("1 janvier 2015", "%d %B %Y", locale = locale("fr"))

# Exercises
# 1. What are the most important arguments to locale()?
?locale
#locale(date_names = "en", date_format = "%AD", time_format = "%AT",
#       decimal_mark = ".", grouping_mark = ",", tz = "UTC",
#       encoding = "UTF-8", asciify = FALSE)

# 2. What happens if you try and set decimal_mark and grouping_mark to the same character?
# What happens to the default value of grouping_mark when you set decimal_mark to ","?
# What happens to the default value of decimal_mark when you set the grouping_mark to "."?

# First try set grouping_mark and decimal_mark with the same character
parse_number(
  "123'456'789",
  locale = locale(decimal_mark = "'", grouping_mark = "'")
) # Expected: 123456789 
# Instead, you get: Error: decimal_mark %in% c(".", ",") is not TRUE

# Second set decimal_mark to ","
parse_number(
  "123,456,789",
  locale = locale(decimal_mark = ",")
)
# Result shows that decimal_mark overshadows grouping_mark

# Third set grouping_mark to "."
parse_number(
  "123.456.789",
  locale = locale(decimal_mark = ",")
)
# Result shows that grouping_mark overshadows decimal_mark

# 3, I didn't discuss the date_format and time_format options to locale()
# What do they do? Construct an example that shows when they might be useful

# Locales also provide default date and time formats. The time format isn’t 
# currently used for anything, but the date format is used when guessing 
# column types. The default date format is %Y-%m-%d because that’s unambiguous:
parse_date("01/02/2013", locale = locale(date_format = "%d/%m/%Y"))


# 4. If you live outside the US, create a new locale object that encapsulates the
# settings for the types of files you read most commonly
locale("zh")
parse_date("一月 26 2015", "%B %d %Y", locale = locale("zh"))

# 5. What's the difference between read_csv() and read_csv2()
?read_csv
# read_csv() and read_tsv() are special cases of the general read_delim(). 
# They're useful for reading the most common types of flat file data, comma 
# separated values and tab separated values, respectively. read_csv2() uses ; 
# for separators, instead of ,. This is common in European countries which use , 
# as the decimal separator.

# 5. What are the most common encoding used in Europe? What are the most common encoding
# used in Asia? Do some googling to find out
# Europe: Latin2 Latin3 Baltic Cyrillic
# Asia: Big5 GB18030 Shift-JIS

# 6. Generate the correct format string to parse each of the following dates and times:
d1 <- "January 1, 2010"
d2 <- "2015-Mar-07"
d3 <- "06-Jun-2017"
d4 <- c("August 19 (2015)", "July 1 (2015)")
d5 <- "12/30/14" # Dec 30, 2014
t1 <- "1705"
t2 <- "11:15:10.12 PM"

parse_date(d1, "%B %d, %Y")
parse_date(d2, "%Y-%b-%d")
parse_date(d3, "%d-%b-%Y")
parse_date(d4, "%B %d (%Y)")
parse_date(d5, "%m/%d/%y")
library(hms)
parse_time(t1, "%H%M")
parse_time(t2, "%I:%M:%S.%OS %p") # Not sure what that .12 is

# Parsing a File
# readr contains a CSV file that illustrates the problems in parsing files
challenge <- read_csv(readr_example("challenge.csv"))
# It is always good to pull out the problems(), so you can explore them in more depth
problems(challenge)

# A good strategy is to work column by column until there are no problems remaining
# Lots of parsing problems with x column
# To fix, start by copying and pasting the column specification into your original call
challenge <- read_csv(readr_example("challenge.csv"), col_types = cols(x = col_integer(), y = col_character()))
# Then you can tweak the type of the x column:
challenge <- read_csv(readr_example("challenge.csv"), col_types = cols(x = col_double(), y = col_character()))
# That fixes the first problem, but if we look at the last few rows, you'll see that they'are dates stored
# in a character vector"
tail(challenge)
# You can fix that by specifying that y is a date column:
challenge <- read_csv(readr_example("challenge.csv"), col_types = cols(
  x = col_double(), y = col_date()
))
tail(challenge)

# Other Strategies
# There are a few other general strategies to help you parse files:
# In the previous example, we just got unlucky
# If we look at one more row than the default, we can correctly parse in one shot:
challenge2 <- read_csv(readr_example("challenge.csv"),
                       guess_max = 1001)
challenge2
# Sometimes it is easier to diagnose problems if you just read in all the columns
# as character vectors
challenge2 <- read_csv(readr_example("challenge.csv"),
                       col_types = cols(.default = col_character()))
challenge2
# This is particularly useful in conjunction with type_convert(), which applies the parsing
# heuristics to the character columns in a data frame
df <- tribble(
  ~x, ~y,
  "1", "1.21",
  "2", "2.32",
  "3", "4.56"
)
df
#Note the column types
type_convert(df)

# Writing to a File
# readr also comes with two useful functions for writing data back to the disk
# write_csv() and write_tsv()
# Both functions increase the chances of the output file bveing read back in correctly
# But once you saved to CSV, the type information is lost, and you have to re-create the
# column specification every time you load in. So there are two alternatives:
# --- write_rds() and read_rds()
# These are uniform wrappers around the base functions readRDS() and saveRDS().
# These store data in R's custom binary format called RDS:
write_rds(challenge, "challenge.rds")
read_rds("challenge.rds")

# The feather package implements a fast binary file format that can be shared across prgramming
# languages
# install.packages("feather")
library(feather)
write_feather(challenge, "challenge.feather")
read_feather("challenge.feather")
