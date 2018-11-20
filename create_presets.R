# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Project: TopoCliF
# Script purpose: create presets from DEM tiles and Randolph SHP
# Date: Mo Nov 19, 2018
# Author: Arne Thiemann
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -


# ---- pre ------------

options(stringsAsFactors = F)

lapply(c("rgdal", "raster"), require, character.only = T)



# ---- load specifications ------------

writeLines("\nReading specifications file...")
source("./specifications.R")
writeLines("Done.")



# ---- load Randolph GI SHP ------------

writeLines("\nReading glacier inventory shapefile...")
glacier_shp <- readOGR(glacier_shp_directory, glacier_shp_filename)
writeLines("Done.")


# ---- create DEM catalogue ------------

writeLines("\nReading DEM tiles...")
tile_catalogue <- data.frame(
  path = list.files(dem_tile_directory, full.names = T, pattern = "\\.tif$"),
  Xmin = NA, Xmax = NA,
  Ymin = NA, Ymax = NA
)
writeLines(paste("Done; read", nrow(tile_catalogue), "tiles."))

# derive extent info for each tile
writeLines("\nExtracting spatial extent of tiles...")
for (i in 1:nrow(tile_catalogue)) {
  tile_catalogue[i, 2:5] <- as.vector(extent(raster(tile_catalogue$path[i])))
}
writeLines("Done.")



# ---- Reproject glacier SHP to DEM projection ------------

# A dynamic function selects relevant tiles for each single glacier and merges
# them into one glacier DEM, which is then reprojected towards the target 
# projection, and where the glacier is cropped out.


# reproject glacier towards DEM projection, if projection differs
if (proj4string(glacier_shp) != 
    proj4string(raster(tile_catalogue$path[1]))) {
  glacier_shp_demprojection <- spTransform(
    glacier_shp_demprojection, crs(raster(tile_catalogue$path[1]))
  )
} else {
  glacier_shp_demprojection <- glacier_shp
}