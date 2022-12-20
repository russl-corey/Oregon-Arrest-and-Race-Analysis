# Filename: OpenData-Arrests-All.r
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

# Milestone 1 goal: load raw data set

# Define date set url for citation
arrests_url <- "source: https://www.oregon.gov/osp/Pages/Uniform-Crime-Reporting-Data.aspx"

# Define relative filepath and remote filepath
source_url <- "https://www.oregon.gov/osp/Docs/Open-Data/OpenData-Arrests-All.csv"
filename <- "data/OpenData-Arrests-All.csv"
  
# Set the working directory this script is located
setwd("/home/russell/Dropbox/DataAnalysis/Eugene_Race/")

# Load in arrest data, look for local data set, if not download from source
if(!file.exists(filename)){
  arrests <- read_csv(source_url)
  write_csv(offenses, filename)
}else{
  # Run this block to load locally saved data
  arrests <- read_csv(filename)
}


# Milestone 2 goal: validate loaded data

# Check that the need columns are present
for(col in c('Date', 'County', 'NIBRS Report Title', 'Distinct Arrest Offenses', 'Agency Name')){
  if(!(col %in% colnames(arrests))) stop(paste('Missing column:', col)) 
}

# Validate number of reports
if(length(arrests[,1]) < 1) stop('No records loaded')

# Validate number of counties for Oregon
county_list <- sort(unique(tolower(arrests$County)))
if(length(county_list) != 36) stop('Wrong number of counties found for Oregon (not 36)') 


# Milestone 3 goal: Format data and others

# Format created formatted date column in each data frame
arrests$date <- as.Date(arrests$Date, format = "%m/%d/%Y", origin="1900-01-01")

# Sort by dates
arrests = arrests[order(arrests$date),]

# Create column of for lower case county name and agency name
arrests$county <- tolower(arrests$County)
arrests$agency <- tolower(arrests$`Agency Name`)
arrests$count <- arrests$`Distinct Arrest Offenses`
arrests$race <- arrests$`Arrestee Race`
arrests$gender <- arrests$`Arrestee Gender`

# Milestone 4 goal: cleanup
rm(col)
rm(filename)
rm(source_url)