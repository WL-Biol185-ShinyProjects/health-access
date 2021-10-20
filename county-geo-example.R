library(leaflet)
library(rgdal)

geo <- readOGR("countries.json")

myTable <- read.csv(...)

newData <- left_join(geo@data, myTable, by ("NAME" = "County"))
geo@data <- newData

leaflet(geo) %>%
  addPolygons(color = "#444444", weight = 1, smoothFactor = 0.5, 
            opacity = 1.0, fillOpacity = 0.5)

