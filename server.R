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
<<<<<<< HEAD
  bystateavgs <- read_csv("bystateavgs.csv")
=======
<<<<<<< HEAD
  bystateavgs <- read_csv("bystateavgs.csv")
=======
  stateavg_only <- read_csv("stateavg_only.csv")
>>>>>>> f2db7b51f075d86963e0e2656c2ed76e7bd97eb9
  
  
  
  #Trim data table for counties 
  Massachussetts <- 25
  
>>>>>>> 8ad7770efb5a79b92d1c3193e68d93c44d58fa1e
  mass<- read_csv("massonly.csv")
  
  
  #Note for later move above function and it will only be slow the first load not every load
  
  
  #Trim data table for counties

  Massachussetts <- "25"
  madata <- maGEO@data[which(maGEO@data$STATE == Massachussetts),]
  maGEO@polygons[which(maGEO@data$STATE != Massachussetts)] <- NULL
  maGEO@data <- madata

  alabama <- "01"
  alabamadata <- alGEO@data[which(alGEO@data$STATE == alabama),]
  alGEO@polygons[which(alGEO@data$STATE!= alabama)] <- NULL
  alGEO@data <- alabamadata 

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
                highlightOptions = highlightOptions(
                  weight = 5,
                  color = "666", 
                  dashArray = "", 
                  fillOpacity = 0.7, 
                  bringToFront = TRUE))
  })
  
  #Output for Nationmap      
  output$Nationmap <- renderLeaflet({
    #joining data 
<<<<<<< HEAD
    statesGEO@data<- left_join(statesGEO@data, bystateavgs, by= c("NAME" = "state"))
    pal<- colorBin("Blues", domain = statesGEO@data$mean_pct_unins_by_state)
=======
    statesGEO@data<- left_join(statesGEO@data, stateavg_only, by= c("NAME" = "state"))
    pal<- colorBin("Blues", domain = statesGEO@data[["input"]])
>>>>>>> f2db7b51f075d86963e0e2656c2ed76e7bd97eb9
    
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
<<<<<<< HEAD
                values = ~(statesGEO@data$mean_pct_unins_by_state),
=======
                values = ~(statesGEO@data[["input"]]),
>>>>>>> f2db7b51f075d86963e0e2656c2ed76e7bd97eb9
                opacity = 0.8,
                title = "Mean Percent Uninsured by State",
                labFormat = labelFormat(suffix = "%")
                
      )
    
    
  })
  #Output for priary care      
  output$primaryMap <- renderLeaflet({
    #joining data 
    statesGEO@data<- left_join(statesGEO@data, stateavg_only, by= c("NAME" = "state"))
    pal<- colorBin("Blues", domain = statesGEO@data$num_ratio_primary_cp)
    
    leaflet(statesGEO) %>%
      setView(-96, 37.8, 5) %>%
      addPolygons(weight = 2, opacity = 1, color = "white",
                  dashArray = "3", fillOpacity = 0.7,  
                  fillColor = ~pal(statesGEO@data$num_ratio_primary_cp),
                  highlightOptions = highlightOptions(
                    weight = 5,
                    color = "#666",
                    dashArray = "",
                    fillOpacity = 0.7,
                    bringToFront = TRUE),
                  label = ~paste0(NAME, ": ", formatC(statesGEO@data$num_ratio_primary_cp))
      ) %>%
      addLegend("bottomright",
                pal = pal,
                values = ~(statesGEO@data$num_ratio_primary_cp),
                opacity = 0.8,
                title = "Ratios of Primary Care Physician by State",
                labFormat = labelFormat(suffix = ":1")
                
      )
    
    
  })
  
}


