### Chapter 2 Workingflow: Basics ###
# Exercises:

# 1. Why does this code not work?
# Answer: The error says there is not such variable, simply means we
# typed the wrong name

# 2. Tweak each of the following R commands so that they run correctly

library(tidyverse)
ggplot(dota = mpg) +
  geom_point(mapping = aes(x = displ, y = hwy))

filter(mpg, cyl = 8)
filter(diamond, carat > 3)

# Correct version:
library(tidyverse)
ggplot(data = mpg) + # data, not dota
  geom_point(mapping = aes(x = displ, y = hwy))

filter(mpg, cyl == 8) # == instead of =
filter(diamonds, carat > 3) # diamonds instead of diamond

# 3. Press Alt-Shift-K. What happens? How can you get the same place using the menus?
# Use the Tools' Keyboard Shortcut Help up in the tool bar menu
