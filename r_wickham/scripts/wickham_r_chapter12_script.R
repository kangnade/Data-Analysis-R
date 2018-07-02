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

