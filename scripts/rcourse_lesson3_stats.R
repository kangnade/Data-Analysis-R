### READ IN DATA ###
source("scripts/rcourse_lesson3_cleaning.R")

### LOAD PACKAGES ###
# None

### ORGANIZE DATA ###
# Full-season data
data_stats = data_clean

# Player specific data
data_posey_stats = data_posey_clean

### BUILD MODEL - FULL SEASON DATA ###
# to do logistic regression, we use glm() method, the generalized linear regression
# family = "binomial" tells R we wanna run a logistic regression
allstar.glm = glm(win ~ allstar_break, family = "binomial", data = data_stats)
allstar.glm.sum = summary(allstar.glm)
allstar.glm.sum
# Intercept is positive 0.4394. This means that after the All-Star break
# (after is before before) the Giants were above 50% for the percentage
# of wins. (since 0 is chance here, postive above, negative below in logistic regress)
# p-value for intercept is 0.065, so we cannot say Giants were significantly
# above the chance after the break, but close enough
# our slope is negative 0.3028, since "before" is the default level, (before=1, after=0)
# this means that Giants had a lower percentage of wins before the All-Star break compared
# to after
# but p-value is 0.344 suggesting this is not statistically significant


### BUILD MODEL - PLAYER SPECIFIC DATA ###
# Make logistic regression
posey_walked.glm = glm(win ~ walked, family = "binomial", data = data_posey_stats)
posey_walked.glm_sum = summary(posey_walked.glm)
posey_walked.glm_sum
# Here the estimated intercept is -0.09531, "no" is the default value, so if Posey
# was NOT walked, the Giants were below 50% for winning
# although p-value tells this is not statistically significant
# the walked variable however, shows 2.49 quite positive with significant p-value
# suggesting that if Posey walked, Giants were more likely to win

