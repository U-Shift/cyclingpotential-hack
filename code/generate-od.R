# Aim: estimate OD data at district level starting with district (Freguesias) geometries

remotes::install_github("itsleeds/od")
remotes::install_github("itsleeds/pct")

library(dplyr)

districts = readRDS("~/itsleeds/pct-lisbon2/FREGUESIASgeo.Rds")
od_data = readRDS("~/itsleeds/pct-lisbon2/TRIPSmode_freguesias.Rds")
sf::write_sf(districts, "districts.geojson")

# districts = districts[districts$Concelho == "LISBOA", ]
mapview::mapview(districts)

od_data = od_data %>% 
  filter(DICOFREor11 %in% districts$Dicofre) %>% 
  filter(DICOFREde11 %in% districts$Dicofre) 

class(od_data$DICOFREor11)
class(districts$Dicofre)

# fixed in https://github.com/ITSLeeds/od/commit/967c2e6df9194d5e51ebdd1f642d21429b16c58f
desire_lines = od::od_to_sf(od_data, districts) 

desire_lines = desire_lines %>% 
  filter(Total > 2000) %>% 
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

desire_lines
summary(desire_lines$Bike)
sum(desire_lines$Bike == 0) / nrow(desire_lines) # high % of values are 0
hist(desire_lines$Total)

# desire_lines = desire_lines %>% 
#   mutate_if(is.numeric, .funs = ~ ./10)

desire_lines_final = desire_lines %>%
  mutate(across(Car:Total, function(x) {round(x / 10)})) %>% 
  select(-Active) %>% 
  mutate(
    pcycle_current = round(Bike / Total, digits = 2),
    pactiv_current = round((Bike + Walk) / Total, digits = 2)
    )

od_data_final = desire_lines_final %>% 
  sf::st_drop_geometry()

nrow(od_data_final) # 336

readr::write_csv(od_data_final, "od_data_final.csv")
sf::write_sf(desire_lines_final, "desire_lines_final.geojson")

# ready to upload these as releases?
piggyback::pb_upload("od_data_final.csv")
piggyback::pb_upload("desire_lines_final.geojson")
piggyback::pb_upload("districts.geojson")
