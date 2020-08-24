# Aim: estimate OD data at district level starting with district (Freguesias) geometries

library(dplyr)

districts = readRDS("~/itsleeds/pct-lisbon2/FREGUESIASgeo.Rds")
od_data = readRDS("~/itsleeds/pct-lisbon2/TRIPSmode_freguesias.Rds")
sf::write_sf(districts, "districts.geojson")

# districts = districts[districts$Concelho == "LISBOA", ]
mapview::mapview(districts)
sf::st_write()

od_data = od_data %>% 
  filter(DICOFREor11 %in% districts$Dicofre) %>% 
  filter(DICOFREde11 %in% districts$Dicofre) 

class(od_data$DICOFREor11)
class(districts$Dicofre)

# fails, should work:
desire_lines = od::od_to_sf(od_data, districts) 

summary(od_data$DICOFREor11 %in% districts$Dicofre) # TRUE
summary(od_data$DICOFREde11 %in% districts$Dicofre) # TRUE
summary(districts$Dicofre %in% od_data$DICOFREor11) # TRUE

od_data$DICOFREor11 = as.character(od_data$DICOFREor11)
od_data$DICOFREde11 = as.character(od_data$DICOFREde11)
districts$Dicofre = as.character(districts$Dicofre)

desire_lines = od::od_to_sf(od_data, districts) 
desire_lines = desire_lines %>% 
  filter(Total > 1000) %>% 
  filter(DICOFREor11 != DICOFREde11)
mapview::mapview(desire_lines)
desire_lines$Length_euclidean = as.numeric(sf::st_length(desire_lines))
desire_lines$pcycle_current = desire_lines$Bike / desire_lines$Total

# test relationship between length and pcycle
m1 = lm(pcycle_current ~ Length_euclidean, data = desire_lines, weights = Total)
m1
plot(
  desire_lines$Length_euclidean,
  desire_lines$pcycle_current,
  cex = desire_lines$Total / mean(desire_lines$Total),
  ylim = c(0, 0.5)
)
lines(desire_lines$Length_euclidean, m1$fitted.values)
cycling_pct_govtarget = pct::uptake_pct_govtarget_2020(distance = desire_lines$Length_euclidean,
                                                       gradient = rep(1, nrow(desire_lines)))
cycling_pct_godutch = pct::uptake_pct_godutch_2020(distance = desire_lines$Length_euclidean,
                                                       gradient = rep(1, nrow(desire_lines)))
points(desire_lines$Length_euclidean, cycling_pct_govtarget, col = "green")
points(desire_lines$Length_euclidean, cycling_pct_godutch, col = "blue")
