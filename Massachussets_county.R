library(leaflet) 
library(tidyverse) 
library(htmltools)
library(rgdal)

nationwideGEO <- 

# Get Data
nationwideGEO <- rgdal::readOGR("states.geo.json")

uninsuredData <- data.frame( "_____ ",
                             stringsAsFactors = FALSE)

uninsuredData$popupText <- paste(strong("State:"), uninsuredData$place, br(), 
                                 strong("Population:"), uninsuredData$population, br(), 
                                 strong("Uninsured Patients"), uninsuredData$mean_pct_uninsured)

nationwideGEO@data <-
  nationwideGEO@data %>%
  left_join(uninsiredData, by = c("Name" = "place"))