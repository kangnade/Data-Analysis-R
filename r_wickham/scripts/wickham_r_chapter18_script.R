
# Model Basics with modelr ------------------------------------------------

### LOAD PACKAGES ###
library(tidyverse)
library(modelr)
options(na.action = na.warn)


# A Simple Model ----------------------------------------------------------

# Use simulated dataset sim1
ggplot(sim1, aes(x, y)) +
  geom_point()
sim1
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
sim1$y - model1(c(7, 1.5), sim1) # this has 30 values because sim1 has 30 values
sim1 # sim1 has 30 values for x and y
# but then, 1 pair of vector with 30 rows of x and y has a mean value for 1 output
# each measure_difference has one value

# Now we can use purrr to compute the distance for all the models defined previously
# We need a helper function because our distance function expects the model as numeric
# vector of length 2:
sim1_dist <- function(a1, a2){
  measure_difference(c(a1, a2), sim1)
}
# this one has 250 vector values, each is computed with 1 measure difference, so it has
# a total of 250 values
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
# 1.One downside of the linear model is that it is sensitive to unusual values 
# because the distance incorporates a squared term. Fit a linear model to the simulated 
# data below, and visualise the results. Rerun a few times to generate different 
# simulated datasets. What do you notice about the model?

?tibble
sim1a <- tibble(
  x = rep(1:10, each = 3),
  y = x * 1.5 + 6 + rt(length(x), df = 2)
)

# run once and plot result
ggplot(sim1a, aes(x, y)) +
  geom_point(size = 2, color = "grey30") +
  geom_smooth(method = "lm")

simt <- function(i){
  tibble(
    x = rep(1:10, each = 3),
    y = x * 1.5 + 6 + rt(length(x), df = 2),
    id = i
  )
}
?map_df
?rep
?facet_wrap
?rt
result <- map_df(1:15, simt)

ggplot(result, aes(x, y)) +
  geom_point() +
  geom_smooth(method = "lm", se = FALSE, color = "red") +
  facet_wrap(~ id, ncol = 4)

# If we do the same thing with normal distribution?
sim_norm <- function(i){
  tibble(
    x = rep(1:10, each = 3),
    y = x * 1.5 + 6 + rnorm(length(x)),
    id = i
  )
}
result_norm <- map_df(1:15, sim_norm)
ggplot(result_norm, aes(x, y)) +
  geom_point() +
  geom_smooth(method = "lm", se = FALSE, color = "red") +
  facet_wrap(~ id, ncol = 4)
# There were outliers in dt() student t distribution, while 
# there are no outliers in normal distribution

  
tibble(
  x = seq(-5, 5, length.out = 100),
  normal = dnorm(x),
  student_t = dt(x, df = 2)
) %>%
  gather(distribution, density, -x) %>%
  ggplot(aes(x = x, y = density, colour = distribution)) +
  geom_line()

# 2. One way to make linear models more robust is to use a different distance measure. For example, instead of
# root-mean-squared distance, you could use mean-absolute distance:
sim1a
measure_distance <- function(mod, data) {
  diff <- data$y - make_prediction(mod, data)
  mean(abs(diff))
}

# make a function called prediction, take vectors of length 2, with 1 as intercept, and 2 as slope
make_prediction <- function(vec, data){
  vec[1] + vec[2]*data$x
}

# Use sim1a data
best <- optim(c(0,0), measure_distance, data = sim1a)
best$par

# 3. One challenge with performing numerical optimization is that it’s only guaranteed to find a local optimum.
# What’s the problem with optimizing a three parameter model like this?
model3 <- function(a, data) {
  a[1] + data$x * a[2] + a[3]
}
measure_distance_3 <- function(a, data) {
  diff <- data$y - model3(a, data)
  sqrt(mean(diff ^ 2))
}
best3a <- optim(c(0, 0, 0), measure_distance_3, data = sim1)
best3a$par


# Visualizing Models ------------------------------------------------------

sim1_mod <- lm(data = sim1, y~x)
summary(sim1_mod)

# Predictions
# To visualize the predictions from a model, we start by generating an evenly spaced grid of values
# that covers the region where our data lies
# Use modelr:data_grid()
grid <- sim1 %>%
  data_grid(x)
grid
# This generates the x values in grid

# Next we can predit. Use modelr::add_predictions()
grid <- grid %>%
  add_predictions(sim1_mod)
grid  

# Next we plot the predictions
ggplot(sim1, aes(x)) +
  geom_point(aes(y = y)) +
  geom_line(
    aes(y = pred),
    data = grid,
    color = "red",
    size = 1
  )

# Residuals
# Residuals tell you what the model has missed
# Residuals are just the distances between the observed and predicted values
# We add residuals to data with add_residuals(), which works just like add_predictions
# Just supply the linear model that used for the data frame
sim1 <- sim1 %>%
  add_residuals(sim1_mod)
sim1

# Draw a frequency polygon to help use understand the spread of the residuals
ggplot(sim1, aes(resid)) +
  geom_freqpoly(binwidth = 0.5)

