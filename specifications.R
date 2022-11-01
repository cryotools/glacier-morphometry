# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Project: TopoCliF
# Script purpose: Definition of specifications for processing
# Date: Mo Nov 19, 2018
# Author: Arne Thiemann
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -



# ---- inputs ------------

# DEM tiles (e.g. ALOS)
dem_tile_directory <- "/data/projects/topoclif/input-data/DEMs/ALOS"

# Randolph Glacier Inventory Shapefile
glacier_shp_directory <- "/data/projects/topoclif/input-data/shapefiles/rgi6"
glacier_shp_filename <- "highasia_merged"



# ---- outputs ------------

# Proj4-string of the used output projection of the project
# (default: "+proj=aea +lat_1=32 +lat_2=40 +lat_0=0 +lon_0=90 +x_0=0 +y_0=0 +datum=WGS84 +units=m +no_defs +ellps=WGS84 +towgs84=0,0,0")
target_projection <- "+proj=aea +lat_1=32 +lat_2=40 +lat_0=0 +lon_0=90 +x_0=0 +y_0=0 +datum=WGS84 +units=m +no_defs +ellps=WGS84 +towgs84=0,0,0"

# directory for the glacier GeoTIFF rasters
output_directory <- "/data/projects/topoclif/result-data/run001_2018-11-19"



# ---- settings ----

rasterOptions(
  maxmemory = 4e9,
  chunksize = 2e9
)