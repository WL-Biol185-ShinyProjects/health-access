output$HAdataexplorer <- renderDataTable({
  tidystateavg_only %>%
    select(FIPS, state, county, preventable_hr, pct_uninsured, num_primary_cp, 
           rate_primary_cp, ratio_primary_cp, adult_obesity, pct_highschool_completed, 
           num_ratio_primary_cp, Population, `% Black`, `% American Indian & Alaska Native`, 
           `% Asian`, `% Native Hawaiian /Other Pacific Islander`, `% Hispanic`, 
           `% Non-Hispanic White`, `% Not Proficient in English`)
})

#Working Data Table - Sixth tab contents - UI
tabItem(
  tabName ="DataExplorer",
  fluidRow(
    column(12, dataTableOutput("HAdataexplorer")),
    
#Working Data Table - Side tabs - UI
menuItem("DataExplorer", tabName = "DataExplorer"),

#Working Data Table - Server
output$HAdataexplorer <- renderDataTable (stateavg_only, 
                                          escape = 1:21),

# Error for data table 
DataTables warning: table id=DataTables_Table_0 - Requested unknown parameter '5' for row 0. For more information about this error, please see http://datatables.net/tn/4




output$HAdataexplorer <- renderDataTable ({
  stateavg_only})

fluidPage(
  fluidRow(
    mainPanel(
      tableOutput("HAdataexplorer")
      
# Scatter Plot relating --> num_ratio_primary_cp & % Non-Hispanic White
# Scatter Plot relationg --> pct_uninsured & pct_highschool_completed
ggplot(mass, aes(x = `% Non-Hispanic White`, y = num_ratio_primary_cp)) 
+ geom_point(size=2, shape = 23)
+ geom_text(label = rownames(county))
+ geom_smooth(method = lm, se = FALSE),

ggplot(mass, aes(x = pct_highschool_completed, y = pct_uninsured)) 
+ geom_point(size = 2, shape = 23 )
+ geom_text(label = rownames(county))
+ geom_smooth(method = lm, se = FALSE)


#What I deleted from server

output$HAdataexplorer <- renderDataTable (stateavg_only, 
                                          escape = 1:21, 
                                          options = list(columnDefs = list(list(visible=FALSE, targets = 1,3,4))))
print(stateavg_only)

output$trial <- renderPlot({
  ggplot(mass, aes(x = pct_highschool_completed, y = pct_uninsured)) +
    geom_point(size = 2, shape = 23 ) + 
    geom_smooth(method = lm, se = FALSE)
})

output$trial2 <- renderPlot({ 
  ggplot(mass, aes(x = `% Non-Hispanic White`, y = num_ratio_primary_cp)) + 
    geom_point(size=2, shape = 23) + 
    geom_smooth(method = lm, se = FALSE)
  
})
} 

#Remove columns 
HAexplore <- read_csv("stateavg_only.csv") 
z <- select(HAexplore, 2, 5:21)

output$HAdataexplorer <- renderDataTable (z, 
                                          escape = 1:18) 
print(z)
