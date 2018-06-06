### THIS source() tells us the run another script ###
source("scripts/rcourse_lesson2_cleaning.R")

### LOAD PACKAGE FOR FIGURES ###
library(ggplot2)

### Organize data ###
data_figs <- data_clean %>%
  mutate(sex = factor(sex, levels = c("F", "M"), labels =c("female", "male")))
### update labels for sex for nicer figures

### We will make further changes ###

### To run regression, we need to check if the dependent variable has a normal
### distribution, which is the assumption of regression analysis

### MAKE FIGURES ###
# Histogram of dependent variable (proportion of Nicole's)
name.plot = ggplot(data_figs, aes(x = prop)) + geom_histogram()
name.plot

# Save the figure in the folder 'figures'
pdf("figures/rcourse_lesson2_name.pdf")
name.plot
# close device
dev.off()

# As we can see from the histogram, the distribution of the prop
# of the name "Nicole" is not normally distributed, therefore, we
# cannot apply linear regression directly

### One of the solutions is to take log transform
# In R, the default log() is based on natural e
# If we want to use base 10, we write log10()

### Go back to cleaning sheet to make the log transform ###

### Histogram of dependent vairable (number of Nicole's) - e based log transform
name_log2.plot <- ggplot(data_figs, aes(x = prop_loge)) +
  geom_histogram()
name_log2.plot
# save the pdf file in figures folder
pdf("figures/rcourse_lesson2_name_log2.pdf")
name_log2.plot
dev.off()

### Histogram of dependent varaible (number of Nicole's) - 10 based log transform
name_log10.plot <- ggplot(data_figs, aes(x = prop_log10)) + 
  geom_histogram()
name_log10.plot
# save the pdf file in figures folder
pdf("figures/rcourse_lesson2_name_log10.pdf")
name_log10.plot
dev.off()

### ATTENTION ###
### My histograms of log transform still do not look normally distributed
### Theoretically, this means my data cannot be applied to linear regression analysis
### However, since this is a practice following Page Piccinini's Rcourse
### I will continue with this "wrong" dataset

### Let's make a graph of how the popularity of the name "Nicole" changes over time
# We are using variable time(year) and log10 transform prop_log10
# to add a regression line, we use geom_smooth() and set method="lm"
popularity.plot <- ggplot(data_figs, aes(x = year, y = prop_log10)) +
  # make the figure scatterplot
  geom_point() +
  # add a regression line-lm method
  geom_smooth(method = "lm") +
  # add title
  ggtitle("Proportion of People with Name 'Nicole' Over Time") +
  # customize x axis
  xlab("Year") +
  # customize y axis
  ylab("Proportion of People with Log10 Transform") +
  # remove dark background
  theme_classic() +
  # additional parameters for displaying the plot
  theme(text = element_text(size = 10), title = element_text(size=10))
pdf("figures/rcourse_lesson2_popularityOfName.pdf")
popularity.plot
dev.off()

### Proportion of "Nicole" by gender(sex) Categorical predictor
gender.plot <- ggplot(data_figs, aes(x = sex, y = prop_log10)) +
  geom_boxplot(aes(fill = sex)) +
  ggtitle("Proportion of People with Name 'Nicole' by Gender") +
  xlab("Gender") +
  ylab("Proportion of People log10 transform") +
  theme_classic() +
  theme(text = element_text(size = 10), title = element_text(size = 10),
        legend.position = "none", legend.key = element_blank())
gender.plot
pdf("figures/rcourse_lesson2_nameByGender.pdf")
gender.plot
dev.off()
