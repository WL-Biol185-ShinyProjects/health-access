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
    column(12, dataTableOutput("HAdataexplorer"))
    
#Working Data Table - Side tabs - UI
menuItem("DataExplorer", tabName = "DataExplorer")

#Working Data Table - Server
output$HAdataexplorer <- renderDataTable (stateavg_only, 
                                          escape = 1:21)

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
                                          escape = 1:21)
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

<<<<<<< HEAD
#Add scatterplot 
#
=======
>>>>>>> 3be97adf0df3ab3d5ab2211ad5e5c60afea63729
