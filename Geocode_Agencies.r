# Filename: Geocode_Agencies.r
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


library(readr)
library(dplyr)
require(rgdal)

# Milestone 1 goal: load data

# Load arrest and census data via corresponding r scripts
source('Arrests_and_Census.r')

# Set the working directory this script is located
setwd("/home/russell/Dropbox/DataAnalysis/Oregon_Arrest_Racial_Bias/")

# Load arrest and census data via corresponding r scripts
source('Arrests_and_Census.r')


shape <- readOGR(dsn = "data/citylim_2021/", layer = "citylim")


# Load geocodede cities
cities <- read_csv('data/oregon_cities.csv')

# Create a cleaner city column
shape$city_trim <-  sub("\\scity$", '', shape$instName)

# merge agency_pop to shapefile
geo_ref <- merge(x=shape, y=agency_pop, by.x='city_trim', by.y='city_trim', all=FALSE)

# write file
writeOGR(geo_ref, dsn="data/geo_agency", layer='geo_agency',  driver="ESRI Shapefile")