# You often want to re-crate plots using the residuals instead of the original predictor
ggplot(sim1, aes(x, resid)) +
  geom_ref_line(h = 0) +
  geom_point()
# Looks just like random noise, which means the data is good


# Residuals Exercises -----------------------------------------------------

# 1. Instead of using lm() to fit a straight line, you can use loess() to fit a smooth curve. 
# Repeat the process of model fitting, grid generation, predictions, and visualisation on sim1 
# using loess() instead of lm(). How does the result compare to geom_smooth()?

# First check how to use loess()
?loess
sim1_mod_loess <- loess(y~x, data = sim1) 
sim1_mod <- lm(y~x, data= sim1)

sim_2 <- sim1 %>%
  add_predictions(sim1_mod) %>%
  add_residuals(sim1_mod) %>%
  add_predictions(sim1_mod_loess, var = "loess_predictions") %>%
  add_residuals(sim1_mod_loess, var = "loess_residuals")
sim_2

# Plot predictions
ggplot(sim_2, aes(x = x)) +
  geom_point(aes(y = y)) +
  geom_line(aes(y = loess_predictions), size = 2, color = "red")

# Plot residuals
ggplot(sim_2, aes(x = x)) +
  geom_point(aes(y = resid)) +
  geom_point(aes(y = loess_residuals), color = "red", size = 2)

# 2. add_predictions() is paired with gather_predictions() and spread_predictions(). 
# How do these three functions differ?
?gather_predictions
# add_predictions(data, model, var = "pred")
# gather_predictions(data, ..., .pred = "pred", .model = "model")
# The function gather_predictions adds predictions from multiple models by stacking the results and adding
# a column with the model name,

# as we can see, using add_predictions to add predicts from two models involves:
# DO NOT RUN
sim_3 <- sim1 %>%
  add_predictions(sim1_mod) %>%
  add_predictions(sim1_mod_loess, var = "loess_predictions") 
# But if we use gather_predictions()
test <- sim1
test
test %>% 
  gather_predictions(sim1_mod, sim1_mod_loess)

# The function gather_predictions adds predictions from multiple models by stacking the results and adding
# a column with the model name,

# The function spread_predictions adds predictions from multiple models by adding multiple columns (postfixed
# with the model name) with predictions from each model.

test %>%
  spread_predictions(sim1_mod, sim1_mod_loess)

# We can also add arguments to the gather_predictions()
test %>% 
  gather_predictions(sim1_mod, sim1_mod_loess) %>%
  spread(model, pred) # spread the result model and pred columns


# 3. What does geom_ref_line() do? What package does it come from? Why is displaying a reference line in
# plots showing residuals useful and important?

# The geom geom_ref_line() adds as reference line to a plot.

# 4. Why might you want to look at a frequency polygon of absolute residuals? What are the pros and cons
# compared to looking at the raw residuals?

# Basically we want to check the residuals
# The freq_ploy shows the absolute values of the residuals
# However, simply using absolute values will miss information about the residuals such as the signs of the residuals


# Formulas and Model Families ---------------------------------------------

# If you want to see what R does in a formula, use model_matrix() function
# For example
df <- tribble(
  ~y, ~x1, ~x2,
  4, 2, 5,
  5, 1, 6
)
model_matrix(df, y ~ x1)

# R always add a column of intercept there
# If you do not want intercept, type -1 to drop it:
model_matrix(df, y ~ x1 - 1)

# The model matrix grows in an unsurprising way when you add more variables
model_matrix(df, y ~ x1 + x2)

# Categorical Variables
df <- tribble(
  ~ sex, ~ response,
  "male", 1,
  "female", 0,
  "male", 1
)
# R converts the sex variable where sex_male appears, and sex_male is 1 if sex is male
# and 0 otherwise
model_matrix(df, response ~ sex)

# Visualize data
ggplot(sim2) + 
  geom_point(aes(x, y))
  
sim2

# We can fit a model to it and generate predictions
mod2 <- lm(y ~ x, data = sim2)
grid <- sim2 %>%
  data_grid(x) %>%
  add_predictions(mod2)
grid
# We can visualize it
ggplot(sim2, aes(x)) +
  geom_point(aes(y = y)) +
  geom_point(data = grid,
             aes(y = pred),
             color = "red",
             size = 4)

# Interactions (Continuous and Categorical)
# What happens when you combine a continuous and a categorical variable?
# We use sim3
ggplot(sim3, aes(x1, y)) +
  geom_point(aes(color = x2))
sim3

# There are two models:
mod1 <- lm(y ~ x1 + x2, data = sim3)
mod2 <- lm(y ~ x1 * x2, data = sim3)
# Interactions of two variables is used *

# To visualize, we need to give data_grid() both variables
# To generate predictions from both models simultaneously, we can use
# gather_predictions().
grid <- sim3 %>%
  data_grid(x1, x2) %>%
  gather_predictions(mod1, mod2) 
grid
# Do not spread the gather_predictions because we need it to plot the graph

