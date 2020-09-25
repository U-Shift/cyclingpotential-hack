# Aim: caculate cirquity to help find missing links

library(sf)
# piggyback::pb_list()
# piggyback::pb_download_url("routes_fast.geojson")
u_routes = "https://github.com/U-Shift/cyclingpotential-hack/releases/download/2.0.0/routes_fast.geojson"
download.file(url = u_routes, destfile = "routes_fast.geojson")
