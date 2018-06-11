### READ IN DATA ###
source("scripts/rcourse_lesson4_cleaning.R")

### LOAD PACKAGES ###
library(ggplot2)

### ORGANIZE DATA ###
# Since R codes variables alphabetically, currently "tng", 
# for "The Next Generation", will be plotted before "tos", 
# for "The Original Series", which is not desirable since 
# chronologically it is the reverse.

# So, using the "mutate()" and "factor()" calls I'm going 
# to change the order of the levels so that it's "tos" and 
# then "tng". I'm also going to update the actual text with 
# the "labels" setting so that the labels are more informative and complete.

data_figs = data_clean %>%
  mutate(series = factor(series, levels = c("tos", "tng"),
                         labels = c("The Original Series", "The Next Generation")))

# Just as in Lesson 3 when we summarised our "0"s and "1"s for our 
# logistic regression into a percentage, we'll do the same thing here. 
# In this example we group by our two independent variables, "series" 
# and "alignment", and then get the mean of our dependent variable, 
# "extinct". Finally, we end our call with "ungroup()".

# Summarize data by series and alignment
data_figs_sum = data_figs %>%
  group_by(series, alignment) %>%
  summarise(perc_extinct = mean(extinct) * 100) %>%
  ungroup()

# To plot
# Something new is the "fill" attribute. This is how we get grouped barplots.
# So, first there will be separate bars for each series, and then two 
# bars within "series", one for each "alignment" level.

# The "fill" attribute says to use the fill color of the bars to show which 
# is which level. The "geom_bar()" call we've used before, but the addition 
# of the "position = "dodge" " tells R to put the bars side by side instead 
# of on top of each other in the grouped portion of the plot.

# The next line we used last time to set the range of the y-axis, 
# but the final two lines of the plot are new. The call "geom_hline()" 
# is used to draw a vertical line on the plot.


# I've chosen to draw a line where y is 50 to show chance, 
# thus "yintercept = 50". The final line of code manually sets the colors.

### MAKE FIGURES ###
extinct.plot = ggplot(data_figs_sum, aes(x = series, y = perc_extinct, fill = alignment)) +
  geom_bar(stat = "identity", position = "dodge") +
  ylim(0, 100) +
  geom_hline(yintercept = 50) +
  scale_fill_manual(values = c("red", "yellow")) +
  ggtitle("Percentage of Possibly Extinct Aliens\nby Series and Alignment") +
  xlab("Star Trek series") +
  ylab("Percentage of species\nlikely to become extinct") +
  theme_classic() +
  theme(text = element_text(size=10), title = element_text(size=12), legend.position = "top")
# save as pdf
pdf("figures/rcourse_lesson4_extinct.pdf")
extinct.plot
dev.off()

### DONE ###
