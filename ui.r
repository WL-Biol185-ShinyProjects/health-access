library(shiny)
install.packages("shinydashboard")
fluidPage(
  sidebarLayout(
    mainPanel(
      plotOutput("hist"), 
      textOutput("summary")
      ), 
    sidebarPanel(
      sliderInput("number", 
              label = "Choose a number",
              min= 0, 
              max = 1000,
              value = 50
              ),
      selectInput(
        "distribution", 
        label = "Choose a distribution",
        choices = list("Normal", "Uniform"))
    )
  ))
  
