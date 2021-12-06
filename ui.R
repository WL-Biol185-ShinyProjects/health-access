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
      menuItem("References", tabName = "References"),
    )
  ),
  
#Code for what each tab contains
  dashboardBody(
    tabItems(
      # First tab content
      tabItem(tabName = "Welcome", 
              fluidRow(
                       tags$h2(tags$div(tags$b(tags$u("Goals"))), align = "center"), 
                       br(), 
                       tags$div(img(src = "https://epsa-online.org/LLeaP/wp-content/uploads/2019/04/access_banner-1920x1008.png",
                                    height = 200, width = 400), align = "center"),
                       br(),
                       tags$div(p("Health care accessibility is a complex topic that is influenced by various socio-economic 
                       factors.The goal of this app is to provide an overview of the percentage of insured adults that
                       reside in each state and the number of primary physicians available in each state. A state with
                       relatively high and relatively low healthcare access based on these two factors were also identified. 
                        We analyzed these two states on the county level in an effort to identify trends that may cause 
                        the accessibility gap between these two locations.")), 
                       br(), 
                       br(), 
                       tags$div(img(src = "https://medcitynews.com/wp-content/uploads/2017/02/GettyImages-109420355-1.jpg", 
                                    height = 200, width = 400), align = "center"), 
                       br(), 
                       tags$div(p("Identifying states and counties with low and healthcare accessibility is the first step 
                         in creating a long-term plan to address this issue. Future analysis can focus on the 
                         causative factors behind these trends. Studying policies and environmental factors within
                         high healthcare access areas could also help form strategies that can be implemented in low
                         access areas to improve quality of care.")),
                       tags$u(div(h3(strong("Want to Learn More")))), 
                       br(),
                       tags$a(href="https://www.countyhealthrankings.org/explore-health-rankings/rankings-data-documentation", "Source of Nationwide and Statewide Health Data"), 
                       br(), 
                       tags$a(href="https://www.ncbi.nlm.nih.gov/pmc/articles/PMC7999346/", "Acccess to Healthcare during COVID-19") 
                       
                )),
      # Second tab content
      tabItem(
        tabName = "Massachussets", 
        fluidRow(
          titlePanel(h1("Massachussets", align = "center")),
          sidebarLayout(
            sidebarPanel(
              selectInput("MASS", "Select Variable:", 
                          choices = c("Percent Uninsured" = "pct_uninsured",
                                      "Ratio of Population to Primary Care Providers" = "num_ratio_primary_cp",
                                      "Ratio of Population to Mental Health Providers" =  "num_ratio_mental_health"),
                          selected = 1
                          ),
              selectInput("MASSDrop", "Select County:",
                          choices = c("Barnstable", "Berkshire", "Bristol", "Dukes", "Essex", 
                                      "Franklin", "Hampden", "Hampshire", "Middlesex", 
                                      "Nantucket", "Norfolk", "Plymouth", "Suffolk", 
                                      "Worcester"),
                          multiple = TRUE
                          )
              ),
            mainPanel(
              leafletOutput("massachussetsMap"),
              plotOutput("MASShist")
              )
            )
          )
        ),

    #Third tab content
      tabItem(
        tabName = "Alabama", 
        fluidRow(
          titlePanel(h1("Alabama", align = "center")),
          sidebarLayout(
            sidebarPanel(
              selectInput("AL", "Select Variable:",
                          choices = c("Percent Uninsured" = "pct_uninsured",
                                      "Ratio of Population to Primary Care Providers" = "num_ratio_primary_cp",
                                      "Ratio of Population to Mental Health Providers" =  "num_ratio_mental_health"),
                          selected = 1
                          ),
              selectInput(
              "ALdrop", "Select County",
              choices = c("Jefferson", "Mobile", "Montgomery", "Autauga", "Baldwin", 
                          "Barbour", "Bibb", "Blount", "Bullock", "Butler", "Calhoun", 
                          "Chambers", "Cherokee", "Chilton", "Choctaw", "Clarke", "Clay", 
                          "Cleburne", "Coffee", "Colbert", "Conecuh", "Coosa", "Covington", 
                          "Crenshaw", "Cullman", "Dale", "Dallas", "DeKalb", "Elmore", 
                          "Escambia", "Etowah", "Fayette", "Franklin", "Geneva", "Greene", 
                          "Hale", "Henry", "Houston", "Jackson", "Lamar", "Lauderdale", 
                          "Lawrence", "Lee", "Limestone", "Lowndes", "Macon", "Madison",
                          "Marengo", "Marion", "Marshall", "Monroe", "Morgan", "Perry",
                          "Pickens", "Pike", "Randolph", "Russell", "Shelby", "Saint Clair",
                          "Sumter", "Talladega", "Tallapoosa", "Tuscaloosa", "Walker",
                          "Washington", "Wilcox", "Winston"),
              multiple = TRUE
              )
            ),
          mainPanel(
            leafletOutput("alabamaMap"),
            plotOutput("ALhist")
            )
          )
        )
      ),
      
      
      tabItem(
        tabName = "National",
        fluidRow(
          titlePanel(h1("National Data", align = "center")),
          sidebarLayout(
            sidebarPanel(
              selectInput(
                "natvariable", "Select Variable:",
                choices = c("Percent Uninsured" = "pct_uninsured",
                            "Ratio of Population to Primary Care Providers" = "num_ratio_primary_cp",
                            "Ratio of Population to Mental Health Providers" =  "num_ratio_mental_health"),
                selected = 1
              ),
              selectInput(
                "STATEdrop", "Select State(s)",
                choices = c("Alabama", "Alaska", "Arizona", "Arkansas", "California", "Colorado", 
                            "Connecticut", "Delaware", "Florida", "Georgia", "Hawaii", "Idaho", 
                            "Illinois", "Indiana", "Iowa", "Kansas", "Kentucky", "Louisiana",
                            "Maine", "Maryland", "Massachusetts", "Michigan", "Minnesota",
                            "Mississippi", "Missouri", "Montana", "Nebraska", "Nevada", 
                            "New Hampshire", "New Jersey", "New Mexico", "New York", 
                            "North Carolina", "North Dakota", "Ohio", "Oklahoma", "Oregon", 
                            "Pennsylvania", "Rhode Island", "South Carolina", "South Dakota", 
                            "Tennessee", "Texas", "Utah", "Vermont", "Virginia", "Washington", 
                            "West Virginia", "Wisconsin", "Wyoming"),
                multiple = TRUE
              )
            ),
           mainPanel(
             leafletOutput("Nationmap"),
             plotOutput("STATEhist")
           )
          )
        )
      ),

      tabItem(
        tabName = "References", 
        fluidRow(
          plotOutput("trial2"))
        ), 

)))
   