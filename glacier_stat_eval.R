# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Project: TopoCliF
# Script purpose: Analysis, way 2
# Date: Apr 2018
# Author: Arne Thiemann
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -


# ---- packages and data paths ------------

#setwd("/data/scratch/thimanna/rwd")
setwd("/data/projects/topoclif/")
# load packages
lapply(
  c("raster", "tidyr", "rgdal", "dplyr", "rasterVis", "ggplot2"),
  require,
  character.only = TRUE
)

# load dem tiles
dem_tile_path <- "/data/projects/topoclif/input-data/DEMs/ALOS"

# load glacier shp, evtly do a subset
glacier_shp <- readOGR(
  "/data/projects/topoclif/input-data/shapefiles", 
  "TopoCliF_casestudy_glaciers"
)

# specify the wanted output projection for analysis
target_proj4 <- paste0(
  "+proj=aea +lat_1=32 +lat_2=40 +lat_0=0 +lon_0=90 +x_0=0 +y_0=0 +datum=WGS",
  "84 +units=m +no_defs +ellps=WGS84 +towgs84=0,0,0"
)



# ---- glacier DEM creation ------------

# read tiles
writeLines("Reading DEM tiles...")
tile_catalogue <- data.frame(
  path = list.files(dem_tile_path, full.names = T, pattern = "\\.tif$"),
  Xmin = NA, Xmax = NA,
  Ymin = NA, Ymax = NA,
  stringsAsFactors = F
)

# derive extent info for each tile
writeLines("Extracting spatial extent of tiles...")
for (i in 1:nrow(tile_catalogue)) {
  tile_catalogue[i, 2:5] <- as.vector(extent(raster(tile_catalogue$path[i])))
}


singleEvaluate <- function(RGI_id){
  glacier_shp_sub <- glacier_shp[glacier_shp@data$RGIId == RGI_id,]

  
  
  # reproject glacier towards DEM projection, if projection differs
  if (proj4string(glacier_shp_sub) != 
      proj4string(raster(tile_catalogue$path[1]))) {
    glacier_shp_sub <- spTransform(
      glacier_shp_sub, crs(raster(tile_catalogue$path[1]))
    )
  }
  
  #select matching tiles
  ext_glacier <- extent(glacier_shp_sub)
  selected_tiles <- tile_catalogue$path[
    tile_catalogue$Xmin <= ext_glacier@xmax &
      tile_catalogue$Xmax >= ext_glacier@xmin &
      tile_catalogue$Ymin <= ext_glacier@ymax &
      tile_catalogue$Ymax >= ext_glacier@ymin
    ]
  
  #merge tiles
  if (length(selected_tiles) > 1) {
    selected_tiles <- lapply(selected_tiles, raster)
    selected_tiles$fun <- mean
    glacier_dem <- do.call(mosaic, selected_tiles)
  } else {
    glacier_dem <- raster(selected_tiles)
  }
  
  
  #reproject DEM and glacier shape
  glacier_shp_sub <- spTransform(glacier_shp_sub, CRSobj = target_proj4)
  glacier_dem <- projectRaster(glacier_dem, crs = target_proj4) # too slow
  
  #crop it to the glacier
  glacier_dem <- glacier_dem %>% 
    crop(., glacier_shp_sub) %>% 
    mask(., glacier_shp_sub)
  
  
  
  # ---- analysis ------------
  
  #create slope raster
  glacier_dem_slope <- terrain(
    glacier_dem,
    opt = "slope",
    unit = "degrees",
    neighbors = 4
  )
  
  # normalize glacier elevation
  glacier_dem_normalized <- (glacier_dem - cellStats(glacier_dem, min)) / 
    (cellStats(glacier_dem, max) - cellStats(glacier_dem, min)) * 1000
  
  glacier_ras <- brick(glacier_dem, glacier_dem_normalized, glacier_dem_slope)
  
  
  return(glacier_ras)
  
}


getOnlyAttributes <- function(RGI_ID){
  
  temp_ras <- NULL
  temp_ras <- singleEvaluate(RGI_ID)
  
  temp_ras_freq <- NULL
  temp_ras_freq <- freq(temp_ras)
  print(mean(rep(temp_ras_freq)))
  
  
}

writeLines("\nStarting main processing...")
results <- list(
  Karanag = singleEvaluate("RGI60-15.07374"),
  # Karanag = singleEvaluate("RGI60-15.07439"),
  KubiKangri = singleEvaluate("RGI60-15.10994"),
  TshoKarpo = singleEvaluate("RGI60-15.05606"),
  Dhaulagiri = singleEvaluate("RGI60-15.04830"),
  PanbariHimal = singleEvaluate("RGI60-15.04541"),
  TsangbuRi = singleEvaluate("RGI60-15.04075"),
  Shishapangma = singleEvaluate("RGI60-15.10255"),
  Dangnok = singleEvaluate("RGI60-15.03448"),
  Jongsong = singleEvaluate("RGI60-15.10434"), #AKA Kaer
  Zeng = singleEvaluate("RGI60-13.26239"),
  Qiaqing = singleEvaluate("RGI60-13.00965"),
  TC_qilian = singleEvaluate("RGI60-13.32806"),
  TC_kunlunCentral = singleEvaluate("RGI60-13.33980"),
  TC_plateauWest = singleEvaluate("RGI60-13.53958"),
  Chongce = singleEvaluate("RGI60-13.53223"),
  TC_himalayaWest = singleEvaluate("RGI60-15.07374"),
  TC_karakoramCentral = singleEvaluate("RGI60-15.03448"),
  TC_hindukush = singleEvaluate("RGI60-14.24900"),
  TC_karakoramCentral = singleEvaluate("RGI60-15.03448"),
  TC_pamirEast = singleEvaluate("RGI60-13.41822"),
  TC_pamirCentral = singleEvaluate("RGI60-13.13595"),
  Abramov = singleEvaluate("RGI60-13.18096"),
  TC_tienNorth = singleEvaluate("RGI60-13.48040"),
  TC_tienNorth2 = singleEvaluate("RGI60-13.05479"),
  TC_tienEast = singleEvaluate("RGI60-13.29436"),
  UrumqiNo1 = singleEvaluate("RGI60-13.45335"),
  TC_gobi = singleEvaluate("RGI60-13.45075"),
  Aerqialeteer = singleEvaluate("RGI60-13.31151")
)
writeLines("\nWriting result rasters...")
for (i in seq(results)){
  writeRaster(results[[i]], paste0(names(results)[i], ".tif"))
  writeLines(paste0(names(results)[i], ".tif saved."))
}


# ---- determination ------------

#find relation between elev and slope, evtly play with counts of elev and slope (per area)