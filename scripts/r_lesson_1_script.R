# Load up library packages
library(dplyr)
library(ggplot2)

# Read Data
# Set our new working directory to the current folder
setwd("C:/Users/nade/Desktop/Data Analysis R")
# Read in data as table from txt format
dt <- read.table("data/rcourse_lesson1_data.txt", header = T, sep = "\t")

# To examine data
# dim() tells the number of rows and columns in the data
dim(dt)
# head() shows the first few rows of the data
head(dt)
# tail() prints the last few rows of the data
tail(dt)
# xtabs() gives the data points in a given level of variable
xtabs(~group, dt)

# Now use dplyr package to create sub-data frame, which inlcudes only the
# bilinguals
# We name it as data_bl
# Now subset out bilingual
# %>% is the pipe in dplyr package
data_bl <- dt %>% filter(group == "bilingual")
# Now we can check the subset data using the same functions
dim(data_bl)
head(data_bl)
tail(data_bl)
xtabs(~group, data_bl)

# To make a figure
# making a boxplot of reaction times separated by our two groups
### FIGURES BY GROUP
dt.plot <- ggplot(dt, aes(x = group, y = rt)) + geom_boxplot(aes(fill = group)) +
  ggtitle("Reaction Times by Group") +
  xlab("Group") + ylab("Reaction time in ms") +
  theme_classic() + theme(text = element_text(size = 18), title = element_text(size=18),
                          legend.position = "none")
dt.plot
# After that, we want to save the figures into the folder
# We first use the pdf() function and specify the root folder
# followed by the name
pdf("figures/dt_boxplot.pdf")
dt.plot # execute once more the plot
dev.off() # device off to close the graphics device pdf() function

### WITHIN BILINGUAL GROUP
### MAKE A PLOT OF FIGURE
dt.plot2 <- ggplot(data_bl, aes(x = type, y = rt)) + geom_boxplot(aes(fill=type)) +
  ggtitle("Reaction Time by L2 Proficiency Level") + xlab("Proficiency in L2") +
  ylab("Reaction time in ms") + theme_classic() +
  theme(text = element_text(size=18), title = element_text(size=18), legend.position = "none")
dt.plot2
# SAVE TO PDF
pdf("figures/lesson1_second_boxplot.pdf")
dt.plot2
dev.off()

### bilinguals with monolinguals Plot
dt.plot3 <- ggplot(dt, aes(x = group, y = rt)) + geom_boxplot(aes(fill = type)) +
  ggtitle("Reaction Time by L2 Proficiency Level") + xlab("Proficiency in L2") +
  ylab("Reaction times in ms") + theme_classic() + 
  theme(text = element_text(size=18), title = element_text(size=18), legend.position = "none")
dt.plot3
pdf("figures/lesson1_third_boxplot.pdf")
dt.plot3
dev.off()

### DONE
