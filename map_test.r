## This script will be where I practice making maps.
rm(list=ls())
library(sf)
library(raster)
library(leaflet)
library(tidyverse)
library(rgdal)

## read in the salmap dataset
salmap.dat <- read_csv("SalMap/SalMapTest1.csv")


test.geo <- salmap.dat %>% 
  dplyr::select(LAT,LONG,LOCATION)


m <- leaflet() %>%
  addTiles() %>%  # Add default OpenStreetMap map tiles
  addMarkers(lng=test.geo$LONG, lat=test.geo$LAT, popup=paste0(test.geo$LOCATION, " | Citation Num: 2"))

m

