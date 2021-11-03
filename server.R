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
  
  
  #Importing GeoSpatial Data
  maGEO <- rgdal::readOGR("testing.json")
  alGEO <- rgdal::readOGR("testing.json")
  statesGEO <- rgdal::readOGR("states.geo.json")
  bystateavgs <- read_csv("bystateavgs.csv")
  
  
  
  #Trim data table for counties 

  #  Massachussetts <- 25
  
 mass<- read_csv("massonly.csv")
  
  
  #Note for later move above function and it will only be slow the first load not every load
  
  
  #Trim data table for counties
  maGEO@data$STATE <- as.character(maGEO@data$STATE)
  str(maGEO)
  Massachussetts <- 25
  madata <- maGEO@data[which(maGEO@data$STATE == 25),]
  maGEO@polygons[which(maGEO@data$STATE != 25)] <- NULL
  maGEO@data <- madata
  
  #Note for later move above function and it will only be slow the first load not every load
  
  #statenumber for al is 01, 01 is character vector, filter by string
  #Assigning Characters
 # alGEO@data$STATE <- as.character(alGEO@data$STATE)
 # str(alGEO)
  
  #alabama <- 01
  #alabamadata <- alGEO@data[which(alGEO@data$STATE == 01),]
  #alGEO@polygons[which(alGEO@data$STATE != 01)] <- NULL
  #alGEO@data <- alabamadata 
  
  #remove addtiles
  #Output  function for Massachussetts state & county map
  output$massachussetsMap <- renderLeaflet({
    maGEO@data <- left_join(maGEO@data, mass, by = c("NAME"="county"))
    pal<- colorBin("Blues", domain = maGEO@data$pct_uninsured)
    leaflet(maGEO) %>%
      setView(-71.3824, 42.4072, zoom = 7) %>%
      addPolygons(weight = 2, smoothFactor = 0.5, dashArray = "3",
                  opacity = 1.0, fillOpacity = 0.7, 
                  fillColor = ~pal(pct_uninsured),
                  highlightOptions = highlightOptions(
                    weight = 5,
                    color = "#666",
                    dashArray = "",
                    fillOpacity = 0.7,
                    bringToFront = TRUE),
                  label = ~paste0(NAME, ": ", formatC(maGEO@data$pct_uninsured))) %>%
      addLegend("bottomright",
                pal = pal, 
                values = ~(maGEO@data$pct_uninsured), 
                opacity = 0.8,
                title = "Percent Uninsured by County", 
                labFormat = labelFormat(suffix = "%")
                
      )
    
  })
  
  #Output function for Alabama state & county map
  output$alabamaMap <- renderLeaflet({
    leaflet(alGEO) %>%
    setView(-86.9023, 32.3182, zoom = 7) %>% 
    addPolygons(weight = 1, smoothFactor = 0.5, dashArray = "3",
                opacity = 1.0, fillOpacity = 0.1,
                highlightOptions = highlightOptions()
    
   # addPolygons(weight = 1, smoothFactor = 0.5, dashArray = "3",
           #       opacity = 1.0, fillOpacity = 0.1,
            #      highlightOptions = highlightOptions(
             #       weight = 5,
             #       color = "#666",
            #        dashArray = "",
             #       fillOpacity = 0.7,
              #      bringToFront = TRUE))
  })
  
  #Output for Nationmap      
  output$Nationmap <- renderLeaflet({
    #joining data 
    statesGEO@data<- left_join(statesGEO@data, bystateavgs, by= c("NAME" = "state"))
    pal<- colorBin("Blues", domain = statesGEO@data$mean_pct_unins_by_state)
    
    leaflet(statesGEO) %>%
      setView(-96, 37.8, 5) %>%
      addPolygons(weight = 2, opacity = 1, color = "white",
                  dashArray = "3", fillOpacity = 0.7, 
                  fillColor = ~pal(mean_pct_unins_by_state),
                  highlightOptions = highlightOptions(
                    weight = 5,
                    color = "#666",
                    dashArray = "",
                    fillOpacity = 0.7,
                    bringToFront = TRUE),
                  label = ~paste0(NAME, ": ", formatC(statesGEO@data$mean_pct_unins_by_state))
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


