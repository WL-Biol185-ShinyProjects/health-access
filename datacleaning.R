library(readxl)
library(dplyr)
library(tidyverse)
ranked_measure <- read_excel("countyhealthrankings_rankedmeasureonly.xlsx", sheet = "Ranked Measure Data", skip = 1)
limited_data <- ranked_measure[c('FIPS', 'State', 'County', 'Preventable Hospitalization Rate', '% Uninsured', '# Primary Care Physicians', 'Primary Care Physicians Rate', 'Primary Care Physicians Ratio' )]
glimpse(limited_data)
limited_data %>%
  rename(
    state = State,
    county = County, 
    preventable_hr = `Preventable Hospitalization Rate`, 
    pct_uninsured = `% Uninsured`, 
    num_primary_cp = `# Primary Care Physicians`, 
    rate_primary_cp = `Primary Care Physicians Rate`, 
    ratio_primary_cp = `Primary Care Physicians Ratio`
  )
glimpse(limited_data)
view(limited_data)

