library(shinydashboard)
library(shiny)
library(leaflet)
library(ggplot2)
library(scales)
library(htmltools)
library(rgdal)
library(tidyverse)
library(readr)
library(ggrepel)


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
        labeled<- "Ratio of Population to Primary Care Providers"
      }else if (input$AL == "num_ratio_mental_health"){
        labeled<-"Ratio of Population to Mental Health Care Providers"
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
  ALgraphlabeled<- reactive(
    {
      req(input$AL2)
      if(input$AL2 == "pct_uninsured"){
        labeled <- "Percent Uninsured"
      }else if (input$AL2 == "num_ratio_primary_cp"){
        labeled<- paste0("Ratio of Population to Primary Care Providers")
      }else if (input$AL2 == "num_ratio_mental_health"){
        labeled<-paste0("Ratio of Population to Mental Health Care Providers")
      }
    }
  )
  MASSgraphlabeled<- reactive(
    {
      req(input$MASS2)
      if(input$MASS2 == "pct_uninsured"){
        labeled <- "Percent Uninsured"
      }else if (input$MASS2 == "num_ratio_primary_cp"){
        labeled<- paste0("Ratio of Population to Primary Care Providers")
      }else if (input$MASS2 == "num_ratio_mental_health"){
        labeled<-paste0("Ratio of Population to Mental Health Care Providers")
      }
    }
  )
  STATElabeled<- reactive(
    {
      req(input$variables)
      if(input$variables == "pct_uninsured"){
        labeled <- ("Percent Uninsured")
      }else if (input$variables == "num_ratio_primary_cp"){
        labeled<- paste0("Ratio of Population to Primary Care Providers")
      }else if (input$variables == "num_ratio_mental_health"){
        labeled<-paste0("Ratio of Population to Mental Health Care Providers")
      }
    }
  )
  ALMASSlabeled<- reactive(
    {
      req(input$VAR2)
      if(input$VAR2 == "pct_uninsured"){
        labeled <- "Percent Uninsured"
      }else if (input$VAR2 == "num_ratio_primary_cp"){
        labeled<- paste0("Ratio of Population to Primary Care Providers")
      }else if (input$VAR2 == "num_ratio_mental_health"){
        labeled<-paste0("Ratio of Population to Mental Health Care Providers")
      }
    }
  )
  ALMASS2labeled<- reactive(
    {
      req(input$VAR3)
      if(input$VAR3 == "pct_uninsured"){
        labeled <- "Percent Uninsured"
      }else if (input$VAR3 == "num_ratio_primary_cp"){
        labeled<- paste0("Ratio of Population to Primary Care Providers")
      }else if (input$VAR3 == "num_ratio_mental_health"){
        labeled<-paste0("Ratio of Population to Mental Health Care Providers")
      }
    }
  )
  #Importing GeoSpatial Data
  maGEO <- rgdal::readOGR("testing.json")
  alGEO <- rgdal::readOGR("testing.json")
  statesGEO <- rgdal::readOGR("states.geo.json")
  
  bystateavgs <- read_csv("bystateavgs.csv")
  stateavg_only <- read_csv("stateavg_only.csv")
  HAexplore <- read_csv("stateavg_only.csv")
  z <- select(HAexplore, 2, 5:21)
 
  
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
      labs(caption = "This graph can show the data for the % of uninsured patients, ratio of population to primary care providers, and ratio of population to mental health providers on the county level for the state of Alabama. \n 
           Choose which variable and counties you would want to learn more about.", xlab = "Counties", ylab = ALlabeled()) +
      theme(text = element_text(size = 14), plot.caption = element_text(hjust = 0.5))
  })
  
  output$newBAR <- renderPlot({
    filteredcounty <- al %>% filter(county %in% input$ALdrop)
    ggplot(data = filteredcounty, aes_string(y = filteredcounty[[input$AL2]], x = "county", fill = filteredcounty[[input$AL2]])) +
      geom_bar(stat ="identity", color = "black") +
      scale_fill_gradient("white", "darkblue") +
      labs(caption = "This graph can show the data for the % of uninsured patients, ratio of population to primary care providers, \n and ratio of population to mental health providers on the county level for the state of Alabama. \nChoose which variable and counties you would want to learn more about.", x = "Counties", y = ALgraphlabeled(), title = ALgraphlabeled()) +
      theme(text = element_text(size = 14), plot.caption = element_text(hjust = 0.5))
  })
  
  
  #Output for Massachussetts Counties Point Graph
  output$MASSbar <- renderPlot({
    filtered <- mass %>% filter(county %in% input$MASSDrop)
    ggplot(data = filtered, aes_string(y = filtered[[input$MASS2]], x = "county", fill = filtered[[input$MASS2]])) +
      geom_bar(stat ="identity", color = "black") +
      scale_fill_gradient("white", "darkblue") +
      labs(caption = "This graph can show the data for the % of uninsured patients, ratio of population to primary care providers, \n and ratio of population to mental health providers on the county level for the state of Massachussets \nChoose which variable and counties you would want to learn more about." , x = "Counties", y = MASSgraphlabeled(), title = MASSgraphlabeled()) +
      theme(text = element_text(size = 14), plot.caption = element_text(hjust = 0.5))
  })
  
  #Output for AL vs Mass State Bar Graph
  output$ALvsMASS <- renderPlot({
    ggplot(data = massvsal, aes_string(x = "state", y = massvsal[[input$VAR2]], fill = "state")) +
      geom_bar(stat ="identity", color = "black") +
      scale_fill_manual(values = c("steelblue", "lightblue")) +
      labs(caption = "This graph can compare the data for the % of uninsured patients, ratio of population to primary care providers, \nand ratio of population to mental health providers between our two target states, Alabama and Massachusetts. \nChoose the variable you want to compare.", x = "State", y = ALMASSlabeled(), title = ALMASSlabeled()) +
      theme(text = element_text(size = 14), plot.caption = element_text(hjust = 0.5))
  })
  
  #Output for National STATE bar graph
  output$STATEbar <- renderPlot({
    filtered3 <- stateavg_only %>% filter(state %in% input$statechoice)
    ggplot(data = filtered3, aes_string(x="state", y = filtered3[[input$variables]], fill = filtered3[[input$variables]])) +
      geom_bar(stat="identity", color = "black") +
      scale_fill_gradient("white", "darkblue") +
      labs(caption = "This graph can compares the data for the % of uninsured patients, ratio of population to primary care providers,\n and ratio of population to mental health providers for all 50 states. \nChoose which variable and which states you would like to compare", x = "States", y = STATElabeled(), title = STATElabeled()) +
      theme(text = element_text(size = 14), plot.caption = element_text(hjust = 0.5))
  })
  output$ALvsMASS2 <- renderPlot({
    ggplot(data = massvsal, aes_string(x = "state", y = massvsal[[input$VAR3]], fill = "state")) +
      geom_bar(stat ="identity", color = "black") +
      scale_fill_manual(values = c("steelblue", "lightblue")) +
      labs(caption = "This graph can compare the data for the % of uninsured patients, ratio of population to primary care providers, \nand ratio of population to mental health providers between our two target states, Alabama and Massachusetts. \nChoose the variable you want to compare." , x = "Counties", y = ALMASS2labeled(), title = ALMASS2labeled()) +
      theme(text = element_text(size = 14), plot.caption = element_text(hjust = 0.5))
  })
  
