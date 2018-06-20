# install.packages("tidyverse")
setwd("C:/Users/nade/Desktop/Data Analysis R")

### LOAD PACKAGE ###
library(tidyverse)

# Chapter 1 Data Visualization with ggplot2

# ###First Steps###

# I made some adjustments to the original code in the book "R for Data Science"
# written by Dr. Hadley Wickham
# This is the first plot in the book
# Use theme(plot.title = element_text(hjust = 0.5)) to center the title
# Use expression(atop("","")) to separate the long title
first <- ggplot(data = mpg) +
  geom_point(mapping = aes(x = displ, y = hwy)) +
  ggtitle(expression(atop("Relationship between engine size","and fuel efficiency"))) +
  xlab("Engine Size") +
  ylab("Fuel Efficiency") +
  theme_classic() +
  theme(title = element_text(size = 18), text = element_text(size = 14),
        plot.title = element_text(hjust = 0.5))
first
png("r_wickham/figures/chapter1/r_for_data_science_wickham_textbook_first_displ_hwy_plot.png")
first
pdf("r_wickham/figures/chapter1/r_for_data_science_wickham_textbook_first_displ_hwy_plot.pdf")
first
dev.off()

# A Graphing Template
# Exercises:
# 1. Run ggplot(data = mpg). What do you see?
testq1 <- ggplot(data = mpg)
testq1
# Answer: we see noting except grey background

# 2. How many rows are in mtcars? How many columns?
dim(mtcars)
# Answer: Using dim() function we get 32 rows and 11 columns in mtcars

# 3. What does the drv variable describe? Read the help for ?mpg to find out.
?mpg
# Answer:f = front-wheel drive, r = rear wheel drive, 4 = 4wd

# 4. Make a scatter plot of hwy(high way miles per gallon) versus cyl(city miles per gallon)
View(mpg)
hwy_cyl_Q4 <- ggplot(data = mpg, mapping = aes(x = cyl, y = hwy)) +
  geom_point(mapping = aes(color = year)) +
  ggtitle(expression(atop("Highway miles per gallon against","City miles per gallon Plot"))) +
  xlab("City Miles Per Gallon") +
  ylab("Highway Miles Per Gallon") +
  theme(title = element_text(size = 16), text = element_text(size = 14),
        legend.position = "top", plot.title = element_text(hjust = 0.5))

pdf("r_wickham/figures/chapter1/r_for_data_science_wickham_exercise_hwy_cyl_plot.pdf")
hwy_cyl_Q4
dev.off()
png("r_wickham/figures/chapter1/r_for_data_science_wickham_exercise_hwy_cyl_plot.png")
hwy_cyl_Q4
dev.off()
hwy_cyl_Q4

# 5. What happens if you make a scatterplot of class versus drv? Why is the plot not useful
class_drv_Q5 <- ggplot(data = mpg, mapping = aes(x = class, y = drv)) +
  geom_point()
class_drv_Q5
# It doesn't help because these two are both categorical data

# ###Aesthetic Mappings###

# Book's plot of displ(engine displacement in litres) against hwy(highway m/p gallon)
hwy_displ_plot <- ggplot(data = mpg) +
  geom_point(mapping = aes(x = displ, y = hwy, color = class)) +
  ggtitle(expression(atop("Engine Displacement", "and Highway Miles Per Gallon"))) +
  xlab("Engine Displacement in Litres") +
  ylab("Highway Miles Per Gallon") +
  theme_gray() +
  theme(title = element_text(size = 16), text = element_text(size = 10),
        legend.position = "top", plot.title = element_text(hjust = 0.5))
pdf("r_wickham/figures/chapter1/r_for_data_science_wickham_textbook_displ_hwy_color_plot.pdf")
hwy_displ_plot
png("r_wickham/figures/chapter1/r_for_data_science_wickham_textbook_displ_hwy_color_plot.png")
hwy_displ_plot
dev.off()

