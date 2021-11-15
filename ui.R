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
      menuItem("References", tabName = "References")
    )
  ),
  
#Code for what each tab contains
  dashboardBody(
    tabItems(
      # First tab content
      tabItem(tabName = "Welcome", 
              fluidRow(
                tags$u(div(class = "header1_type"), 
                       p(strong("Goals"))
                ), 
                br(), 
                tags$div(class = "pic1_type", 
                         img(src = "https://epsa-online.org/LLeaP/wp-content/uploads/2019/04/access_banner-1920x1008.png",
                             height = 200, width = 400, align = "center")), 
                br(), 
                tags$div(class = "body1_type", 
                         p("Health care accessibility is a complex topic that is influenced by various socio-economic 
                       factors.The goal of this app is to provide an overview of the percentage of insured adults that
                       reside in each state and the number of primary physicians available in each state. A state with
                       relatively high and relatively low healthcare access based on these two factors were also identified. 
                        We analyzed these two states on the county level in an effort to identify trends that may cause 
                        the accessibility gap between these two locations.")), 
                br(), 
                br(), 
                tags$div(class = "body2_type", 
                         p("Identifying states and counties with low and healthcare accessibility is the first step 
                         in creating a long-term plan to address this issue. Future analysis can focus on the 
                         causative factors behind these trends. Studying policies and environmental factors within
                         high healthcare access areas could also help form strategies that can be implemented in low
                         access areas to improve quality of care.")),
                tags$u(div(class = "header2_type"), 
                       p(strong("Want to Learn More"))
                ), 
                tags$a(href="https://www.countyhealthrankings.org/explore-health-rankings/rankings-data-documentation", "Source of Nationwide and Statewide Health Data"), 
                tags$a(href="https://www.ncbi.nlm.nih.gov/pmc/articles/PMC7999346/", "Acccess to Healthcare during COVID-19") 
                
              )), 
      
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
                            "num_ratio_primary_cp",
                            "num_ratio_mental_health"),
                selected = 1
              )
            ),
           mainPanel(
             leafletOutput("Nationmap")))
          )),
      tabItem(
        tabName = "References"
        ) 
      )
      )
    )

