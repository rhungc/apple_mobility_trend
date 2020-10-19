library(ggplot2)
library(readr)
library(dplyr)
library(xts)
dat <- read.csv("applemobilitytrends-2020-06-14.csv", header = T)
glimpse(dat)

#want to take a look at the apple map direction change request within Canada 
country_dat <- dat %>% filter(country == "Canada")
region_dat <- dat %>% filter(region == "Canada") %>% 
  select(-one_of(c("geo_type", "alternative_name", "sub.region", "country"))) 


#first try on whole Canada trend 
title <- region_dat[1:2]
date <- region_dat[3:ncol(region_dat)]
names(date) <- format(as.Date(names(date), format= "X%Y.%m.%d"), format = "%Y-%m-%d")
date <- t(date)
date <- as.data.frame(date)
date <- tibble::rownames_to_column(date, var = "date")

#categorize by type of transportation
driving <- date %>% select(relative_usage = driving, date) %>% mutate(type = "driving") 
glimpse(driving)

transit <- date %>% select(relative_usage = transit, date) %>% mutate(type = "transit")
glimpse(transit)

walking <- date %>% select(relative_usage = walking, date) %>% mutate(type = "walking")

transportation <- rbind(driving, transit, walking)
View(transportation)

transportation <- transportation %>% mutate(weekdays = weekdays(date))

#Plot the trend by category 
ggplot(transportation, aes(x = date, y = relative_usage, color = type)) + geom_line() +
  ggtitle("Trend of relative usage of transportation type in Canada")
