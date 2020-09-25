# Aim: caculate cirquity to help find missing links

library(sf)
library(dplyr)
# piggyback::pb_list()
# piggyback::pb_download_url("routes_fast.geojson")
u_routes = "https://github.com/U-Shift/cyclingpotential-hack/releases/download/2.0.0/routes_fast.geojson"
download.file(url = u_routes, destfile = "routes_fast.geojson")

routes_fast = read_sf("routes_fast.geojson")
plot(routes_fast$geometry)
routes_fast_aggregated = routes_fast %>% 
  group_by(DICOFREor11, DICOFREde11) %>% 
  summarise(
    route_distance = sum(distances),
    euclidean_distance = first(Length_euclidean),
    cirquity = route_distance / euclidean_distance
  )

summary(routes_fast_aggregated$cirquity)
plot(routes_fast_aggregated)

routes_high_cirquity = routes_fast_aggregated %>% 
  filter(cirquity > 3)
nrow(routes_high_cirquity)
mapview::mapview(routes_high_cirquity)

routes_high_medium = routes_fast_aggregated %>% 
  filter(cirquity > 2)
nrow(routes_high_medium)
mapview::mapview(routes_high_medium)
