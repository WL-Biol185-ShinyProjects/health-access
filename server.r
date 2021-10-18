library(shiny)
install.packages("shinydashboard")
function(input, output) {
  
  x<- reactive({
    if (input$distribution  == "normal") {
      rnorm(100,input$number)
    } else {
      runif(100, max = input$number)
    }
  })
  
  output$hist <- renderPlot({
    #job here is to make the histogram 
      
    col <- if (input$distribution == "normal") {
      "grey"
    } else {
      "blue"
    }
    hist(x(), col = col)
  })
  #this is coming from  plotOutplut in the ui file # 
  output$summary <- renderText({
    summary(x())
  })
}