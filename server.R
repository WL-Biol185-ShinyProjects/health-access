library(shinydashboard)
library(shiny) 
library(leaflet)
library(htmltools)
library(rgdal)
library(tidyverse)

function(input, output) {
 
  countiesGEO <- rgdal::readOGR("Counties.json")
  statesGEO <- rgdal::readOGR("states.geo.json")

  output$massachussetsMap <- renderLeaflet({
    leaflet(countiesGEO) %>%
      addTiles() %>%
  setView(-98.483330, 38.712046, 4) %>% 
  addPolygons(color = "#444444", weight = 1, smoothFactor = 0.5,
              opacity = 1.0, fillOpacity = 0.5)
})
  }


