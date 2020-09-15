# from code/reproducible-example.R

# remotes::install_github("itsleeds/pct")

library(dplyr)
library(pct)
library(stplanr)
library(sf)

# Inter-district travel ---------------------------------------------------


u3 = "https://github.com/U-Shift/cyclingpotential-hack/releases/download/1.0/routes_fast.geojson"
route_segments_fast = sf::read_sf(u3)
routes_fast = route_segments_fast %>%
  group_by(DICOFREor11, DICOFREde11) %>%
  summarise(
    Origem = first(DICOFREor11),
    Destino = first(DICOFREde11),
    Bike = mean(Bike),
    All = mean(Total),
    Length_fast_m = sum(distances),
    Hilliness_average = mean(gradient_segment),
    Hilliness_90th_percentile = quantile(gradient_segment, probs = 0.9)
  )

unique(sf::st_geometry_type(routes_fast))
nrow(routes_fast)
routes_fast$pcycle_current = routes_fast$Bike / routes_fast$All
plot(routes_fast["pcycle_current"])

m_pct = pct::model_pcycle_pct_2020(
  pcycle = routes_fast$pcycle_current,
  distance = routes_fast$Length_fast_m,
  # gradient = routes_fast$Hilliness_average,
  gradient = routes_fast$Hilliness_average,
  weights = routes_fast$All
)
m_pct

pcycle_pct_govtarget = pct::uptake_pct_govtarget_2020(
  distance = routes_fast$Length_fast_m,
  gradient = routes_fast$Hilliness_average
)

pcycle_pct_godutch = pct::uptake_pct_godutch_2020(
  distance = routes_fast$Length_fast_m,
  gradient = routes_fast$Hilliness_average
)

plot(
  routes_fast$Length_fast_m,
  routes_fast$pcycle_current,
  cex = routes_fast$All / mean(routes_fast$All),
  ylim = c(0, 0.5)
  )
points(routes_fast$Length_fast_m, m_pct$fitted.values, col = "red")
points(routes_fast$Length_fast_m, pcycle_pct_godutch, col = "green")
points(routes_fast$Length_fast_m, pcycle_pct_govtarget, col = "grey")

routes_fast$slc_godutch = routes_fast$All * pcycle_pct_godutch
length(unique(routes_fast$geometry))

rnet_fast = overline(sf::st_cast(routes_fast, "LINESTRING"), attrib = "slc_godutch")
rnet_fast$slc_godutch = round(rnet_fast$slc_godutch)
summary(rnet_fast$slc_godutch)
rnet_99th_percentile = quantile(rnet_fast$slc_godutch, probs = 0.99)
rnet_fast$slc_godutch[rnet_fast$slc_godutch > rnet_99th_percentile] = rnet_99th_percentile
mapview::mapview(rnet_fast, alpha = 0.5, lwd = rnet_fast$slc_godutch / 100)

# save result
sf::write_sf(rnet_fast, "rnet_fast.geojson")
piggyback::pb_upload("rnet_fast.geojson")

# Inter-regional travel ---------------------------------------------------

u3 = "https://github.com/U-Shift/cyclingpotential-hack/releases/download/1.0/routes_integers_cs_balanced.geojson"
route_segments_balanced = sf::read_sf(u3)
routes_balanced = route_segments_balanced %>% 
  group_by(Origem, Destino) %>% 
  summarise(
    Origem = first(Origem),
    Destino = first(Destino),
    Bike = mean(Bike),
    All = mean(Bike) + mean(Car) + mean(Motorcycle) + mean(Transit) + mean(Walk) + mean(Other),
    Length_balanced_m = sum(distances),
    Hilliness_average = mean(gradient_segment),
    Hilliness_90th_percentile = quantile(gradient_segment, probs = 0.9)
  ) 
  # %>% 
  # sf::st_cast("LINESTRING")
# how to make them linestrings (not multilinestrings) without duplicating every segment?
unique(sf::st_geometry_type(routes_balanced))
nrow(routes_balanced)
routes_balanced$pcycle_current = routes_balanced$Bike / routes_balanced$All
plot(routes_balanced["pcycle_current"])
m1 = lm(pcycle_current ~ Length_balanced_m, data = routes_balanced)
m2 = lm(pcycle_current ~ Length_balanced_m, data = routes_balanced, weights = All)
m3 = lm(pcycle_current ~ Length_balanced_m + Hilliness_average, data = routes_balanced)

m_pct = pct::model_pcycle_pct_2020(
  pcycle = routes_balanced$pcycle_current,
  distance = routes_balanced$Length_balanced_m,
  # gradient = routes_balanced$Hilliness_average,
  gradient = rep(1, nrow(routes_balanced)),
  weights = routes_balanced$All
  )

m_pct_govtarget_uk = pct::uptake_pct_govtarget_2020(
  distance = routes_balanced$Length_balanced_m,
  gradient = rep(1, nrow(routes_balanced))
)

plot(routes_balanced$Length_balanced_m, routes_balanced$pcycle_current, cex = routes_balanced$All / mean(routes_balanced$All), ylim = c(0, 0.1))
lines(routes_balanced$Length_balanced_m, m1$fitted.values)
lines(routes_balanced$Length_balanced_m, m2$fitted.values)
points(routes_balanced$Length_balanced_m, m3$fitted.values, col = "red")
points(routes_balanced$Length_balanced_m, m_pct$fitted.values, col = "green")
points(routes_balanced$Length_balanced_m, m_pct_govtarget_uk, col = "grey")

piggyback::pb_list()
piggyback::pb_list(repo = "u-shift/pct-lisbon2")
