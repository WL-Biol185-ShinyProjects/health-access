#Welcome Tab


dashboardBody(
  tabItems(
    # First tab content
    tabItem(tabName = "Welcome", 
            fluidRow(
              column(8, allign = "center", offset = 2, 
                     tags$head(tags$style(type="text/css", 
                                          ".header1_type {color: black; 
                                          font-size: 40px;
                                          text-align: center;}"
                                          )), 
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
              tags$div(class = "pic2_type", 
                       img(src = "https://medcitynews.com/wp-content/uploads/2017/02/GettyImages-109420355-1.jpg",
                           height = 200, width = 400, align = "center")), 
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
              br(),
              tags$a(href="https://www.countyhealthrankings.org/explore-health-rankings/rankings-data-documentation", "Source of Nationwide and Statewide Health Data"), 
              br(), 
              tags$a(href="https://www.ncbi.nlm.nih.gov/pmc/articles/PMC7999346/", "Acccess to Healthcare during COVID-19"), 
              br(), 
              tags$a(href="https://www.ahajournals.org/doi/full/10.1161/CIR.0000000000000759", "American Heart Association's Reccommended Healthcare Reforms"),
    
  ))
  ))) 