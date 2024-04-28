#Workshop 8 Challenge
malaria_report <- read.table('wmr_modelling.txt', header = TRUE, sep = '\t')

#to include data for 2020 only and arranged deaths in numerical order using arrange
twenty_twenty <- malaria_report %>% filter(year == 2020) %>% arrange(deaths)

country_order <- twenty_twenty$country
#so we made the input for levels by assigning the current order which matches the deaths to a new object 
twenty_twenty$country <- factor(twenty_twenty$country, levels = country_order)
#we can now use that object and put it into levels to confirm the order the country axis should be 

ggplot(twenty_twenty, aes(x = deaths, y = country)) + geom_col()+ labs(title = 'Malaria Deaths in 2020')