# In addition to color, we can amp class to the size
# I addded color to the size
displ_hwy_map_size <- ggplot(data = mpg, aes(color = class)) +
  geom_point(mapping = aes(x = displ, y = hwy, size = class)) +
  ggtitle(expression(atop("Engine Displacement and", "Highway Miles Per Gallon"))) +
  xlab("Engine displacement in litres") +
  ylab("Highway miles per gallon") +
  theme_classic() +
  theme(plot.title = element_text(hjust = 0.5), title = element_text(size = 18),
        text = element_text(size = 14))
displ_hwy_map_size
pdf("r_wickham/figures/chapter1/r_for_data_science_wickham_textbook_displ_hwy_color_size_plot.pdf")
displ_hwy_map_size
png("r_wickham/figures/chapter1/r_for_data_science_wickham_textbook_displ_hwy_color_size_plot.png")
displ_hwy_map_size
dev.off()

# We can also map class to alpha aesthetics, which controls the transparency
# of the points or the shape of the points
displ_hwy_map_alpha <- ggplot(data = mpg, aes(color = class)) +
  geom_point(mapping = aes(x = displ, y = hwy, alpha = class)) +
  ggtitle(expression(atop("Engine Displacement and", "Highway Miles Per Gallon"))) +
  xlab("Engine displacement in litres") +
  ylab("Highway miles per gallon") +
  theme_classic() +
  theme(plot.title = element_text(hjust = 0.5), title = element_text(size = 18),
        text = element_text(size = 14))
displ_hwy_map_alpha
pdf("r_wickham/figures/chapter1/r_for_data_science_wickham_textbook_displ_hwy_color_alpha_plot.pdf")
displ_hwy_map_alpha
png("r_wickham/figures/chapter1/r_for_data_science_wickham_textbook_displ_hwy_color_alpha_plot.png")
displ_hwy_map_alpha
dev.off()

# We can also map to shapes:
displ_hwy_map_shape <- ggplot(data = mpg, aes(color = class)) +
  geom_point(mapping = aes(x = displ, y = hwy, shape = class)) +
  ggtitle(expression(atop("Engine Displacement and", "Highway Miles Per Gallon"))) +
  xlab("Engine displacement in litres") +
  ylab("Highway miles per gallon") +
  theme_classic() +
  theme(plot.title = element_text(hjust = 0.5), title = element_text(size = 18),
        text = element_text(size = 14))
displ_hwy_map_shape
pdf("r_wickham/figures/chapter1/r_for_data_science_wickham_textbook_displ_hwy_color_shape_plot.pdf")
displ_hwy_map_shape
png("r_wickham/figures/chapter1/r_for_data_science_wickham_textbook_displ_hwy_color_shape_plot.png")
displ_hwy_map_shape
dev.off()

# Exercises:
# 1. What's gone wrong with this code, why are the points not blue?
ggplot(data = mpg) +
  geom_point(mapping = aes(x = displ, y = hwy, color = "blue"))
# Answer: to manually set the color, the color = "blue" needs to be placed outside
# the mapping() method, in other words, you set the aesthetics by name as an
# argument of the geom_point() function, such as:
ggplot(data = mpg) +
  geom_point(mapping = aes(x = displ, y = hwy), color = "blue")

# 2. Which variables in mpg are categorical? Which are continuous?
# How can you see this information when you run mpg?
?mpg
View(mpg)
# manufacturer, trans, drv, fl, and class are categorical while the rest
# are continuous. You can use View() method to check it.

# 3. Map a continuous variable to color, size and shape. How do these
# aesthetics behave differently for categorical versus continuous variables?
cate_vs_conti_1 <- ggplot(data = mpg, aes(color = hwy)) +
  geom_point(mapping = aes(x = displ, y = hwy, shape = hwy)) +
  ggtitle(expression(atop("Engine Displacement and", "Highway Miles Per Gallon"))) +
  xlab("Engine displacement in litres") +
  ylab("Highway miles per gallon") +
  theme_classic() +
  theme(plot.title = element_text(hjust = 0.5), title = element_text(size = 18),
        text = element_text(size = 14))
