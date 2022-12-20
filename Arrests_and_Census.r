# Filename: Arrests_and_Census.r
# Author: @russl_corey <russl_corey@proton.me>
# Date: Dec 14, 2022
# 
# This program is free software: you can redistribute it and/or modify it under 
# the terms of the GNU General Public License as published by the Free Software 
# Foundation, either version 3 of the License, or (at your option) any later 
# version.
# 
# This program is distributed in the hope that it will be useful, but WITHOUT ANY 
# WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A 
# PARTICULAR PURPOSE. See the GNU General Public License for more details.
# 
# You should have received a copy of the GNU General Public License along with 
# this program. If not, see <https://www.gnu.org/licenses/>. 

# milestone 1 goal: import and run summary statistics

library(readr)
library(dplyr)
library(lubridate)

# Milestone 1 goal: load data

# Set the working directory this script is located
setwd("/home/russell/Dropbox/DataAnalysis/Oregon_Arrest_Racial_Bias/")

# Load arrest and census data via corresponding r scripts
source("OpenData-Arrests-All.r")
source("City_data_2020.r")


# Milestone 2: Join population data to agency city

# step 1: Extract city name from census 'name' column
# This is an intermediate step in order to produce two data
# files, agencies.csv and cities.csv in order to make the table
# agencies_cities_map_cities_only.csv

# cities <- data.frame(city=unique(census_city$name))
# cities <- cities[order(cities$city),]
# write_csv(data.frame(cities), 'data/cities.csv')
# 
# agencies <- data.frame(agency=unique(arrests$`Agency Name`))
# agencies <- agencies[order(agencies$agency),]
# write_csv(data.frame(agencies), 'data/agencies.csv')


# Load city to police department name map
city_agency <- read_csv("data/agencies_cities_map_cities_only.csv")

# merge population data to city police departments
agency_pop <- merge(x=city_agency, y=census_city, by.x='city', by.y='name' )

race_descs <- c('native', 'asian', 'black', 'latino',
                'pacific', 'other', 'white' )

# Factor race column then relabel races to match city_agency columns
arrests$race <- factor(arrests$`Arrestee Race`)
levels(arrests$race) <- race_descs


# Create totals by race and county
for(race_desc in race_descs ){
  
  # count total number arrests for selected race by police department
  tmp <- arrests %>%
    filter(race == race_desc) %>%
    group_by(`Agency Name`) %>%
    summarize(count=sum(count))

  # rename temp column to 
  colnames(tmp) = c('Agency Name', paste0(race_desc, '_arrests'))

  # merge arrest data to previous data frame with police departments and census data
  agency_pop <- merge(x=agency_pop, y=tmp, by.x='agencies', by.y='Agency Name')
}

# Create column that is number of total distinct arrests
tmp <- arrests %>%
  group_by(`Agency Name`) %>%
  summarize(arrest_total=sum(count))

# join arrest totals to agency_pop
agency_pop <- merge(x=agency_pop, y=tmp, by.x='agencies', by.y='Agency Name')

# calculate percentages of each race by pop and arrests
for(race_desc in race_descs){
  
  # calculate percentage of race by popultion
  tmp_pop <- agency_pop %>% select(race_desc) / agency_pop$sub_total
  
  # rename column
  colnames(tmp_pop) = paste0(race_desc, '_percnt')
  
  # join results to agency_pop
  agency_pop <- cbind(agency_pop, tmp_pop)
  
}

# Repeat previos algorithm but for arrests
for(race_desc in paste0(race_descs, '_arrests')){
  
  # calculate percentage of race by arrests
  tmp_pop <- agency_pop %>% select(race_desc) / agency_pop$arrest_total
  
  # rename column
  colnames(tmp_pop) = paste0(race_desc, '_percnt')
  
  # join results to agency_pop
  agency_pop <- cbind(agency_pop, tmp_pop)
}

# Calculate differences between population percentage and arrest percentages
for(race_desc in race_descs){
  
  # calculate difference between arrest and pop percentages
  tmp_dif <- agency_pop %>% select(paste0(race_desc, '_arrests_percnt')) - 
    agency_pop %>% select(paste0(race_desc, '_percnt')) 
  
  # rename column
  colnames(tmp_dif) = paste0(race_desc, '_diff')
  
  # join results to agency_pop
  agency_pop <- cbind(agency_pop, tmp_dif)
}


# Trim city off names of cities
agency_pop$city_trim <- sub("\\scity$", '', agency_pop$city)

# write out results to file
write_csv(agency_pop, 'data/agency_pop.csv')
