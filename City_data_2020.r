# Filename: City_data_2020.r
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
library(readxl)

# Milestone 1 goal: load raw data set

# Set the working directory this script is located
setwd("/home/russell/Dropbox/DataAnalysis/Eugene_Race/")

# read data
City_data_2020 <- read_excel("data/City_data_2020.xlsx")

# These 8 fields are mutually exclusive.  Use them if you need the sum of the race categories to equal total population, while including a single row for Hispanic or Latino of any race.
# NH18NAT20 Not Hispanic or Latino: 2020 Population age 18 and over of one race: American Indian and Alaska Native alone
# NH18ASN20 Not Hispanic or Latino: 2020 Population age 18 and over of one race: Asian alone
# NH18BLK20 Not Hispanic or Latino: 2020 Population age 18 and over of one race: Black or African American alone
# NH18PAC20 Not Hispanic or Latino: 2020 Population age 18 and over of one race: Native Hawaiian and Other Pacific Islander alone
# NH18OTH20 Not Hispanic or Latino: 2020 Population age 18 and over of one race: Some Other Race alone
# NH18WHT20 Not Hispanic or Latino: 2020 Population age 18 and over of one race: White alone
# NH18MULT20 Not Hispanic or Latino: 2020 Population age 18 and over of two or more races
# HISP18_20 2020 Hispanic or Latino Population age 18 and over (any race)

format_census <- function(census_data){
  census_city <- data.frame(name = census_data$NAME,
                            total = census_data$POP20,
                            native = census_data$NH18NAT20,
                            asian = census_data$NH18ASN20,
                            black = census_data$NH18BLK20,
                            pacific = census_data$NH18PAC20,
                            other = census_data$NH18OTH20,
                            white = census_data$NH18WHT20,
                            multi = census_data$NH18MULT20,
                            latino = census_data$HISP18
  )
  
  # Create total column from summing races
  census_city$sub_total <- census_city$native +
    census_city$asian + census_city$black + census_city$pacific +
    census_city$pacific + census_city$other + census_city$white + 
    census_city$multi + census_city$latino
  
  return(census_city)
}

# Format census data 
census_city <- format_census(City_data_2020)


# cleanup
rm(City_data_2020)