cate_vs_conti_1

cate_vs_conti_2 <- ggplot(data = mpg, aes(color = hwy)) +
  geom_point(mapping = aes(x = displ, y = hwy, shape = hwy)) +
  ggtitle(expression(atop("Engine Displacement and", "Highway Miles Per Gallon"))) +
  xlab("Engine displacement in litres") +
  ylab("Highway miles per gallon") +
  theme_classic() +
  theme(plot.title = element_text(hjust = 0.5), title = element_text(size = 18),
        text = element_text(size = 14))
cate_vs_conti_2

cate_vs_conti_3 <- ggplot(data = mpg, aes(color = hwy)) +
  geom_point(mapping = aes(x = displ, y = hwy, shape = hwy)) +
  ggtitle(expression(atop("Engine Displacement and", "Highway Miles Per Gallon"))) +
  xlab("Engine displacement in litres") +
  ylab("Highway miles per gallon") +
  theme_classic() +
  theme(plot.title = element_text(hjust = 0.5), title = element_text(size = 18),
        text = element_text(size = 14))
cate_vs_conti_3

# Answer: all of the above 3 codes do not work, you get the information:
# Error: A continuous variable can not be mapped to shape
# This is because a continuous variable can be anything, thus it varies
# so much that these mapped shape, size, and color cannot generate enough
# variation to represent these variation in a continuous variable

# 4. What happens if you map the same variable to muliple aesthetics?
multi_mapping_Q4 <- ggplot(data = mpg, aes(color = class, alpha = class)) +
  geom_point(mapping = aes(x = displ, y = hwy, shape = class)) +
  ggtitle(expression(atop("Engine Displacement and", "Highway Miles Per Gallon"))) +
  xlab("Engine displacement in litres") +
  ylab("Highway miles per gallon") +
  theme_classic() +
  theme(plot.title = element_text(hjust = 0.5), title = element_text(size = 18),
        text = element_text(size = 14))
multi_mapping_Q4

# You can map to multiple aesthetics, you get a combination of these aesthetics
# for instance in the class(categorical) variable as you can see here by running the
# code above.

# 5. What does the stroke aesthetic do? What shapes does it work with?
# (Hint: use ?geom_point)
?geom_point
multi_mapping_Q5 <- ggplot(data = mpg, aes(color = class)) +
  geom_point(mapping = aes(x = displ, y = hwy, shape = class, stroke = 3.5))
multi_mapping_Q5
# Answer: For shapes that have a border (like 21), you can colour the inside and
# outside separately. Use the stroke aesthetic to modify the width of the
# border

# 6. What happens if you map an aesthetic to somethiing other than a variable name
# like ae(color = displ < 5) ?
logic_mapping_Q5 <- ggplot(data = mpg) +
  geom_point(mapping = aes(x = displ, y = hwy, color = displ < 5))
logic_mapping_Q5
# It shows you two colors, one is True, one is False, and separate the dots
# that has a value of greater than 5 than those with values less than 5
# Run the code above and check the graph.

### FACETS ###
# One way to add additional variables with aesthetics is to use facets to split
# categorical variables

# Plot by a single variable, use facet_wrap()
facet_wrap_plot <- ggplot(data = mpg) +
  geom_point(mapping = aes(x = displ, y = hwy)) +
  facet_wrap(~ class, nrow = 2) +
  ggtitle(expression(atop("Engine Displacement and", "Highway Miles Per Gallon",
                          "Separated by Class of Cars"))) +
  xlab("Engine Displacement in Litres") +
  ylab("Highway Miles Per Gallon") +
  theme(plot.title = element_text(hjust = 0.5), title = element_text(size = 16),
        text = element_text(size = 10))
