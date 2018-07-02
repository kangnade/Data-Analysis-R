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
# Basic Matches
# Use str_view() and str_view_all()
# Appears in Viewer to the lower right corner of RStudio
str_view(univ, "U")

# Next we can step up in complexity, . , which matches any character
str_view(univ, ".U.")

# Match .
dot <- "\\."
writeLines(dot)

# This tells R to look for an explicit
str_view(c("abv", "a.c", "bef"), "a\\.c")

# 1. Explain why each of these strings don’t match a \: "\", "\\", "\\\".
# "\": This will escape the next character in the R string.
#  "\\": This will resolve to \ in the regular expression, which will escape the next character in the
# regular expression.
# "\\\": The first two backslashes will resolve to a literal backslash in the regular expression, the third
# will escape the next character. So in the regular expression, this will escape some escaped character.

# 2. How would you match the sequence "'\ ?
str_view("\"'\\", "\"'\\\\")

# 3. What patterns will the regular expression \..\..\.. match? How would you represent it as a string?
str_view(c(".a.b.c", ".a.b", "....."), c("\\..\\..\\.."))

# Anchors
# regular expressions will match any part of a string. It is often useful to anchor the regular expression so that
# it matches from the start or end of the string
# --- ^ to match the start of the string
# --- $ to match the end of the string
# To force a regular expression to only match a complete string, anchor it with both ^ and $
x <- c("apple", "apple juice", "apple pie")
str_view(x, "apple")
str_view(x, "^apple$")

# Exercises
# 1. How would you match the literal string "$ˆ$"?
str_view(c("$^$", "ab$^$sfas"), "^\\$\\^\\$$")

# 2。 Given the corpus of common words in stringr::words, create regular expressions that find all words that:
# 1. Start with “y”.
# 2. End with “x”
# 3. Are exactly three letters long. (Don’t cheat by using str_length()!)
str_view(stringr::words, "^y", match = TRUE)
str_view(stringr::words, "x$", match = TRUE)
str_view(stringr::words, "^...$", match = TRUE)
str_view(stringr::words, ".......", match = TRUE)

# Character Classes and Alternatives
# There are a number of special patterns that match more than one character
# \d matches any digit
# \s matches any whitespace
# [abc] matches a b or c
# [^abc] matches anything except a b c 
# Need to escape for string, so \\d, \\s

# You can use alternation to pick between one or more alternative patterns
# abv|xyz, abv|d..f
# Use parenthesis to make it clear
str_view(c("grey", "gray"), "gr(e|a)y")

# Exercises
# 1. Create regular expressions to find all words that:
# 1. Start with a vowel.
# 2. That only contain consonants. (Hint: thinking about matching “not”-vowels.)
# 3. End with ed, but not with eed.
# 4. End with ing or ise.

str_view(stringr::words, "^[aeiou]", match = TRUE)
str_view(stringr::words, "^[^aeiou]+$", match=TRUE)
str_view(stringr::words, "^ed$|[^e]ed$", match = TRUE)
str_view(stringr::words, "i(ng|se)$", match = TRUE)

# 2. Empirically verify the rule “i before e except after c”.
str_view(stringr::words, "(cei|[^c]ie)", match = TRUE)
str_view(stringr::words, "(cie|[^c]ei)", match = TRUE)

# 3. Is q'' always followed by a "u"?
str_view(stringr::words, "q[^u]", match = TRUE)

# 4. NA

# 5. Expression match telephone numbers
tele <- c("5312254", "2248450")
str_view(tele, "[0-9][0-9][0-9][0-9][0-9][0-9][0-9]")
str_view(tele, "\\d\\d\\d\\d\\d\\d\\d")

# Repetition
# Controlling how many times a pattern matches:
# ? :   0 or 1
# + :   1 or more
# * :   0 or more
x <- "1888 is the longest year in Roman numerals: MDCCCLXXXVIII"
str_view(x, "CC?")
str_view(x, "CC+")
str_view(x, 'C[LX]+')

# You can also specify the number of matches precisely:
# {n} exactly n
# {n,} n or more
# {, m} at most m
# {n, m} between n and m
str_view(x, "C{2}")
str_view(x, "C{2,}")
str_view(x, "C{2,3}")
# By default these matches are “greedy”: they will match the longest string possible. 
# You can make them “lazy”, matching the shortest string possible by putting a ? after them. 
# This is an advanced feature of regular expressions, but it’s useful to know that it exists:
str_view(x, "C{2,3}?")
str_view(x, "C[LX]+?")

# Exercises
# 1. Describe the equivalents of ?, +, * in {m,n} form.
# ? is {,1}
# + is {1,}
# * no equivalent

# 2. Describe in words what these regular expressions match: 
# (read carefully to see if I’m using a regular expression or a string that defines a regular expression.)
# 1. ˆ.*$
# 2. "\\{.+\\}"
# 3. \d{4}-\d{2}-\d{2}
# 4. "\\\\{4}"

# 3. Create regular expressions to find all words that:
# 1. Start with three consonants.
# 2. Have three or more vowels in a row.
# 3. Have two or more vowel-consonant pairs in a row.
str_view(stringr::words, "^[^aeiou]{3}")
str_view(stringr::words, "[aeiou]{,3}")
str_view(stringr::words, "([aeiou][^aeiou]){2,}")

# Grouping and Backreferences
# Earlier, you learned about parentheses as a way to disambiguate complex expressions. 
# Parentheses also create a numbered capturing group (number 1, 2 etc.). 
# A capturing group stores the part of the string matched by the part of the regular expression inside the parentheses. 
# You can refer to the same text as previously matched by a capturing group with backreferences, like \1, \2 etc.
str_view(fruit, "(..)\\1", match = TRUE)




