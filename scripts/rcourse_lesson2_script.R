setwd("C:/Users/nade/Desktop/Data Analysis R")
### I use this as the statistics script for rcourse_lesson2
### READ IN DATA ###
source("scripts/rcourse_lesson2_cleaning.R")

### We are not loading additional packages ###

### Organize Data ###
data_stats <- data_clean

### Build model - Proportion of Nicole's by Year (continuous predictor) ###
year.lm <- lm(prop_log10 ~ year, data = data_stats)
summary(year.lm)
### We can check the residuals by using the following codes
year.lm.residual <- resid(year.lm)
head(year.lm.residual)

### Second analysis 
### Build Model - Proportion of 'Nicole' by Gender (Categorical predictor) ###
genderlm <- lm(prop_log10 ~ sex, data = data_stats)
summary(genderlm)
# save the residuals
genderlm.residuals <- resid(genderlm)
head(genderlm.residuals)