facet_wrap_plot
pdf("r_wickham/figures/chapter1/r_for_data_science_wickham_textbook_displ_hwy_facet_wrap_plot.pdf")
facet_wrap_plot
png("r_wickham/figures/chapter1/r_for_data_science_wickham_textbook_displ_hwy_facet_wrap_plot.png")
facet_wrap_plot
dev.off()

# To facet plot on combination of two variables, we use facet_grid()
facet_grid_plot <- ggplot(data = mpg) +
  geom_point(mapping = aes(x = displ, y = hwy)) +
  facet_grid(drv ~ cyl) +
  ggtitle(expression(atop("Facet Grid Plot", "of Displacement and", 
                          "Highway Miles Per Gallon", "in terms of cylinders",
                          "and wheel types"))) +
  xlab("Engine Displacement in Litres") +
  ylab("Highway Miles Per Gallon") +
  theme(plot.title = element_text(hjust = 0.5), title = element_text(size = 16),
        text = element_text(size = 10))
pdf("r_wickham/figures/chapter1/r_for_data_science_wickham_textbook_displ_hwy_facet_grid_plot.pdf")
facet_grid_plot
png("r_wickham/figures/chapter1/r_for_data_science_wickham_textbook_displ_hwy_facet_grid_plot.png")
facet_grid_plot
dev.off()

# Facets Exercises:
# 1. What ahppens if you facet on a continuous variable?
facet_cont_plot <- ggplot(data = mpg) +
  geom_point(mapping = aes(x = displ, y = hwy)) +
  facet_wrap(~ cty)
facet_cont_plot
# I cannot access to the plot, or maybe there are too many that it fails to plot

# 2. What do empty cells in a plot with facet_grid(drv ~ cyl) mean? How do they
# relate to this plot?
ggplot(data = mpg) +
  geom_point(mapping = aes(x =drv, y = cyl))
View(mpg)
# There is simply no matchinig type of drv = 4 and cyl = 7 and so on

# 3. What plots does the following code make? What does . do?
ggplot(data = mpg) +
  geom_point(mapping = aes(x = displ, y = hwy)) +
  facet_grid(drv ~ .)
# This facet grid puts the data frame into rows of drv: 4, f, r and no columns
# . means no variable to shape the data frame with columns
ggplot(data = mpg) +
  geom_point(mapping = aes(x = displ, y = hwy)) +
  facet_grid(. ~ cyl)
# This is exactly the opposite with columns of cyl instead of rows with drv

# 4. Take the first faceted plot in this section
ggplot(data = mpg) +
  geom_point(mapping = aes(x = displ, y = hwy)) +
  facet_wrap(~ class, nrow = 2)
# What are the advantages to using faceting instead of color aesthetics?
# Disadvantage? Balance?
# It helps you to check for each types, better for large data when color
# doesn't work. But it doesn't show you to overall trend of each type that
# can be checked when everything is put together

# 5. Read ?facet_wrap. What does nrow do? What does ncol do? What other position
# options control the layout of the individual panels? Why doesn't facet_grid()
# have nrow and ncol variables?
?facet_wrap
?facet_grid
# nrow and ncol defines the number of rows and columns
# Other options include scales, shrink, dir, strip.position and so on
# facet_grid() doesn't have nrow and ncol because there are two variables
# involved and you cannot define the rows and columns in this situation

# 6. When using facet_grid(), you should usually put the variable wit more unique
# levels in the columns, why?
# NOT SURE
?mpg
### GEOMETRIC OBJECTS ###
geom_plot <- ggplot(data = mpg) +
  geom_smooth(mapping = aes(x = displ, y = hwy, linetype = drv)) +
  ggtitle(expression(atop("Displacement in litres", "with Highway Miles Per Gallon",
                          "by wheel type"))) +
  xlab("Engine Displacement in Litres") +
  ylab("Highway Miles Per Gallon") +
  theme(plot.title = element_text(hjust = 0.5), title = element_text(size = 16),
        text = element_text(size =  10))
