# test running Julia from RStudio
# starting point: Ctl+Shift+T
julia
using Pkg
Pkg.add("GDAL")
Pkg.add("Plots")
Pkg.add("Shapefile")

using Plots, Shapefile
shp = Shapefile.shapes(Shapefile.Table("districts.shp"))
plot(shp)

