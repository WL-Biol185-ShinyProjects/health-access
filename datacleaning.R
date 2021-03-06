library(readxl)
library(dplyr)
library(tidyverse)
library(stargazer)
ranked_measure <- read_excel("countyhealthrankings_rankedmeasureonly.xlsx", sheet = "Ranked Measure Data", skip = 1)
limited_data <- ranked_measure[c('FIPS', 'State', 'County', 'Preventable Hospitalization Rate', '% Uninsured', '# Primary Care Physicians', 'Primary Care Physicians Rate', 'Primary Care Physicians Ratio', '% Adults with Obesity', '% Completed High School', 'Mental Health Provider Ratio')]
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
    pct_highschool_completed = `% Completed High School`,
    num_ratio_mental_health = `Mental Health Provider Ratio`
    )
renamed$num_ratio_primary_cp<-as.numeric(substring(renamed$ratio_primary_cp, 1, nchar(renamed$ratio_primary_cp) -2))
renamed$num_ratio_mental_health<-as.numeric(substring(renamed$num_ratio_mental_health, 1, nchar(renamed$num_ratio_mental_health) -2))
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
write_csv(bystate, "bystateavgs.csv")
bystate
national_preventable_hr<- mean(bystate$mean_preventable_hr_by_state)
national_pct_unins<- mean(bystate$mean_pct_unins_by_state)
national_num_primary_cp<- mean(bystate$mean_num_primary_cp_by_state)
national_rate_primary_cp<- mean(bystate$mean_rate_primary_cp_by_state)
national_ratio_primary_cp<- mean(bystate$mean_ratio_primary_cp)
national_adult_obesity <- mean(bystate$mean_adult_obesity)
# model1<- lm(preventable_hr ~ pct_uninsured, data = renamed)
# model2<- lm(preventable_hr ~ pct_uninsured + num_ratio_primary_cp, data = renamed)
# model3<- lm(preventable_hr ~ pct_uninsured + num_ratio_primary_cp + num_primary_cp, data = renamed)
# model4<- lm(preventable_hr ~ pct_uninsured + num_ratio_primary_cp + num_primary_cp + rate_primary_cp, data = renamed)
# model5<- lm(preventable_hr ~ pct_uninsured + num_ratio_primary_cp + num_primary_cp + rate_primary_cp + adult_obesity, data = renamed)
# model6<-  lm(preventable_hr ~ pct_uninsured + num_ratio_primary_cp + num_primary_cp + rate_primary_cp + adult_obesity + pct_highschool_completed , data = renamed)
# model7<-  lm(preventable_hr ~ pct_uninsured + num_ratio_primary_cp + num_primary_cp + rate_primary_cp + adult_obesity + pct_highschool_completed +state, data = renamed)
# 
# model10<- lm(preventable_hr ~ state, data = renamed)
# summary(model6)
# model11<- lm(preventable_hr ~ state + pct_uninsured, data = renamed)
# 
# model12<-  lm(preventable_hr ~ state + pct_uninsured + adult_obesity, data = renamed)
# 
# stargazer(model1, model2, model3, model4, model5, model6, model7, type = "html", out = "regression.html" ,title = "My regression models")
additonalmeasuredata2021 <- read_excel("2021countyhealthranking_additonalmeasuredata.xlsx", skip = 1)
glimpse(additonalmeasuredata2021)
limited_additionalmeasure <- additonalmeasuredata2021[c('FIPS', 'Population', '% Black', '% American Indian & Alaska Native', '% Asian', '% Native Hawaiian/Other Pacific Islander', '% Hispanic', '% Non-Hispanic White', '% Not Proficient in English', 'Population')]
glimpse(limited_additionalmeasure)
combined_data <- merge(renamed, limited_additionalmeasure,by="FIPS")

glimpse(combined_data)
View(combined_data)
#statesGEO <- rgdal::readOGR("states.geo.json")

#bystateavgs <- read_csv("bystateavgs.csv")
#state_map_data <- 
#View(state_map_data)
mass_combined_data<- subset(combined_data, state == "Massachusetts")
mass_combined_data<- na.omit(mass_combined_data)
View(mass_combined_data)
write_csv(mass_combined_data, "massonly.csv")
al_combined_data<- subset(combined_data, state == "Alabama")
al_combined_data<- na.omit(al_combined_data)
write_csv(al_combined_data, "alonly.csv")
stateavg_only<- subset(combined_data, is.na(county))
stateavg_only$num_ratio_primary_cp<-as.numeric(substring(stateavg_only$ratio_primary_cp, 1, nchar(stateavg_only$ratio_primary_cp) -2))
View(stateavg_only)
write_csv(stateavg_only, "stateavg_only.csv")
mass_al_data <- subset(combined_data, state == "Massachusetts" | state == "Alabama")
mass_al_data<- subset(mass_al_data, is.na(county))
View(mass_al_data)
write_csv(mass_al_data, "mass_al_data.csv")


model1<- lm(num_ratio_primary_cp ~ pct_uninsured, data = combined_data)
model2<- lm(num_ratio_primary_cp ~ pct_uninsured  + state, data = combined_data)
model3<- lm(num_ratio_primary_cp ~ pct_uninsured + num_ratio_primary_cp + num_primary_cp, data = combined_data)
model4<- lm(num_ratio_primary_cp ~ pct_uninsured + num_ratio_primary_cp + num_primary_cp + rate_primary_cp, data = combined_data)
model5<- lm(num_ratio_primary_cp ~ pct_uninsured + num_ratio_primary_cp + num_primary_cp + rate_primary_cp + adult_obesity, data = combined_data)
model6<-  lm(num_ratio_primary_cp ~ pct_uninsured + num_ratio_primary_cp + num_primary_cp + rate_primary_cp + adult_obesity + pct_highschool_completed , data = combined_data)
model7<-  lm(num_ratio_primary_cp ~ pct_uninsured + num_ratio_primary_cp + num_primary_cp + rate_primary_cp + adult_obesity + pct_highschool_completed +state, data = combined_data)
model10<- lm(num_ratio_primary_cp ~ state, data = combined_data)
model11<- lm(num_ratio_primary_cp ~ state + pct_uninsured, data = combined_data)
model12<-  lm(num_ratio_primary_cp ~ state + pct_uninsured + adult_obesity, data = combined_data)
model13<-  lm(num_ratio_primary_cp ~ pct_uninsured + state + adult_obesity  + `% Black` + `% Non-Hispanic White`, data = combined_data)
summary(model10)
summary(model11)
summary(model12)
summary(model13)
stargazer(model1, model2, model3, model4, model5, model6, model7, type = "html", out = "regression.html" ,title = "My regression models")
almodel1<- lm(num_ratio_primary_cp ~ pct_uninsured + county, data = al_combined_data)
summary(almodel1)

newmodel_primarycp <- lm (num_ratio_primary_cp ~ state, data = combined_data)
newmodel_pctunins <- lm (pct_uninsured ~ state, data = combined_data)
newmodel_mental<- lm (num_ratio_mental_health ~ state, data = combined_data)
summary(newmodel_primarycp)
summary(newmodel_pctunins)
summary(newmodel_mental)
newmodelhs<- lm (pct_uninsured ~ pct_highschool_completed, data = combined_data)
summary(newmodelhs)
statevshighschool <- lm (pct_highschool_completed ~ state, data = combined_data)
summary(statevshighschool)
statevshighschoolunins <- lm (pct_uninsured ~ state*pct_highschool_completed, data = combined_data)
summary(statevshighschoolunins)