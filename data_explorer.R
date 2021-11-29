output$dataexplorer <- renderDataTable({
  tidystateavg_only %>%
    select(FIPS, state, county, preventable_hr, pct_uninsured, num_primary_cp, 
           rate_primary_cp, ratio_primary_cp, adult_obesity, pct_highschool_completed, 
           num_ratio_primary_cp, Population, '% Black', '% American Indian & Alaska Native', 
           '% Asian', '% Native Hawaiian /Other Pacific Islander', '% Hispanic', 
           '% Non-Hispanic White', '% Not Proficient in English', Population.1)
})