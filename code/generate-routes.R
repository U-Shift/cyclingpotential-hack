# Aim: model cycling uptake based on the pct package

# remotes::install_cran("sf")
# remotes::install_cran("stplanr")
# remotes::install_github("itsleeds/od")
# remotes::install_github("robinlovelace/cyclestreets")

library(sf)
library(od)
library(stplanr)

z = read_sf("districts.geojson")
od = readr::read_csv("od_data_final.csv")
l = od_to_sf(x = od, z = z)
plot(l["Bike"], lwd = l$Total / mean(l$Total))

routes_fast = route(l = l, route_fun = cyclestreets::journey)
names(routes_fast)
l$od_id = od_id_character(l$DICOFREor11, l$DICOFREde11)
routes_fast$od_id = od_id_character(routes_fast$DICOFREor11, routes_fast$DICOFREde11)
summary(l$od_id %in% routes_fast$od_id) # 1 OD pair missing
mapview::mapview(routes_fast)
sf::write_sf(routes_fast, "routes_fast.geojson")