pdf("r_wickham/figures/chapter1/r_for_data_science_wickham_textbook_displ_hwy_geomobj_plot.pdf")
geom_plot
png("r_wickham/figures/chapter1/r_for_data_science_wickham_textbook_displ_hwy_geomobj_plot.png")
geom_plot
dev.off()

point_smooth_class <- ggplot(data = mpg, mapping = aes(x = displ, y = hwy)) +
  geom_point(mapping = aes(color = class)) +
  geom_smooth() +
  ggtitle(expression(atop("Displacement in litres", "with Highway Miles Per Gallon",
                          "by wheel type"))) +
  xlab("Engine Displacement in Litres") +
  ylab("Highway Miles Per Gallon") +
  theme(plot.title = element_text(hjust = 0.5), title = element_text(size = 16),
        text = element_text(size =  10))
pdf("r_wickham/figures/chapter1/r_for_data_science_wickham_textbook_displ_hwy_geomobj_color_plot.pdf")
point_smooth_class
png("r_wickham/figures/chapter1/r_for_data_science_wickham_textbook_displ_hwy_geomobj_color_plot.png")
point_smooth_class
dev.off()  

# We can also use the same idea to specify different data for each layer
# Here smooth line displace a subset of mpg data
smooth_subset <- ggplot(data = mpg, mapping = aes(x = displ, y = hwy)) +
  geom_point(mapping = aes(color = class)) +
  geom_smooth(data = filter(mpg, class == "subcompact"), se = FALSE) +
  ggtitle(expression(atop("Displacement in litres", "with Highway Miles Per Gallon",
                          "with subcompact class"))) +
  xlab("Engine Displacement in Litres") +
  ylab("Highway Miles Per Gallon") +
  theme(plot.title = element_text(hjust = 0.5), title = element_text(size = 16),
        text = element_text(size =  10))
pdf("r_wickham/figures/chapter1/r_for_data_science_wickham_textbook_displ_hwy_geomobj_subset_plot.pdf")
smooth_subset
png("r_wickham/figures/chapter1/r_for_data_science_wickham_textbook_displ_hwy_geomobj_subset_plot.png")
smooth_subset
dev.off()

# Geometric Objects Exercises

# 1. What geom would you use to draw a line chart?
# geom_line()

# 2. Run the code in your head and predict what the out put will look like.
# Then run the code and check your predictions.
ggplot(data = mpg, mapping = aes(x = displ, y = hwy, color = drv)) +
  geom_point() +
  geom_smooth(se = FALSE)

# 3. What does show.legend do?
?geom_smooth
# logical. Should this layer be included in the legends? 
# NA, the default, includes if any aesthetics are mapped. 
# FALSE never includes, and TRUE always includes.

# 4. What does the se argument do?
?geom_smooth
# display confidence interval around smooth? 
# (TRUE by default, see level to control

# 5. Will these two graphs look different? Why or why not?
ggplot(data = mpg, mapping = aes(x = displ, y = hwy)) +
  geom_point() +
  geom_smooth()

ggplot() +
  geom_point(data = mpg, mapping = aes(x = displ, y = hwy)) +
  geom_smooth(data = mpg, mapping = aes(x = displ, y = hwy))

# They look the same, except there is duplication in the latter one

# 6. Re-create the following grpahs
# 1
ggplot(data = mpg, mapping = aes(x = displ, y = hwy)) +
  geom_point() +
  geom_smooth(se = FALSE)

# 2
ggplot(data = mpg, mapping = aes(x = displ, y = hwy)) +
  geom_point() +
  geom_smooth(mapping = aes(group = drv), se = FALSE)

# 3
ggplot(data = mpg, mapping = aes(x = displ, y = hwy, color = drv)) +
  geom_point() +
  geom_smooth(mapping = aes(group = drv), se = FALSE)

