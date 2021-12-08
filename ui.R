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
      menuItem("Socio-Economic Visualizations", tabName = "Socio-EconomicVisualizations"),
      menuItem("DataExplorer", tabName = "DataExplorer"),
      menuItem("References", tabName = "References")
    )
  ),
  
  #Code for what each tab contains
  dashboardBody(
    tabItems(
      # First tab content
      tabItem(tabName = "Welcome",
              titlePanel(tags$h1(tags$div(tags$b(tags$u("Access to Healthcare in the United States"))), align = "center")),
              fluidRow(
                column(width = 5, box(align = "center", width = 400, solidHeader = TRUE, status = "primary",
                                      img(src = "https://epsa-online.org/LLeaP/wp-content/uploads/2019/04/access_banner-1920x1008.png",
                                          height = "225", width = "255"),
                                      img(src = "https://medcitynews.com/wp-content/uploads/2017/02/GettyImages-109420355-1.jpg",
                                          height = "225", width = "255"))),
                column(width = 7,
                       box(tags$h2(tags$div(tags$b(tags$u("Goals"))), align = "center"),
                           width = 12, solidHeader = TRUE, status = "primary",
                           tags$li("Health care accessibility is a complex topic that is influenced by various socio-economic
                           factors.The goal of this app is to provide an overview of the percentage of insured adults that
                           reside in each state and the number of primary physicians available in each state. A state with
                           relatively high and relatively low healthcare access based on these two factors were also identified.
                           We analyzed these two states on the county level in an effort to identify trends that may cause
                           the accessibility gap between these two locations."),
                           br(),
                           tags$li("Identifying states and counties with low and healthcare accessibility is the first step
                           in creating a long-term plan to address this issue. Future analysis can focus on the
                           causative factors behind these trends. Studying policies and environmental factors within
                           high healthcare access areas could also help form strategies that can be implemented in low
                           access areas to improve quality of care."))),
                box(tags$u(h3(strong("Want to Learn More"))), width = 7, solidHeader = TRUE, status = "primary",
                    br(),
                    tags$li(tags$a(href="https://www.countyhealthrankings.org/explore-health-rankings/rankings-data-documentation",
                                   "Source of Nationwide and Statewide Health Data")),
                    br(),
                    tags$li(tags$a(href="https://www.ncbi.nlm.nih.gov/pmc/articles/PMC7999346/",
                                   "Acccess to Healthcare during COVID-19")))
              )),
      
      # Second tab content
      tabItem(
        tabName = "Massachussets",
        fluidRow(
          titlePanel(h1("Massachussets", align = "center")),
          sidebarLayout(
            sidebarPanel(
              box(width = 12,
                  selectInput("MASS", "Select Variable:",
                              choices = c("Percent Uninsured" = "pct_uninsured",
                                          "Ratio of Population to Primary Care Providers" = "num_ratio_primary_cp",
                                          "Ratio of Population to Mental Health Providers" =  "num_ratio_mental_health"),
                              selected = 1)
              ), 
              box(tags$h2(tags$div(tags$b(tags$u("Massachussets", tags$br(),"Map"))), align = "center"),
                  width = 12, solidHeader = TRUE, status = "primary",
                  tags$p("When looking at the map shown on the right, it is easy to see how there is some difference across the different counties for the various variables."),
              )),
            mainPanel(
              box(width = 12, leafletOutput("massachussetsMap", height = "800"))
            )),
          fluidRow(
            sidebarPanel(
              box(width = 12,
                  selectInput("MASS2", "Select Variable:",
                              choices = c("Percent Uninsured" = "pct_uninsured",
                                          "Ratio of Population to Primary Care Providers" = "num_ratio_primary_cp",
                                          "Ratio of Population to Mental Health Providers" =  "num_ratio_mental_health"),
                              selected = 1),
                  selectInput("MASSDrop", "Select County:",
                              choices = c("Barnstable", "Berkshire", "Bristol", "Dukes", "Essex",
                                          "Franklin", "Hampden", "Hampshire", "Middlesex",
                                          "Nantucket", "Norfolk", "Plymouth", "Suffolk",
                                          "Worcester"),
                              multiple = TRUE
                  )), 
              box(tags$h2(tags$div(tags$b(tags$u("Massachussets Graphs"))), align = "center"),
                  width = 12, solidHeader = TRUE, status = "primary",
                  tags$p("When looking at the graphs shown on the right, it is easier to directly compare counties of interest with the variable selection above.
                         If the graph is blank, you need to select counties of interest!"),
              )),
            mainPanel(
              box(width = 12, plotOutput("MASSbar", height = "800")
              )),
            fluidRow(
              sidebarPanel(
                box(width = 12,
                    selectInput("VAR2", "Select Variable: ",
                                choices = c("Percent Uninsured" = "pct_uninsured",
                                            "Ratio of Population to Primary Care Providers" = "num_ratio_primary_cp",
                                            "Ratio of Population to Mental Health Providers" = "num_ratio_mental_health"),
                                selected = 1
                    )), 
                box(tags$h2(tags$div(tags$b(tags$u("Massachussets" , tags$br(), "vs", tags$br(), "Alabama"))), align = "center"),
                    width = 12, solidHeader = TRUE, status = "primary",
                    tags$p("When looking at the graphs shown on the right, you can compare how the state averages for Massachussets compare to those of Alabama for your chosen variable."),
                )),
              mainPanel(
                box(width = 12, plotOutput("ALvsMASS", height = "800")
                )
              )
            )
          ))
      ),
      
      
      # Third tab content
      tabItem(
        tabName = "Alabama",
        fluidRow(
          titlePanel(h1("Alabama", align = "center")),
          sidebarLayout(
            sidebarPanel(
              box(width = 12,
                  selectInput("AL", "Select Variable:",
                              choices = c("Percent Uninsured" = "pct_uninsured",
                                          "Ratio of Population to Primary Care Providers" = "num_ratio_primary_cp",
                                          "Ratio of Population to Mental Health Providers" =  "num_ratio_mental_health"),
                              selected = 1
                  )
              ), 
              box(tags$h2(tags$div(tags$b(tags$u("Alabama", tags$br(),"Map"))), align = "center"),
                  width = 12, solidHeader = TRUE, status = "primary",
                  tags$p("When looking at the map shown on the right, it is plain to see how there is some difference across the different counties for the various variables."),
              )
            ),
            mainPanel(
              box(width = 12, leafletOutput("alabamaMap", height = "800"))
            )
          ),
          fluidRow(
            sidebarLayout(
              sidebarPanel(
                box(width = 12,
                    selectInput("AL2", "Select Variable:",
                                choices = c("Percent Uninsured" = "pct_uninsured",
                                            "Ratio of Population to Primary Care Providers" = "num_ratio_primary_cp",
                                            "Ratio of Population to Mental Health Providers" =  "num_ratio_mental_health"),
                                selected = 1),
                    selectInput("ALdrop", "Select County",
                                choices = c("Autauga", "Baldwin",
                                            "Barbour", "Bibb", "Blount", "Bullock", "Butler", "Calhoun",
                                            "Chambers", "Cherokee", "Chilton", "Choctaw", "Clarke", "Clay",
                                            "Cleburne", "Coffee", "Colbert", "Conecuh", "Coosa", "Covington",
                                            "Crenshaw", "Cullman", "Dale", "Dallas", "DeKalb", "Elmore",
                                            "Escambia", "Etowah", "Fayette", "Franklin", "Geneva", "Greene",
                                            "Hale", "Henry", "Houston", "Jackson", "Jefferson", "Lamar",
                                            "Lauderdale", "Lawrence", "Lee", "Limestone", "Lowndes", "Macon",
                                            "Madison", "Marengo", "Marion", "Marshall", "Mobile", "Monroe",
                                            "Montgomery", "Morgan", "Perry", "Pickens", "Pike", "Randolph",
                                            "Russell", "Shelby", "Saint Clair", "Sumter", "Talladega",
                                            "Tallapoosa", "Tuscaloosa", "Walker", "Washington", "Wilcox",
                                            "Winston"),
                                multiple = TRUE)
                ), 
                box(tags$h2(tags$div(tags$b(tags$u("Alabama Graphs"))), align = "center"),
                    width = 12, solidHeader = TRUE, status = "primary",
                    tags$p("When looking at the graphs shown on the right, it is easier to directly compare counties of interest with the variable selection above.
                           If the graph is blank, you need to select counties of interest!"),
                )),
              mainPanel(
                box(width = 12, plotOutput("newBAR", height = "800"))
              )
            ),
            fluidRow(
              sidebarLayout(
                sidebarPanel(
                  box(width = 12,
                      selectInput("VAR3", "Select Variable: ",
                                  choices = c("Percent Uninsured" = "pct_uninsured",
                                              "Ratio of Population to Primary Care Providers" = "num_ratio_primary_cp",
                                              "Ratio of Population to Mental Health Providers" = "num_ratio_mental_health"),
                                  selected = 1)
                  ),
                  box(tags$h2(tags$div(tags$b(tags$u("Massachussets" , tags$br(), "vs", tags$br(), "Alabama"))), align = "center"),
                      width = 12, solidHeader = TRUE, status = "primary",
                      tags$p("When looking at the graphs shown on the right, you can compare how the state averages for Alabama compare to those of Massachussets for your chosen variable."),
                  )),
                mainPanel(
                  box(width = 12, plotOutput("ALvsMASS2", height = "800"))
                )
              )
            ))
        )
      ),
      
      # Fourth tab content
      tabItem(
        tabName = "National",
        fluidRow(
          titlePanel(h1("National Data", align = "center")),
          sidebarLayout(
            sidebarPanel(
              box(width = 12, selectInput("natvariable", "Select Variable:",
                                          choices = c("Percent Uninsured" = "pct_uninsured",
                                                      "Ratio of Population to Primary Care Providers" = "num_ratio_primary_cp",
                                                      "Ratio of Population to Mental Health Providers" =  "num_ratio_mental_health"),
                                          selected = 1)
              ), 
              box(tags$h2(tags$div(tags$b(tags$u("National", tags$br(),"Map"))), align = "center"),
                  width = 12, solidHeader = TRUE, status = "primary",
                  tags$p("When looking at the map shown on the right, it is easy to see how there is a lot of difference across the different states for the various variables. For both percent uninsured and ratio of population to mental health care providers we see a statiscially significant difference based on the state for the vast majority of states.
                         the equation used regressed lm(formula = pct_uninsured ~ state, data)"),
              )),
            mainPanel(
              box(width = 12, leafletOutput("Nationmap", height = "800"))
              
            )),
          fluidRow(
            sidebarLayout(
              sidebarPanel(
                box(width = 12,
                    selectInput("variables", "Select Variable:",
                                choices = c("Percent Uninsured" = "pct_uninsured",
                                            "Ratio of Population to Primary Care Providers" = "num_ratio_primary_cp",
                                            "Ratio of Population to Mental Health Providers" =  "num_ratio_mental_health"),
                                selected = 1),
                    selectInput("statechoice", "Select State(s)",
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
                                multiple = TRUE)
                ), 
                box(tags$h2(tags$div(tags$b(tags$u("State", tags$br(), "Comparison", tags$br(), "Graphs"))), align = "center"),
                    width = 12, solidHeader = TRUE, status = "primary",
                    tags$p("When looking at the graphs shown on the right, it is easier to directly compare states of interest with the variable selection above.
                         If the graph is blank, you need to select states of interest!"),
                )),
              mainPanel(
                box(width = 12, plotOutput("STATEbar", height = "800")))
            )
          )
        )
      ),
    
      # Fifth tab content
      tabItem(
        tabName = "Socio-EconomicVisualizations",
        fluidRow(
          box(width = 12,
            tabsetPanel(
              tabPanel("High School Completition Percentage vs. Percent Uninsured", plotOutput("trial")),
              tabPanel("Non-Hispanic White Percentage vs. Number of Primary Care Providers", plotOutput("trial2"))
            )
          )
        )
      ),
    
      # Sixth tab content
      tabItem(
        tabName = "References"
      ), 
    
      # Seventh tab content
      tabItem(
        tabName ="DataExplorer",
        fluidRow(
          column(12, dataTableOutput("HAdataexplorer"))
      )
)
)
)
)
   

