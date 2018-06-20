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
### Position Adjustment
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

