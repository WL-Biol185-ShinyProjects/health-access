library(shinydashboard)
library(shiny) 
library(leaflet)
library(htmltools)
library(rgdal)
library(tidyverse)


function(input, output) {
 
#Importing GeoSpatial Data
  countiesGEO <- rgdal::readOGR("testing.json")


#Trim data table for counties 
  Massachussetts <- 25
  
  countiesGEO@data <- countiesGEO@data[which(countiesGEO@data$STATE == 25),]
  countiesGEO@polygons[which(countiesGEO@data$STATE != 25)] <- NULL
  
#Output function for Massachussetts state & county map
  output$massachussetsMap <- renderLeaflet({
    leaflet(countiesGEO) %>%
    addTiles() %>%
    setView(-71.3824,42.4072, 5, zoom = 10) %>% 
    addPolygons(color = "red", smoothFactor = 0.5, opacity = 0.5) 
    
})

      
  output$Nationmap <- renderLeaflet({
    leaflet(statesGEO) %>%
    setView(-96, 37.8, 5) %>%
    addPolygons(weight = 2, opacity = 1, color = "white", 
                dashArray = "3", fillOpacity = 0.7, 
                highlightOptions = highlightOptions(
                  weight = 5,
                  color = "#666",
                  dashArray = "",
                  fillOpacity = 0.7,
                  bringToFront = TRUE))
    
        })
  }


