#dependencies
import geopandas as gpd
import pandas as pd
import fiona
import matplotlib.pyplot as plt
import seaborn as sns
import openrouteservice

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

#define emissions and energy usage of cars & bikes 
car_cons = 9*6.4/100 #kWh/km
car_emissions = 125 #gCO2/km
bike_cons = 0.18/34 #kWh/km
bike_emissions = 0

for i in list(desire_lines.index.values)[0:10]:
    
    origin, destination = float(desire_lines['DICOFREor11'][i]), float(desire_lines['DICOFREde11'][i])
    
    #match to routes data
    if not routes[(routes['DICOFREor11'] == origin) & (routes['DICOFREde11'] == destination)].empty:
        
        or_lat = routes[(routes['DICOFREor11'] == origin) & (routes['DICOFREde11'] == destination)].start_latitude.tolist()[0]
        or_lon = routes[(routes['DICOFREor11'] == origin) & (routes['DICOFREde11'] == destination)].start_longitude.tolist()[0]
        de_lat = routes[(routes['DICOFREor11'] == origin) & (routes['DICOFREde11'] == destination)].finish_latitude.tolist()[0]
        de_lon = routes[(routes['DICOFREor11'] == origin) & (routes['DICOFREde11'] == destination)].finish_longitude.tolist()[0]
        
        #openrouteservice - get route for driving
        #coords = ((or_lat,or_lon),(de_lat,de_lon))
        coords = ((or_lon,or_lat),(de_lon,de_lat)) #is it this way
                
        client = openrouteservice.Client(key='') # Specify your personal API key
        drivingroutes = client.directions(coords)
        
        #return distance - car driving
        driving_distance = drivingroutes.get('routes')[0].get('summary').get('distance')
        
        driving_energy = car_cons*driving_distance/1000 #i think distance is in metres...
        driving_emissions = car_emissions*driving_distance/1000
        
        #return distance - bike (cyclingstree)
        cycling_distance = routes[(routes['DICOFREor11'] == origin) & (routes['DICOFREde11'] == destination)].distances.sum()
        cycling_energy = bike_cons*cycling_distance/1000
        cycling_emissions = bike_emissions*cycling_distance/1000
        
        desire_lines.at[i,'driving_distance'] = driving_distance
        desire_lines.at[i,'cycling_distance'] = cycling_distance
        desire_lines.at[i,'energy_saving'] = driving_energy - cycling_energy
        desire_lines.at[i,'emissions_saving'] = driving_emissions - cycling_emissions
