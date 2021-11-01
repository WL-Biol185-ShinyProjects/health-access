library(shinydashboard)
library(shiny) 
library(leaflet)
library(ggplot2)
library(scales)
library(htmltools)
library(rgdal)
library(tidyverse)
library(readr)


function(input, output) {

<<<<<<< HEAD
  #Importing GeoSpatial Data
  testingGEO <- rgdal::readOGR("testing.json")
  alGEO <- rgdal::readOGR("testing.json")
=======

#Trim data table for counties 
  Massachussetts <- 25
  
  countiesGEO@data <- countiesGEO@data[which(countiesGEO@data$STATE == 25),]
  countiesGEO@polygons[which(countiesGEO@data$STATE != 25)] <- NULL
  countiesGEO <- rgdal::readOGR("counties.json")
  statesGEO <- rgdal::readOGR("states.geo.json")
  bystateavgs <- read_csv("bystateavgs.csv")
  
#Note for later move above function and it will only be slow the first load not every load
>>>>>>> 08c7aa08a8bcd3b0343f600d2b369267aff6c446
  
  
  #Trim data table for counties 
  Massachussetts <- 25
  
  data <- testingGEO@data[which(testingGEO@data$STATE == 25),]
  testingGEO@polygons[which(testingGEO@data$STATE != 25)] <- NULL
  testingGEO@data <- data
  #countiesGEO <- rgdal::readOGR("counties.json")
  #statesGEO <- rgdal::readOGR("states.geo.json")
  #Note for later move above function and it will only be slow the first load not every load
  
  Alabama <- 23
  alabama_data <- alGEO@data[which(alGEO@data$STATE == 23),]
  alGEO@polygons[which(alGEO@data$STATE != 23)] <- NULL
  alGEO@data <- alabama_data

#Output function for Massachussetts state & county map
 output$massachussetsMap <- renderLeaflet({
     leaflet(testingGEO) %>%
     addTiles() %>%
     setView(-71.3824, 42.4072, zoom = 7) %>%
     addPolygons(weight = 1, smoothFactor = 0.5, dashArray = "3",
            opacity = 1.0, fillOpacity = 0.1, 
            highlightOptions = highlightOptions(
            weight = 5,
            color = "#666",
            dashArray = "",
            fillOpacity = 0.7,
            bringToFront = TRUE))
      
})

#Output function for Alabama state & county map
  output$alabamaMap <- renderLeaflet({
   leaflet(alGEO) %>%
      addTiles() %>%
      setView(-86.9023, 32.3182, zoom = 7) %>% 
      addPolygons(weight = 1, smoothFactor = 0.5, dashArray = "3",
                  opacity = 1.0, fillOpacity = 0.1,
                  highlightOptions = highlightOptions(
                    weight = 5,
                    color = "#666",
                    dashArray = "",
                    fillOpacity = 0.7,
                    bringToFront = TRUE))
  })

  #Output for Nationmap      
  output$Nationmap <- renderLeaflet({
    #joining data 
    statesGEO@data<- left_join(statesGEO@data, bystateavgs, by= c("NAME" = "state"))
    pal<- colorBin("Blues", domain = statesGEO@data$mean_pct_unins_by_state)
    
    
#    labels<- sprintf(
 #     "<strong%s</strong><br/>", 
  #    statesGEO@data$NAME, statesGEO@data$mean_pct_unins_by_state
   # ) %>% lapply(htmltools::HTML)
    leaflet(statesGEO) %>%
    setView(-96, 37.8, 5) %>%
    addPolygons(weight = 2, opacity = 1, color = "white", 
                dashArray = "3", fillOpacity = 0.7, 
                fillColor = ~pal(mean_pct_unins_by_state),
                #fillColor = ~colorFactor(c("blue", "red"), statesGEO@data$mean_num_primary_cp_by_state)(statesGEO@data$mean_num_primary_cp_by_state),
                highlightOptions = highlightOptions(
                  weight = 5,
                  color = "#666",
                  dashArray = "",
                  fillOpacity = 0.7,
                  bringToFront = TRUE),
                label = ~paste0(NAME, ": ", formatC(statesGEO@data$mean_pct_unins_by_state)), 
                #labelOptions = labelOptions(
                 # style = list("font-weight" = "normal", padding = "3px 8px"),
                  #textsize = "15px",
                  #direction = "auto"
                #)
                
                ) %>%
      addLegend("bottomright",
                pal = pal,
                values = ~(statesGEO@data$mean_pct_unins_by_state),
                opacity = 0.8,
                title = "Mean Percent Uninsured by State",
                labFormat = labelFormat(suffix = "%")
        
      )
    
    
    
        })
  }