# We can visualize results for both models on one plot using facet
ggplot(sim3, aes(x1, y, color = x2)) +
  geom_point() +
  geom_line(data = grid, aes(y = pred)) +
  facet_wrap(~ model)

# Which model is better?
# We can take a look at the residuals
sim_3 <- sim3 %>%
  gather_residuals(mod1, mod2)
sim_3
ggplot(sim_3, aes(x1, resid, color = x2)) +
  geom_point() +
  facet_grid(model ~ x2)

# Interactions (Tow Continuous)
# Use sim4
sim4
mod1 <- lm(y ~ x1 + x2, data = sim4)
mod2 <- lm(y ~ x1 * x2, data = sim4)
grid <- sim4 %>%
  data_grid(
    x1 = seq_range(x1, 5),
    x2 = seq_range(x2, 5)
  ) %>%
  gather_predictions(mod1, mod2)
grid

# Note the use of seq_range() in data_grid()
# Instead of using every unique value of x, the author was going to use
# a regularly spaced grid of five values between minimum and maximum numbers
# It's probably not super important here, but it's a useful technique in general
# There are three other useful arguments to seq_range()
?seq_range

# --- pretty = TRUE
# This will generate something that looks nice to human eye
seq_range(c(0.0123, 0.923423), n = 5)
seq_range(c(0.0123, 0.923423), n = 5, pretty = TRUE)

# --- trim = 0.1
# This will trim off 10% of the tail values. This is useful if the variable has 
# long-tailed distribution and you want to focus on generating values near that center
x1 <- rcauchy(100)
seq_range(x1, n = 5)
seq_range(x1, n = 5, trim = 0.1)
seq_range(x1, n = 5, trim = 0.25)
seq_range(x1, n = 5, trim = 0.5)
# expand = 0.1 is the opposite of trim = 0.1
seq_range(x1, n = 5, expand = 0.1)

# Now let's try and visualize the model. We have two continuous predictors, so
# you can imagine the model like a 3D surface. We could display that using geom_tile()
ggplot(grid, aes(x1, x2)) +
  geom_tile(aes(fill = pred)) +
  facet_grid(~ model)
# This graph doesn't show much difference between the two models

ggplot(grid, aes(x1, pred, color = x2, group = x2)) +
  geom_line() +
  facet_wrap(~ model)

ggplot(grid, aes(x2, pred, color = x1, group = x1)) +
  geom_line() +
  facet_wrap(~ model)

# Transformations
# If you have x, but not x^2, within the model, you can use I(x^2) to create one

df <- tribble(
  ~y, ~x,
  1,  1,
  2,  2, 
  3,  3
)
model_matrix(df, y ~ x^2 + x)
model_matrix(df, y ~ I(x^2) + x)
model_matrix(df, y ~ poly(x, 2))

# However there’s one major problem with using poly(): outside the range of the data, polynomials rapidly 
# shoot off to positive or negative infinity. One safer alternative is to use the natural spline, splines::ns().
library(splines)
model_matrix(df, y ~ ns(x, 2))

# Let’s see what that looks like when we try and approximate a non-linear function:
sim5 <- tibble(
  x = seq(0, 3.5 * pi, length = 50),
  y = 4 * sin(x) + rnorm(length(x))
)
ggplot(sim5, aes(x, y)) +
  geom_point()

mod1 <- lm(y ~ ns(x, 1), data = sim5)
mod2 <- lm(y ~ ns(x, 2), data = sim5)
mod3 <- lm(y ~ ns(x, 3), data = sim5)
mod4 <- lm(y ~ ns(x, 4), data = sim5)
mod5 <- lm(y ~ ns(x, 5), data = sim5)

grid <- sim5 %>% 
  data_grid(x = seq_range(x, n = 50, expand = 0.1)) %>% 
  gather_predictions(mod1, mod2, mod3, mod4, mod5)
grid

ggplot(sim5, aes(x, y)) + 
  geom_point() +
  geom_line(data = grid, aes(y = pred), colour = "red") +
  facet_wrap(~ model)


# Transformations Exercises -----------------------------------------------

# 1. What happens if you repeat the analysis of sim2 using a model without an intercept. 
# What happens to the model equation? What happens to the predictions?

# Apply -1 in the model to drop the intercept
sim2
mod2_1 <- lm(y ~ x - 1, data = sim2)
mod2_0 <- lm(y ~ x, data = sim2)

grid <- sim2 %>%
  data_grid(x) %>%
  spread_predictions(mod2_1, mod2_0)
grid

# The result is the same

# 2. Use model_matrix() to explore the equations generated for the models 
# I fit to sim3 and sim4. Why is * a good shorthand for interaction?
q2mod3 <- model_matrix(y ~ x1 * x2, data = sim3)
q2mod3
q2mod4 <- model_matrix(y ~ x1 * x2, data = sim4)
q2mod4

# 3. Don't know how to do

# 4. For sim4, which of mod1 and mod2 is better? I think mod2 does a slightly better job at removing patterns,
# but it’s pretty subtle. Can you come up with a plot to support my claim?