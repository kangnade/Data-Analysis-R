setwd("C:/Users/nade/Desktop/Data Analysis R")

### Source the cleaning script ###
source("scripts/rcourse_lesson3_cleaning.R")

### LOAD PACKAGES ###
library(ggplot2)

# Change order level of variable for figure
# So that before comes before after
data_figs <- data_clean %>%
  mutate(allstar_break = factor(allstar_break, levels = c("before", "after")))

# Since we are dealing with categoritcal data, we use barplot
# to do so, we use group_by() and summarize() methods in dplyr
# we find mean of "win" before and after allstar_break
# multiply the mean by 100, so it looks like a percentage
# finally we have to ungroup() so that in future analysis, the group is not there

### Summarize full season data by All-star break
data_figs_sum <- data_figs %>%
  # select what to group the data by
  group_by(allstar_break) %>%
  # select summarized value to be created
  summarise(wins_perc = mean(win) * 100) %>%
  # ungroup data
  ungroup()

# Player specific data
data_posey_figs = data_posey_clean

# Summarize player specific data by whether walked or not
data_posey_figs_sum = data_posey_figs %>%
  group_by(walked) %>%
  summarise(wins_perc = mean(win) * 100) %>%
  ungroup()

### MAKE FIGURES ###
# All-star Break
allstar.plot = ggplot(data_figs_sum, aes(x = allstar_break, y = wins_perc)) +
  # make the figure a barplot
  #"stat = "identity" " tells ggplot2 to use the specific numbers in our data frame
  geom_bar(stat = "identity") +
  # set y-axis range from 0 to 100
  ylim(0, 100) +
  # add a title
  ggtitle("Percentage of Games Won Before and After All-Star Break") +
  # Customize the x-axis
  xlab("Before or After All-Star Break") +
  # Customize the y-axis
  ylab("Percentage of Games won") +
  # Remove dark background
  theme_classic() +
  # add additional parameters to display the plot
  theme(text = element_text(size=10), title = element_text(size=12))

# Write figure and save to pdf
pdf("figures/rcourse_lesson3_allstar.pdf")
allstar.plot
dev.off()

# Posey walked or not plot
posey_walked.plot = ggplot(data_posey_figs_sum, aes(x = walked, y = wins_perc)) +
  # make barplot
  geom_bar(stat = "identity") +
  # set y-axis range from 0 to 100
  ylim(0, 100) +
  # add a title
  ggtitle("Percentage of Games won depending on if Posey walked or not") +
  # customize x-axis
  xlab("Posey walked during the game or not") +
  # customize y-axis
  ylab("Percentage of Games won") +
  # remove dark background
  theme_classic() +
  # add additional parameters to display the plot
  theme(text = element_text(size=10), title = element_text(size=12))

# save to pdf
pdf("figures/rcourse_lesson3_posey_walked.pdf")
posey_walked.plot
dev.off()

### Done With Figures ###


