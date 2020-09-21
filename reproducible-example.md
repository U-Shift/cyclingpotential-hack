

```r
# Aim: test R installations have the necessary packages installed

pkgs = c("sf", "stplanr", "pct", "tmap", "dplyr")
# uncomment these lines if line 7 doesn't work...
# install.packages(pkgs)
# install.packages("remotes", quiet = TRUE)
remotes::install_cran(pkgs, quiet = TRUE)
```

```
## Installing 1 packages: pct
```

```
## Error: Failed to install 'pct' from CRAN:
##   (converted from warning) package 'pct' is in use and will not be installed
```

```r
u_od = "https://github.com/U-Shift/cyclingpotential-hack/releases/download/2.0.0/od_data_final.csv"
od_data = read.csv(u_od)
head(od_data)
```

```
##   DICOFREor11 DICOFREde11  Car CarP Bike Walk Other Total Length_euclidean pcycle_current pactiv_current
## 1      110501      110506  336   44    0    0     6   385         7340.246           0.00           0.00
## 2      110501      110507  227  109    0    7    18   361         8684.329           0.00           0.02
## 3      110501      110508 1095  332   41  341   316  2125         3521.560           0.02           0.18
## 4      110501      111128  172   50    0    1    42   265         6300.765           0.00           0.00
## 5      110506      110501  319   14    0    0    36   368         7340.246           0.00           0.00
## 6      110506      110507  594  178    0  126   121  1019         3434.600           0.00           0.12
```

```r
plot(od_data$Length_euclidean, od_data$pcycle_current)
```

![plot of chunk unnamed-chunk-1](figure/unnamed-chunk-1-1.png)

```r
library(sf)
# test the sf package
u1 = "https://github.com/U-Shift/cyclingpotential-hack/releases/download/2.0.0/centroids.geojson"
u1b = "https://github.com/U-Shift/cyclingpotential-hack/releases/download/2.0.0/districts.geojson"
districts = read_sf(u1b)
centroids = read_sf(u1)
plot(districts$geometry)
centroids_geo = st_centroid(districts)
```

```
## Warning in st_centroid.sf(districts): st_centroid assumes attributes are constant over geometries of x
```

```
## Warning in st_centroid.sfc(st_geometry(x), of_largest_polygon = of_largest_polygon): st_centroid does not give correct
## centroids for longitude/latitude data
```

```r
plot(centroids$geometry, add = TRUE)
plot(centroids_geo$geometry, add = TRUE, col = "red")
```

![plot of chunk unnamed-chunk-1](figure/unnamed-chunk-1-2.png)

```r
# check interactive mapping with tmap
library(tmap)
tmap_mode("view")
```

```
## tmap mode set to interactive viewing
```

```r
u2 = "https://github.com/U-Shift/cyclingpotential-hack/releases/download/2.0.0/desire_lines_final.geojson"
desire_lines = sf::read_sf(u2)
tm_shape(desire_lines) +
  tm_lines(col = "Bike", palette = "viridis", lwd = "Car", scale = 9)
```

```
## Legend for line widths not available in view mode.
```

![plot of chunk unnamed-chunk-1](figure/unnamed-chunk-1-3.png)

```r
# check route network generation with stplanr
library(stplanr)
u3 = "https://github.com/U-Shift/cyclingpotential-hack/releases/download/2.0.0/routes_fast.geojson"
routes = sf::read_sf(u3)
library(dplyr)
routes_1 = routes %>% 
  filter(route_number == 1)
tm_shape(routes_1) +
  tm_lines("gradient_segment", palette = "viridis")
```

![plot of chunk unnamed-chunk-1](figure/unnamed-chunk-1-4.png)

```r
rnet = overline(routes, "Bike") 
tm_shape(rnet) +
  tm_lines(scale = 5, col = "Bike", palette = "viridis")
```

![plot of chunk unnamed-chunk-1](figure/unnamed-chunk-1-5.png)

```r
# check analysis with dplyr and estimation of cycling uptake with pct function
library(pct)
route_segments_balanced = sf::read_sf(u3)
routes_balanced = route_segments_balanced %>% 
  group_by(DICOFREor11, DICOFREde11) %>% 
  summarise(
    Bike = mean(Bike),
    All = sum(Total),
    Length_balanced_m = sum(distances),
    Hilliness_average = mean(gradient_segment),
    Hilliness_90th_percentile = quantile(gradient_segment, probs = 0.9)
  ) %>% 
  sf::st_cast("LINESTRING")
```

```
## `summarise()` regrouping output by 'DICOFREor11' (override with `.groups` argument)
```

```
## Warning in st_cast.sf(., "LINESTRING"): repeating attributes for all sub-geometries for which they may not be constant
```

```r
summary(routes_balanced$Length_balanced_m)
```

```
##    Min. 1st Qu.  Median    Mean 3rd Qu.    Max. 
##    1738    4316    6529    7739    9710   24925
```

```r
routes_balanced$Potential = pct::uptake_pct_godutch(
  distance = routes_balanced$Length_balanced_m,
  gradient = routes_balanced$Hilliness_average
    ) * 
  routes_balanced$All
```

```
## Distance assumed in m, switching to km
```

```r
rnet_balanced = overline(routes_balanced, "Potential")
b = c(0, 0.5, 1, 2, 3, 8) * 1e4
tm_shape(rnet_balanced) +
  tm_lines(lwd = "Potential", scale = 9, col = "Potential", palette = "viridis", breaks = b)
```

```
## Warning: Values have found that are higher than the highest break
```

```
## Legend for line widths not available in view mode.
```

![plot of chunk unnamed-chunk-1](figure/unnamed-chunk-1-6.png)

```r
# generate output report
# knitr::spin(hair = "code/reproducible-example.R")

# # to convert OD data into desire lines with the od package you can uncomment the following lines
# # system.time({
# test_desire_lines1 = stplanr::od2line(od_data, centroids)
# # })
# # system.time({
# test_desire_lines2 = od::od_to_sf(x = od_data, z = centroids)
# # })
# plot(test_desire_lines2)

# test routing on a single line (optional - uncomment to test this)
# warning you can only get a small number, e.g. 5, routes before this stops working!
# library(osrm)
# single_route = route(l = desire_lines[1, ], route_fun = osrm::osrmRoute, returnclass = "sf")
# mapview::mapview(desire_lines[1, ]) +
#   mapview::mapview(single_route)
# see https://cran.r-project.org/package=cyclestreets and other routing services
# for other route options, e.g. https://github.com/ropensci/opentripplanner
```

