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
        labeled<- paste0(p("Ratio of Population to", style = "margin-bottom:0px;text-align:center;"), p("Primary Care Providers"))
      }else if (input$natvariable == "num_ratio_mental_health"){
        labeled<-paste0(p("Ratio of Population to", style = "margin-bottom:0px;text-align:center;"), p("Mental Health Care Providers"))
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
      }else if (input$natvariable == "num_ratio_mental_health"){
        suffixed <- ":1"
      }
    }
  )
  MASSlabeled<- reactive(
    {
      req(input$MASS)
      if(input$MASS == "pct_uninsured"){
        labeled <- "Percent Uninsured"
      }else if (input$MASS == "num_ratio_primary_cp"){
        labeled<- paste0(p("Ratio of Population to", style = "margin-bottom:0px;text-align:center;"), p("Primary Care Providers"))
      }else if (input$MASS == "num_ratio_mental_health"){
        labeled<-paste0(p("Ratio of Population to", style = "margin-bottom:0px;text-align:center;"), p("Mental Health Care Providers"))
      }
    }
  )
  MASSsuffixed<- reactive(
    {
      req(input$MASS)
      if(input$MASS == "pct_uninsured"){
        suffixed <- "%"
      }else if (input$MASS == "num_ratio_primary_cp"){
        suffixed<- ":1"
      }else if (input$MASS == "num_ratio_mental_health"){
        suffixed <- ":1"
      }
    }
  )
  ALlabeled<- reactive(
    {
      req(input$AL)
      if(input$AL == "pct_uninsured"){
        labeled <- "Percent Uninsured"
      }else if (input$AL == "num_ratio_primary_cp"){
        labeled<- paste0(p("Ratio of Population to", style = "margin-bottom:0px;text-align:center;"), p("Primary Care Providers"))
      }else if (input$AL == "num_ratio_mental_health"){
        labeled<-paste0(p("Ratio of Population to", style = "margin-bottom:0px;text-align:center;"), p("Mental Health Care Providers"))
      }
    }
  )
  ALsuffixed<- reactive(
    {
      req(input$AL)
      if(input$AL == "pct_uninsured"){
        suffixed <- "%"
      }else if (input$AL == "num_ratio_primary_cp"){
        suffixed<- ":1"
      }else if (input$AL == "num_ratio_mental_health"){
        suffixed <- ":1"
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
  al<- read_csv("alonly.csv")
  
  #Import data for mass vs al histogram
  massvsal <- read_csv("mass_al_data.csv")
  
  alabama <- "01"
  alabamadata <- alGEO@data[which(alGEO@data$STATE == alabama),]
  alGEO@polygons[which(alGEO@data$STATE!= alabama)] <- NULL
  alGEO@data <- alabamadata
  
  #Output  function for Massachussetts state & county map
  output$massachussetsMap <- renderLeaflet({
    maGEO@data <- left_join(maGEO@data, mass, by = c("NAME"="county"))
    pal<- colorBin("Blues", domain = maGEO@data[[input$MASS]])
    leaflet(maGEO) %>%
      setView(-71.3824, 42.4072, zoom = 7) %>%
      addPolygons(weight = 2, smoothFactor = 0.5, dashArray = "3",
                  opacity = 1.0, fillOpacity = 0.7,
                  fillColor = ~pal(maGEO@data[[input$MASS]]),
                  highlightOptions = highlightOptions(
                    weight = 5,
                    color = "#666",
                    dashArray = "",
                    fillOpacity = 0.7,
                    bringToFront = TRUE),
                  label = ~paste0(NAME, ": ", formatC(maGEO@data[[input$MASS]]))) %>%
      addLegend("bottomright",
                pal = pal,
                values = ~(maGEO@data[[input$MASS]]),
                opacity = 0.8,
                title = MASSlabeled(),
                labFormat = labelFormat(suffix = MASSsuffixed())
                
      )
    
  })
  
  #Output function for Alabama state & county map
  output$alabamaMap <- renderLeaflet({
    alGEO@data<- left_join(alGEO@data, al, by = c("NAME"= "county"))
    pal<- colorBin("Blues", domain = alGEO@data[[input$AL]])
    leaflet(alGEO) %>%
      setView(-86.9023, 32.3182, zoom = 6.37) %>%
      addPolygons(weight = 2, smoothFactor = 0.5, dashArray = "3",
                  opacity = 1.0, fillOpacity = 0.7,
                  fillColor = ~pal(alGEO@data[[input$AL]]),
                  highlightOptions = highlightOptions(
                    weight = 5,
                    color = "666",
                    dashArray = "",
                    fillOpacity = 0.7,
                    bringToFront = TRUE),
                  label = ~paste0(NAME, ":", formatC(alGEO@data[[input$AL]]))) %>%
      addLegend("bottomright",
                pal = pal,
                values = ~(alGEO@data[[input$AL]]),
                opacity = 0.8,
                title = ALlabeled(),
                labFormat = labelFormat(suffix = ALsuffixed())
                
      )
  })
  
  #Output for Nationmap      
  output$Nationmap <- renderLeaflet({
    #joining data
    statesGEO@data<- left_join(statesGEO@data, stateavg_only, by= c("NAME" = "state"))
    pal<- colorBin("Blues", domain = statesGEO@data[[input$natvariable]])
    
    leaflet(statesGEO) %>%
      setView(-95, 36.8, 4) %>%
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
  #Output for primary care      
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
  
  #Output for Alabama Counties Point Graph
  output$ALbar <- renderPlot({
    alfiltered <- al %>% filter(county %in% input$ALDrop)
    ggplot(data = alfiltered, aes_string(y = alfiltered[[input$AL2]], x = "county", fill = alfiltered[[input$AL2]])) +
      geom_bar(stat ="identity", color = "black") +
      scale_fill_gradient("white", "darkblue") +
      theme(text = element_text(size = 14))
  })
  
  output$newBAR <- renderPlot({
    filteredcounty <- al %>% filter(county %in% input$ALdrop)
    ggplot(data = filteredcounty, aes_string(y = filteredcounty[[input$AL2]], x = "county", fill = filteredcounty[[input$AL2]])) +
      geom_bar(stat ="identity", color = "black") +
      scale_fill_gradient("white", "darkblue") +
      theme(text = element_text(size = 14))
  })
  
  
  #Output for Massachussetts Counties Point Graph
  output$MASSbar <- renderPlot({
    filtered <- mass %>% filter(county %in% input$MASSDrop)
    ggplot(data = filtered, aes_string(y = filtered[[input$MASS2]], x = "county", fill = filtered[[input$MASS2]])) +
      geom_bar(stat ="identity", color = "black") +
      scale_fill_gradient("white", "darkblue") +
      theme(text = element_text(size = 14))
  })
  
  #Output for AL vs Mass State Bar Graph
  output$ALvsMASS <- renderPlot({
    ggplot(data = massvsal, aes_string(x = "state", y = massvsal[[input$VAR2]], fill = "state")) +
      geom_bar(stat ="identity", color = "black") +
      scale_fill_manual(values = c("steelblue", "lightblue")) +
      theme(text = element_text(size = 14))
  })
  
  #Output for National STATE bar graph
  output$STATEbar <- renderPlot({
    filtered3 <- stateavg_only %>% filter(state %in% input$statechoice)
    ggplot(data = filtered3, aes_string(x="state", y = filtered3[[input$variables]], fill = filtered3[[input$variables]])) +
      geom_bar(stat="identity", color = "black") +
      scale_fill_gradient("white", "darkblue") +
      theme(text = element_text(size = 14))
  })
  
  output$ALvsMASS2 <- renderPlot({
    ggplot(data = massvsal, aes_string(x = "state", y = massvsal[[input$VAR3]], fill = "state")) +
      geom_bar(stat ="identity", color = "black") +
      scale_fill_manual(values = c("steelblue", "lightblue")) +
      theme(text = element_text(size = 14))
  })
  
#Output for data explorer
  output$HAdataexplorer <- renderDataTable (stateavg_only, 
                                            escape = 1:21)
  print(stateavg_only)
  
  
  #Output for scatterplots
  output$trial <- renderPlot({
    ggplot(mass, aes(x = pct_highschool_completed, y = pct_uninsured)) +
      geom_point(size = 2, shape = 23 ) + 
      geom_smooth(method = lm, se = FALSE)
  })
  
  output$trial2 <- renderPlot({ 
    ggplot(mass, aes(x = `% Non-Hispanic White`, y = num_ratio_primary_cp)) + 
      geom_point(size=2, shape = 23) + 
      geom_smooth(method = lm, se = FALSE)
    
  })
  
  
}


