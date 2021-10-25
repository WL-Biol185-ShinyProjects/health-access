library(readxl)
library(dplyr)
library(tidyverse)
library(stargazer)
ranked_measure <- read_excel("countyhealthrankings_rankedmeasureonly.xlsx", sheet = "Ranked Measure Data", skip = 1)
limited_data <- ranked_measure[c('FIPS', 'State', 'County', 'Preventable Hospitalization Rate', '% Uninsured', '# Primary Care Physicians', 'Primary Care Physicians Rate', 'Primary Care Physicians Ratio', '% Adults with Obesity', '% Completed High School')]
view(limited_data)
class(limited_data$`% Adults with Obesity`)
renamed<-
  rename(limited_data, 
    state = State,
    county = County, 
    preventable_hr = `Preventable Hospitalization Rate`, 
    pct_uninsured = `% Uninsured`, 
    num_primary_cp = `# Primary Care Physicians`, 
    rate_primary_cp = `Primary Care Physicians Rate`, 
    ratio_primary_cp = `Primary Care Physicians Ratio`,
    ratio_primary_cp = `Primary Care Physicians Ratio`,
    adult_obesity = `% Adults with Obesity`,
    pct_highschool_completed = `% Completed High School`)
renamed$num_ratio_primary_cp<-as.numeric(substring(renamed$ratio_primary_cp, 1, nchar(renamed$ratio_primary_cp) -2))
glimpse(renamed)
#state averages 
bystate<- renamed %>%
  group_by(state) %>%
  summarise(mean_preventable_hr_by_state = mean(preventable_hr, na.rm = TRUE), 
            mean_pct_unins_by_state = mean(pct_uninsured, na.rm = TRUE),
            mean_num_primary_cp_by_state = mean(num_primary_cp, na.rm = TRUE),
            mean_rate_primary_cp_by_state = mean(rate_primary_cp, na.rm = TRUE),
            mean_ratio_primary_cp = mean(num_ratio_primary_cp, na.rm = TRUE), 
            mean_adult_obesity = mean(adult_obesity, na.rm = TRUE),
            mean_pct_highschool_completed = mean(pct_highschool_completed, na.rm = TRUE))
bystate
national_preventable_hr<- mean(bystate$mean_preventable_hr_by_state)
national_pct_unins<- mean(bystate$mean_pct_unins_by_state)
national_num_primary_cp<- mean(bystate$mean_num_primary_cp_by_state)
national_rate_primary_cp<- mean(bystate$mean_rate_primary_cp_by_state)
national_ratio_primary_cp<- mean(bystate$mean_ratio_primary_cp)
national_adult_obesity <- mean(bystate$mean_adult_obesity)
model1<- lm(preventable_hr ~ pct_uninsured, data = renamed)
model2<- lm(preventable_hr ~ pct_uninsured + num_ratio_primary_cp, data = renamed)
model3<- lm(preventable_hr ~ pct_uninsured + num_ratio_primary_cp + num_primary_cp, data = renamed)
model4<- lm(preventable_hr ~ pct_uninsured + num_ratio_primary_cp + num_primary_cp + rate_primary_cp, data = renamed)
model5<- lm(preventable_hr ~ pct_uninsured + num_ratio_primary_cp + num_primary_cp + rate_primary_cp + adult_obesity, data = renamed)
model6<-  lm(preventable_hr ~ pct_uninsured + num_ratio_primary_cp + num_primary_cp + rate_primary_cp + adult_obesity + pct_highschool_completed , data = renamed)
model7<-  lm(preventable_hr ~ pct_uninsured + num_ratio_primary_cp + num_primary_cp + rate_primary_cp + adult_obesity + pct_highschool_completed +state, data = renamed)

model10<- lm(preventable_hr ~ state, data = renamed)
summary(model6)
model11<- lm(preventable_hr ~ state + pct_uninsured, data = renamed)

model12<-  lm(preventable_hr ~ state + pct_uninsured + adult_obesity, data = renamed)

stargazer(model1, model2, model3, model4, model5, model6, model7, type = "html", out = "regression.html" ,title = "My regression models")
additonalmeasuredata2021 <- read_excel("2021countyhealthranking_additonalmeasuredata.xlsx", skip = 1)
glimpse(additonalmeasuredata2021)
limited_additionalmeasure <- additonalmeasuredata2021[c('FIPS', 'Population', '% Black', '% American Indian & Alaska Native', '% Asian', '% Native Hawaiian/Other Pacific Islander', '% Hispanic', '% Non-Hispanic White', '% Not Proficient in English')]
glimpse(limited_additionalmeasure)
combined_data <- merge(renamed, limited_additionalmeasure,by="FIPS")