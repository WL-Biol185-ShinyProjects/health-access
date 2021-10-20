library(shiny) 
library(shinydashboard)
library(leaflet) 


dashboardPage(
  dashboardHeader(title = "Health Care Access"),
  dashboardSidebar(
    sidebarMenu( 
      menuItem("Welcome", tabName = "Welcome"),
      menuItem("Massachussets vs Louisiana", tabName = "Massachussets vs Louisiana", icon = icon("th-large", lib = "glyphicon")), 
      menuItem("Uninsured Patients", tabName = "Uninsured Patients"), 
      menuItem("Primary Care Physicians", tabName = "Primary Care Physicians", icon = icon("user", lib = "glyphicon")), 
      menuItem("Preventable Hospital Stays", tabName = "Preventable Hospital Stays")
    )
  ),
  
  dashboardBody(
    tabItems(
      # First tab content
      tabItem(tabName = "Welcome"), 
      
      # Second tab content
      tabItem(tabName = "Massachussets vs Louisiana"),
      tabItem(tabName = "Uninsured Patients"), 
      tabItem(tabName = "Primary Care Physicians"), 
      tabItem(tabName = "Preventable Hospital Stays") 
    )
  )
)

