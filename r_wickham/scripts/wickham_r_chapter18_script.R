
# Model Basics with modelr ------------------------------------------------

### LOAD PACKAGES ###
library(tidyverse)
library(modelr)
options(na.action = na.warn)


# A Simple Model ----------------------------------------------------------

# Use simulated dataset sim1
ggplot(sim1, aes(x, y)) +
  geom_point()

?runif
models <- tibble(
  a1 = runif(250, -20, 40),
  a2 = runif(250, -5, 5)
)

ggplot(sim1, aes(x, y)) +
  geom_abline(
    aes(intercept = a1, slope = a2),
    data = models, alpha = 1/4
  ) +
  geom_point()
?geom_abline

# 250 models on a single plot is really bad
# We need to find a better model

# To do so, we need a function and this function takes model parameters
# and the data as inputs, and then gives values predicted by the model
model1 <- function(a, data){
  a[1] + data$x * a[2]
}
# c(intercept, slope)
model1(c(7, 1.5), sim1)

# Next, we need some way to compute an overall distance between the predicted and
# actual values. Collapse the 30 distances into one value

# In statistics, this is the root-mean-squared distance
# Compute the difference between actual and predicted, square the distance, then average
measure_difference <- function(mod, data){
  diff <- data$y - model1(mod, data)
  sqrt(mean(diff^2))
}
measure_difference(c(7, 1.5), sim1)

# Now we can use purrr to compute the distance for all the models defined previously
# We need a helper function because our distance function expects the model as numeric
# vector of length 2:
sim1_dist <- function(a1, a2){
  measure_difference(c(a1, a2), sim1)
}

models <- models %>%
  mutate(dist = purrr::map2_dbl(a1, a2, sim1_dist))
models

# Let's overlay the 10 bes models 
# color the models with -dist, +dist is the opposite, smallest gets darkest
# best models with smallest distance get the brightest colors
?aes
?color
ggplot(sim1, aes(x, y)) +
  geom_point(size = 2, color = "grey30") +
  geom_abline(aes(intercept = a1, slope = a2, color = +dist),
              data = filter(models, rank(dist)<=10))

# We can also visualize them with scatterplot of a1 versus a2
ggplot(models, aes(a1, a2)) +
  geom_point(
    data = filter(models, rank(dist) <= 10),
    size = 4, color = "red"
  ) +
  geom_point(aes(color = -dist))

# Instead of scatterplot, we could be more systematic and generate an evenly spaced grid of points
# this is called a grid search. Pick the parameters of the grid roughly by looking at where the best
# models were in the preceding plot:
?seq
grid <- expand.grid(
  a1 = seq(-5, 20, length = 25), # length = number controls the point per column and per row
  a2 = seq(1, 3, length = 25)
) %>%
  mutate(dist = purrr::map2_dbl(a1, a2, sim1_dist))
head(grid)

grid %>%
  ggplot(aes(a1, a2)) +
  geom_point(
    data = filter(grid, rank(dist) <= 10),
    size = 4, color = "red"
  ) +
  geom_point(aes(color = -dist))

# The 10 best models all looked pretty good
# Imagine making the grid finer and finer, until you narrowed the best model
# But there is a better tool called Newton-Raphson search
# You pick a starting point, and look around for the steepest slope
# You then ski down that slope a little way, and then repeat again and again
# until you cannot go any lower
# optim()
best <- optim(c(0, 0), measure_difference, data = sim1)
best$par

ggplot(sim1, aes(x, y)) +
  geom_point(size = 2, color = "grey30") +
  geom_abline(intercept = best$par[1], slope = best$par[2])

# lm() model is the one we've just worked with
lm(data = sim1, y~x)

# Exercises