# 4.
ggplot(data = mpg, mapping = aes(x = displ, y = hwy)) +
  geom_point(mapping = aes(color = drv)) +
  geom_smooth(se = FALSE)

# 5
ggplot(data = mpg, mapping = aes(x = displ, y = hwy, color = drv)) +
  geom_point() +
  geom_smooth(mapping = aes(linetype = drv), se = FALSE)

# 6
ggplot(data = mpg, mapping = aes(x = displ, y = hwy, color = drv)) +
  geom_point()

### STATISTICAL TRANSFORMATION ###

# 1. What is the default geom associated with stat_summary()
?stat_summary
# geom_errorbar, geom_pointrange, geom_linerange, geom_crossbar 
# for geoms to display summarised data

# 2. What does geom_col() do? Difference between geom_bar()?
# There are two types of bar charts: geom_bar makes the height 
# of the bar proportional to the number of cases in each group 
# (or if the weight aethetic is supplied, the sum of the weights). 
# If you want the heights of the bars to represent values in the data, 
# use geom_col instead.
?geom_col

# 3. What does stat_smooth() compute? What parameters control its behavior?
?stat_smooth
# y
# predicted value
# ymin
# lower pointwise confidence interval around the mean
# ymax
# upper pointwise confidence interval around the mean
# se
# standard error

# 4. What are the problems in these two plots
ggplot(data = diamonds) +
  geom_bar(mapping = aes(x = cut, y = ..prop..))
ggplot(data = diamonds) +
  geom_bar(mapping = aes(x = cut, fill = color, y = ..prop..))
# These two plots show no difference in the prop among different quality level

### Position Adjustment ###
# Plotting position = identity, need to ajudst the alpha transparency
position_identity_1 <- ggplot(data = diamonds, mapping = aes(x = cut, fill = clarity)) +
  geom_bar(alpha = 1/5, position = "identity")
position_identity_1

# Another position = identity
position_identity_2 <- ggplot(data = diamonds, mapping = aes(x = cut, color = clarity)) +
  geom_bar(fill = NA, position = "identity")
position_identity_2

# position = "fill" set stacked bars with the same height
position_fill <- ggplot(data = diamonds, mapping = aes(x = cut, fill = clarity)) +
  geom_bar(position = "fill")
position_fill

# position = "dodge" places overlapping items directly next to each other
position_dodge <- ggplot(data = diamonds, mapping = aes(x = cut, fill = clarity)) +
  geom_bar(position = "dodge")
position_dodge

# To avoid overplotting, use potition = "jitter", it places random noise to each point
position_jitter <- ggplot(data = mpg) + 
  geom_point(mapping = aes(x = displ, y = hwy),position = "jitter")
position_jitter

# Position Adjustments Exercises
# 1.

### Coordinate Systems
# Default is cartesian coordinate, where x and y position act independently
# to find location of each point
# coord_flip() switches x and y axes. It is useful if you want horizontal boxplots
# It's also useful for long labels
coord_sys <- ggplot(data = mpg, mapping = aes(x = class, y = hwy)) +
  geom_boxplot()
coord_sys

coord_sys2 <- ggplot(data = mpg, mapping = aes(x = class, y = hwy)) +
  geom_boxplot() +
  coord_flip()
coord_sys2

# coord_quickmap() sets the aspect ratio for maps

nz <- map_data("nz")
nz1 <- ggplot(nz, aes(long, lat, group = group)) +
  geom_polygon(fill = "white", color = "black")
nz1

nz2 <- ggplot(nz, aes(long, lat, group = group)) +
  geom_polygon(fill = "white", color = "black") +
  coord_quickmap()
nz2

# coord_polar() uses polar coordinates
bar <- ggplot(data = diamonds) +
  geom_bar(mapping = aes(x = cut, fill = cut), show.legend = FALSE, width = 1) +
  theme(aspect.ratio = 1) +
  labs(x = NULL, y = NULL)
bar

bar + coord_flip()
  
bar + coord_polar()

