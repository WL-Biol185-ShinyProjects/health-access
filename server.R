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
  labeled<- reactive(
    {
      req(input$natvariable)
      if(input$natvariable == "pct_uninsured"){
        labeled <- "Percent Uninsured"
      }else if (input$natvariable == "num_ratio_primary_cp"){
        labeled<- "Ratio of Population to Primary Care Providers"
      }
    }
  )
  suffixed<- reactive(
    {
      req(input$natvariable)
      if(input$natvariable == "pct_uninsured"){
        suffixed <- "%"
      }else if (input$natvariable == "num_ratio_primary_cp"){
        suffixed<- ":1"
      }
    }
  )

  #Importing GeoSpatial Data
  maGEO <- rgdal::readOGR("testing.json")
  alGEO <- rgdal::readOGR("testing.json")
  statesGEO <- rgdal::readOGR("states.geo.json")

  bystateavgs <- read_csv("bystateavgs.csv")
  stateavg_only <- read_csv("stateavg_only.csv")
  
  #Note for later move above function and it will only be slow the first load not every load
  
  
  #Trim data table for counties

  Massachussetts <- "25"
  madata <- maGEO@data[which(maGEO@data$STATE == Massachussetts),]
  maGEO@polygons[which(maGEO@data$STATE != Massachussetts)] <- NULL
  maGEO@data <- madata
  mass<- read_csv("massonly.csv")
  al <- read_csv("alonly.csv")

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
    alGEO@data<- left_join(alGEO@data, al, by = c("NAME"= "county"))
    pal<- colorBin("Blues", domain = alGEO@data$pct_uninsured)
    leaflet(alGEO) %>%
    setView(-86.9023, 32.3182, zoom = 7) %>% 
    addPolygons(weight = 2, smoothFactor = 0.5, dashArray = "3",
                opacity = 1.0, fillOpacity = 0.7,
                fillColor = ~pal(pct_uninsured),
                highlightOptions = highlightOptions(
                  weight = 5,
                  color = "666", 
                  dashArray = "", 
                  fillOpacity = 0.7, 
                  bringToFront = TRUE),
                label = ~paste0(NAME, ":", formatC(alGEO@data$pct_uninsured))) %>%
      addLegend("bottomright",
                pal = pal,
                values = ~(alGEO@data$pct_uninsured), 
                opacity = 0.8,
                title = "Percent Uninsured by County", 
                labFormat = labelFormat(suffix = "%")
        
      )
  })
  
  #Output for Nationmap      
  output$Nationmap <- renderLeaflet({
    #joining data 
    statesGEO@data<- left_join(statesGEO@data, stateavg_only, by= c("NAME" = "state"))
    pal<- colorBin("Blues", domain = statesGEO@data[[input$natvariable]])

    leaflet(statesGEO) %>%
      setView(-96, 37.8, 5) %>%
      addPolygons(weight = 2, opacity = 1, color = "white",
                  dashArray = "3", fillOpacity = 0.7, 
                  fillColor = ~pal(statesGEO@data[[input$natvariable]]),
                  highlightOptions = highlightOptions(
                    weight = 5,
                    color = "#666",
                    dashArray = "",
                    fillOpacity = 0.7,
                    bringToFront = TRUE),
                  label = ~paste0(NAME, ": ", formatC(statesGEO@data[[input$natvariable]]))
      ) %>%
      addLegend("bottomright",
                pal = pal,
                values = ~(statesGEO@data[[input$natvariable]]),
                opacity = 0.8,
                title = labeled(),
                labFormat = labelFormat(suffix = suffixed())
                
      )
    
    
  })
  #Output for priary care      
  output$primaryMap <- renderLeaflet({
    #joining data 
    statesGEO@data<- left_join(statesGEO@data, stateavg_only, by= c("NAME" = "state"))
    pal<- colorBin("Blues", domain = statesGEO@data[["input"]])
    
    leaflet(statesGEO) %>%
      setView(-96, 37.8, 5) %>%
      addPolygons(weight = 2, opacity = 1, color = "white",
                  dashArray = "3", fillOpacity = 0.7, 
                  fillColor = ~pal(pct_uninsured),
                  highlightOptions = highlightOptions(
                    weight = 5,
                    color = "#666",
                    dashArray = "",
                    fillOpacity = 0.7,
                    bringToFront = TRUE),
                  label = ~paste0(NAME, ": ", formatC(statesGEO@data$pct_uninsured))
      ) %>%
      addLegend("bottomright",
                pal = pal,
                values = ~(statesGEO@data[["input"]]),
                opacity = 0.8,
                title = "Mean Percent Uninsured by State",
                labFormat = labelFormat(suffix = suffixed())
                
      )
  })
  
}


