library(readxl)
library(dplyr)
library(tidyverse)
ranked_measure <- read_excel("countyhealthrankings_rankedmeasureonly.xlsx", sheet = "Ranked Measure Data", skip = 1)
limited_data <- ranked_measure[c('FIPS', 'State', 'County', 'Preventable Hospitalization Rate', '% Uninsured', '# Primary Care Physicians', 'Primary Care Physicians Rate', 'Primary Care Physicians Ratio' )]
glimpse(limited_data)
renamed<-
  rename(limited_data, 
    state = State,
    county = County, 
    preventable_hr = `Preventable Hospitalization Rate`, 
    pct_uninsured = `% Uninsured`, 
    num_primary_cp = `# Primary Care Physicians`, 
    rate_primary_cp = `Primary Care Physicians Rate`, 
    ratio_primary_cp = `Primary Care Physicians Ratio`,
    ratio_primary_cp = `Primary Care Physicians Ratio`) 
renamed$num_ratio_primary_cp<-as.numeric(substring(renamed$ratio_primary_cp, 1, nchar(renamed$ratio_primary_cp) -2))
#state averages 
bystate<- renamed %>%
  group_by(state) %>%
  summarise(mean_preventable_hr_by_state = mean(preventable_hr, na.rm = TRUE), 
            mean_pct_unins_by_state = mean(pct_uninsured, na.rm = TRUE),
            mean_num_primary_cp_by_state = mean(num_primary_cp, na.rm = TRUE),
            mean_rate_primary_cp_by_state = mean(rate_primary_cp, na.rm = TRUE),
            mean_ratio_primary_cp = mean(num_ratio_primary_cp, na.rm = TRUE))
bystate
national_preventable_hr<- mean(bystate$mean_preventable_hr_by_state)
national_pct_unins<- mean(bystate$mean_pct_unins_by_state)
national_num_primary_cp<- mean(bystate$mean_num_primary_cp_by_state)
national_rate_primary_cp<- mean(bystate$mean_rate_primary_cp_by_state)
national_ratio_primary_cp<- mean(bystate$mean_ratio_primary_cp)
lm(preventable, data = renamed)


