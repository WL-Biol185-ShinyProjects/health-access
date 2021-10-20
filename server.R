library(shinydashboard)
library(shiny) 
library(leaflet)
library(htmltools)
library(rgdal)
library(tidyverse)

function(input, output) {
 
#Importing GeoSpatial Data
  countiesGEO <- rgdal::readOGR("counties.json")

#Trim data table for counties 
  Massachussetts <- 25
  
  geo@data <- geo@data[which(geo@data$STATE == 25)]
  geo@polygons[which(geo@data$STATE != 25)] <- NULL
  
#Output function for Massachussetts state & county map
  output$massachussetsMap <- renderLeaflet({
    leaflet(counties.json) %>%
    addTiles() %>%
    setView(-71.3824,42.4072, zoom = 10) %>% 
    addPolygons(color = "#444444", weight = 1, smoothFactor = 0.5,
              opacity = 1.0, fillOpacity = 0.5)
})

      
  output$Nationmap <- renderLeaflet({
    leaflet(statesGEO) %>%
    setView(-96, 37.8, 4) %>%
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