#Output for data explorer
  output$HAdataexplorer <- renderDataTable (z, 
                                            escape = 1:18) 
  print(z)
  
  
  #Output for scatterplots
  output$HSvUI <- renderPlot({
    ggplot(stateavg_only, aes(x = pct_highschool_completed, y = pct_uninsured, label = state)) +
      geom_point(size = 2, shape = 23) + 
      geom_text(aes(label = state),hjust=0, vjust=0) +
      labs(caption = "The results of the scatterplot demonstrate a negative correlation between 
           our two factors as the % of uninsured patients decrease when the % of high school 
           graduates in the population increase. Education is a social factor that can be used 
           as an indicator when predicting health accessibility. When creating long-term plans 
           to improve health access, education must be considered as well-educated populations 
           tend to have more insurance coverage.  ") +
      geom_smooth(method = lm, se = FALSE) +
      xlab("Percent of Individuals who Have Completed High School") +
      ylab("Percent Uninsured")
  })
  
  output$NHWvNPCP <- renderPlot({ 
    ggplot(stateavg_only, aes(x = `% Non-Hispanic White`, y = num_ratio_primary_cp, label = state)) + 
      geom_point(size=2, shape = 23) + 
      geom_text_repel(aes(label = state),hjust=0, vjust=0) +
      labs(caption = "Based on the data on the scatterplot, there is no strong correlation between
           the # Primary Care Providers and the % of Non-Hispanic White individuals in the state. 
           While there might be nuances on the county level, on the state level we cannot 
           definitively say whether demographics or race have a strong impact on health 
           accessibility. We may have to examine different data sources to further understand 
           this aspect of health accessibility.  ") +
      xlab("Percent of Non-Hispanic White Reported in the U.S. Census (%)") +
      ylab("Number of Primary Care Providers")
    
  })
  
  
}


