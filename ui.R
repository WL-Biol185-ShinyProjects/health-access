library(shiny) 
library(shinydashboard)
library(leaflet) 
library(tidyverse)


# Dashboard outline for app 
dashboardPage(
  dashboardHeader(title = "Health Care Access"),

# Code for side tabs
  dashboardSidebar(
    sidebarMenu( 
      menuItem("Welcome", tabName = "Welcome"),
      menuItem("Massachussets", tabName = "Massachussets", icon = icon("th-large", lib = "glyphicon")), 
      menuItem("Alabama", tabName = "Alabama", icon = icon("th-large", lib = "glyphicon")),   
      menuItem("National", tabName = "National", icon = icon("map-marked")), 
      menuItem("Primary Care", tabName = "Primary Care", icon = icon("user", lib = "glyphicon")), 
      menuItem("Preventable Hospital Stays", tabName = "Preventable Hospital Stays")
    )
  ),
  
#Code for what each tab contains
  dashboardBody(
    tabItems(
      # First tab content
      tabItem(tabName = "Welcome"),
      
      # Second tab content
      tabItem(
        tabName = "Massachussets", 
        fluidRow(
        column(12, 
               leafletOutput("massachussetsMap"))
        )),
      # Third tab content 
      tabItem(
        tabName = "Alabama", 
        fluidRow(
          column(12, 
                 leafletOutput("alabamaMap"))
        )),
      
      tabItem(
        tabName = "National",
        fluidRow(
          sidebarLayout(
            sidebarPanel(
              selectInput(
                "natvariable", "Variable:",
                choices = c("pct_uninsured",
                            "num_ratio_primary_cp"),
                selected = 1
              )
            ),
           mainPanel(
             leafletOutput("Nationmap")) 
          ))), #if you add another ) here thats what you need but it gets rid of the primary map,
      
      tabItem(
        tabName = "Primary Care", 
        fluidRow(
          column(12, 
                 leafletOutput("primaryMap"))
        )),
      tabItem(tabName = "Preventable Hospital Stays") 
    
    )
  )
)