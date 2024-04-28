install.packages("palmerpenguins")
install.packages('tidyverse')
install.packages('dplyr')
library(palmerpenguins)
library(tidyverse)
library(dplyr)

view(penguins)
ggplot(data = penguins) +
  geom_point(mapping = aes(x = bill_length_mm, y = body_mass_g))
#we need to tell ggplot what data we are looking at (penguins), what geom we would like to use (geom_point) and what variables we would like to map to which aesthetics (bill_length and body mass)

ggplot(data = penguins) + geom_point(mapping = aes(x = bill_length_mm, y = body_mass_g, colour = species))
#this adds colour to our graph depending on the species 

ggplot(data = penguins) +
  geom_point(mapping = aes(x = bill_length_mm, y = body_mass_g, colour = island))
#this adds colour depending on the islands - there is again a relationship - penguins from the torgerson island have a low body mass and shorter bill length, while penguins from the Biscoe island have a high body mass and long bill length 

ggplot(data = penguins) +
  geom_point(mapping = aes(x = bill_length_mm, y = body_mass_g)) +
  geom_smooth(mapping = aes(x = bill_length_mm, y = body_mass_g))
?geom_smooth #helps us visualise the pattern by      addding a trendline

#a simpler way of doing the same thing 
ggplot(data = penguins, mapping = aes(x = bill_length_mm, y = body_mass_g)) +
  geom_point() +
  geom_smooth()

#we remapped species to colour 
ggplot(data = penguins, mapping = aes(x = bill_length_mm, y = body_mass_g)) +
  geom_point(mapping = aes(colour = species)) +
  geom_smooth()

#we assigned this to pengu_plot
pengu_plot <-
  ggplot(data = penguins,mapping = aes(x = bill_length_mm, y = body_mass_g)) + geom_point(aes(colour = species))

#for each species to have its own trendline, we added the geom_smooth to the pengu_plot 
pengu_plot + geom_smooth(mapping = aes(colour = species))

pengu_plot + geom_smooth(mapping = aes(colour = species), method = 'lm', se = FALSE)

# assigning shapes to species as well as colour
#changing y axis to match the graph
new_plot <-
  ggplot(data = penguins,mapping = aes(x = bill_length_mm, y = bill_depth_mm)) + geom_point(aes(colour = species, shape = species ))

new_plot + geom_smooth(mapping = aes(colour = species), method = 'lm', se = FALSE)
#method = 'linear model' makes the lines linear 
#se gets rid of the grey bits, which are the standard errors 

#3 - Saving Plots 
#this will save the last plot you had, or you can assign the plot a name and then save that
ggsave('complete_plot.png', width = 300, height = 200, units = 'mm')

#4 - Continuous vs Categorical variables

#we got rid of colour, as it was the outline but if we have fill the default of colour will be black
ggplot(data = penguins,
       mapping = aes(x = species, y = body_mass_g)) +
  geom_boxplot(mapping = aes(fill = species))

head(penguins)
#the variables species,island and sex are factors 
str(penguins)
# gives you the number of levels (the different 'values')

#we ordered the levels around to what we want
penguins$species <- factor(penguins$species, levels = c('Chinstrap', 'Gentoo', 'Adelie'))

#a violin plot was made with the corrected order of the levels of species

ggplot(data = penguins, mapping = aes(x = species, y = body_mass_g)) + geom_violin(mapping = aes(fill = island))

#5 Statistical transformation

# using geom_bar will show us the counts for the penguins of each species 

ggplot(data = penguins) +
  geom_col(mapping = aes(x = species, y = )) 

#geom_bar does not need another variable other than   species, as it will just count the number of species
#geom_col needs another variable 
#coord_flip switches the x and y axis around 

#Difference between the 2 graphs:
#the second graph is stacked, while the first one is overlapping 
#geom_histogram will produce these plots and position = 'stack' will overlap it, while 'identity' will make it overlap
#alpha argument will change the transparency 

#6 - plotting subset of data with filter

# here we are subsetting/filtering to include only penguins of the 2 species 
#instead of %>%, we can use + here because we have already told gg plot what data to use 

penguins %>% filter(!species == "Chinstrap") %>%
  ggplot(mapping = aes(x = flipper_length_mm, y = body_mass_g)) +
  geom_point(mapping = aes(colour = species, shape = island))

#somehow the Chinstrap species had all been converted to NAs, so I had to assign it again in the penguin dataframe:

penguins$species[is.na(penguins$species)] <- "Chinstrap"

penguins$species <- factor(penguins$species, levels = c('Adelie', 'Chinstrap','Gentoo'))

T <- penguins %>% filter(!is.na(sex))%>% ggplot(mapping = aes(x = species, y = body_mass_g)) + geom_violin(aes(fill = sex))
print(T)

unique(T$species)

#7 - Labels

#here we made a title, subtitle and renamed both axis, as well as adding a caption
#scale_fill_discrete is used to change colours

penguins %>%
  ggplot(mapping = aes(x = species, y = body_mass_g)) + geom_violin(aes(fill = sex)) + labs(title = "Weight distribution among penguins", subtitle = "Plot generated by E. Busch-Nentwich, March 2023", x = "Species", y = "Weight in g", caption = "Data from Palmer Penguins package\nhttps://allisonhorst.github.io/palmerpenguins/") + scale_fill_discrete(name = "Sex", labels = c("Female", "Male", "Unknown"), type = c("yellow3", "magenta4", "grey"))

