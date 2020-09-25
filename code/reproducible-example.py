#Reproducible file in Python

#dependencies
import geopandas as gpd
import fiona
import matplotlib.pyplot as plt
import seaborn as sns

#figure - pop-up and whitegrid style
%matplotlib inline
sns.set_style('whitegrid')

#URLs
u1 = "https://github.com/U-Shift/cyclingpotential-hack/releases/download/2.0.0/centroids.geojson"
u1b = "https://github.com/U-Shift/cyclingpotential-hack/releases/download/2.0.0/districts.geojson"
u2 = "https://github.com/U-Shift/cyclingpotential-hack/releases/download/2.0.0/desire_lines_final.geojson"
u3 = "https://github.com/U-Shift/cyclingpotential-hack/releases/download/2.0.0/routes_fast.geojson"

#read
districts = gpd.read_file(u1b)
centroids = gpd.read_file(u1)
desire_lines = gpd.read_file(u2)
routes = gpd.read_file(u3)

#plot
clrs = sns.color_palette()

fig,ax = plt.subplots()

districts.plot(ax=ax, color=clrs[0], label='Districts')
plt.show()
centroids.plot(ax=ax, color=clrs[1], label='Centroids')
plt.show()
desire_lines.plot(ax=ax, color=clrs[2], label='Desire Lines')
routes.plot(ax=ax, color=clrs[3], label='Routes')

plt.legend()
