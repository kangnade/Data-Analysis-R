### Chapter 12 Factors with forcats ###

### LOAD PACKAGES ###
# forcats is not part of tidyverse
library(tidyverse)
library(forcats)

### CONTENT ###

# Creating Factors
x1 <- c("Jan", "Feb", "Mar", "Apr")
# To create a factor, we must create a list of valid levels:
month_levels <- c( "Jan", "Feb", "Mar", "Apr", "May", "Jun", 
                   "Jul", "Aug", "Sep", "Oct", "Nov", "Dec")
# Now we can create a factor
y1 <- factor(x1, levels = month_levels)
y1
# Any value not in the set will be silently converted to NA:
x2 <- c("Jan", "Febb", "Mar", "Aug", "Sepp")
y2 <- factor(x2, levels = month_levels)
y2
# If you omit levels, they'll be taken from the data in alphabetical order
factor(x1)
factor(x2)

# Sometimes you'd prefer that the order of the levels match the order of the first apprearance
# in the data. You can do that when creating the factor by setting levels to unique(x), or after the fact,
# with fct_inorder()
f1 <- factor(x1, levels = unique(x1))
f1

f2 <- f1 %>% factor() %>% fct_inorder()
f2
# To access directly to the levels, use:
levels(f2)

# General Social Survey
# The rest of the chapter focuses on forcats::gss_cat
forcats::gss_cat
# get more information with
?gss_cat

# When factors are stored in a tibble, you can't see their levels so easily. One way to see is count()
gss_cat %>%
  count(race)
ggplot(gss_cat, aes(race)) + 
  geom_bar()
# So now we see the levels are: Other, Black, and White
# By default, ggplot2 will drop values that don't have any values. You can force them to display with:
ggplot(gss_cat, aes(race)) +
  geom_bar() +
  scale_x_discrete(drop = FALSE)
# Now we see that: Other, Black, White, Not applicable

# Exercises
# 1. Explore the distribution of rincome. What makes the default bar chart hard to understand? How would you improve
# the plot?
ggplot(gss_cat, aes(rincome)) +
  geom_bar()
# The space is too crowded that you don't see the exact numbers of each income level
# To deal with long var names, we can flip the coord
ggplot(gss_cat, aes(rincome)) +
  geom_bar() +
  coord_flip()
# Or we can use the theme to change the angle of the var names
ggplot(gss_cat, aes(rincome)) +
  geom_bar() +
  theme(axis.text.x = element_text(angle = 90))

# 2. What is the most common relig in this survey? What is the most common partyid?
# From the help menu, we know that relig is religion, while partyid is the party affiliation
gss_cat %>%
  count(relig) %>%
  arrange(desc(n)) %>%
  head(10)
# We know that Protestant has 10846, which is the highest, or most common religion

# Same applies if we do it to partyid
gss_cat %>%
  count(partyid) %>%
  arrange(desc(n)) %>%
  head(5)
# So the most common partyid is independent

# 3. Which relig does denom apply to? How can you find out with a table? With visualization?
# To access the levels directly:
levels(gss_cat$denom)
# It applies to protestants
gss_cat %>%
  filter(!denom %in% c("No answer", "Other", "Don't know", "Not applicable",
                       "No denomination")) %>%
  count(relig)
# Visualization
gss_cat %>%
  count(relig, denom) %>%
  ggplot(aes(x = relig, y = denom, size = n)) +
  geom_point() +
  theme(axis.text.x = element_text(angle = 90), title = element_text(size = 9))

# Modifying Factor Order
# It is often useful to change the order of the factor levels in a visualization
# If you want to explore the avg # of hours spent watching TV per day across religions
relig <- gss_cat %>%
  group_by(relig) %>%
  summarize(age = mean(age, na.rm = TRUE),
            tvhours = mean(tvhours, na.rm = TRUE),
            n = n())
ggplot(relig, aes(tvhours, relig)) + geom_point()  

# It is hard to read this plot
# To improve, we use fct_reorder().
# fct_reorder(factor f, x - numeric vector to reorder, option)
ggplot(relig, aes(tvhours, fct_reorder(relig, tvhours))) + geom_point()
# Reordering religion makes it much easier to see that people in the "Don't know" category
# watch much more TV.

# Complex trasnformation should be done in mutate() rather than in aes()
# such as:
relig %>%
  mutate(relig = fct_reorder(relig, tvhours)) %>%
  ggplot(aes(tvhours, relig)) +
  geom_point()

# What if we want a similar plot looking at how average age varies across income level?
rincome <- gss_cat %>%
  group_by(rincome) %>%
  summarize(age = mean(age, na.rm = TRUE),
            tvhours = mean(tvhours, na.rm = TRUE),
            n = n())
ggplot(rincome, aes(age, fct_reorder(rincome, age))) +
  geom_point()
# Here it does make sense to pull "Not applicable" to the front with the other special
# levels.
# You can use fct_relevel(). It takes a factor f, and then any number of levels that you want to
# move to the front of the line
ggplot(rincome, aes(age, fct_relevel(rincome, "Not applicable"))) + geom_point()

# Another type of reordering is useful when you are coloring the lines on a plot
# fct_reorder2() reorders factor by the y values associated with the largest x values.
# This makes the plot easier to read because the line colors line up with the legend:
by_age <- gss_cat %>%
  filter(!is.na(age)) %>%
  count(age, marital) %>%
  group_by(age) %>%
  mutate(prop = n / sum(n))

ggplot(by_age, aes(age, prop, colour = marital)) +
  geom_line(na.rm = TRUE)

ggplot(by_age, aes(age, prop, colour = fct_reorder2(marital, age, prop))) +
  geom_line() +
  labs(colour = "marital")

# Finally, for bar plots, you can use fct_infreq() to order levels in increasing frequency
gss_cat %>%
  mutate(marital = marital %>% fct_infreq() %>% fct_rev()) %>%
  ggplot(aes(marital)) +
  geom_bar()
# fct_rev() in reverse order

# Exercises
# 1`. There are some surprisingly high numbers in tvhours, is this a good summary?
summary(gss_cat[["tvhours"]])
gss_cat %>%
  filter(!is.na(tvhours)) %>%
  ggplot(aes(x = tvhours)) +
  geom_histogram(binwidth = 1)
# Looks fine to me

# 2. For each the factor in gss_cat, identify whether the order of the levels is arbitrary
# or principled
# Need to use something in Chapter 21
keep(gss_cat, is.factor) %>% names()
# There are five six categorical variables: marital, race, rincome, partyid, relig, denom.
levels(gss_cat[["marital"]])
gss_cat %>%
  ggplot(aes(x = marital))+
  geom_bar()
# ordering in marital is somewhat principled
# Check race:
levels(gss_cat[["race"]])
gss_cat %>%
  ggplot(aes(race)) +
  geom_bar() +
  scale_x_discrete(drop = FALSE)
# The race level is principled

# 3. Why did moving “Not applicable” to the front of the levels move it to the bottom of the plot?
# Because that gives the level “Not applicable” an integer value of 1.