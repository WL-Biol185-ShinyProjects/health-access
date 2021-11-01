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
      menuItem("Uninsured Patients", tabName = "UninsuredPatients", icon = icon("map-marked")), 
      menuItem("Primary Care Physicians", tabName = "Primary Care Physicians", icon = icon("user", lib = "glyphicon")), 
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
        tabName = "UninsuredPatients",
        fluidRow(
          column(12,
                 leafletOutput("Nationmap")
                )
                )), 
      tabItem(tabName = "Primary Care Physicians"), 
      tabItem(tabName = "Preventable Hospital Stays") 
    )
  )
)

