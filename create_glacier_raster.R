# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Project: TopoCliF
# Script purpose: create a comprehensive raster from a Randolph G.I. ID
# Date: Mo Nov 19, 2018
# Author: Arne Thiemann
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -


# ---- pre ------------

options(stringsAsFactors = F)

lapply(c("raster", "tidyr", "dplyr"), require, character.only = T)



# ---- RGI_ID to raster function ------------

rgi2ras <- function(
  RGI_ID, 
  # by default, slope and aspect will be computed, but no TPI or TRI
  compute_slope = T, 
  compute_aspect = T, 
  compute_TPI = F,
  compute_TRI = F
){
  
  # extract glacier from RGI shapefile
  glacier_shp_demprojection_sub <- glacier_shp_demprojection[
    glacier_shp_demprojection@data$RGIId == RGI_ID,
  ]
  
  # select matching DEM tiles
  ext_glacier <- extent(glacier_shp_demprojection_sub)
  selected_tiles <- tile_catalogue$path[
    tile_catalogue$Xmin <= ext_glacier@xmax &
      tile_catalogue$Xmax >= ext_glacier@xmin &
      tile_catalogue$Ymin <= ext_glacier@ymax &
      tile_catalogue$Ymax >= ext_glacier@ymin
    ]
  
  # mosaic tiles to glacier DEM
  if (length(selected_tiles) > 1) {
    selected_tiles <- lapply(selected_tiles, raster)
    selected_tiles$fun <- mean
    glacier_dem <- do.call(mosaic, selected_tiles)
  } else {
    glacier_dem <- raster(selected_tiles)
  }
  
  # reproject DEM and glacier shape
  glacier_shp_sub <- spTransform(glacier_shp_demprojection_sub, CRSobj = target_projection)
  glacier_dem <- projectRaster(glacier_dem, crs = target_projection) # too slow
  
  # crop it to the glacier
  glacier_dem <- glacier_dem %>% 
    crop(., glacier_shp_sub) %>% 
    mask(., glacier_shp_sub)
  
  # create relative elevation raster
  glacier_dem_relative <- (glacier_dem - cellStats(glacier_dem, min)) / 
    (cellStats(glacier_dem, max) - cellStats(glacier_dem, min)) * 1000
  
  glacier_ras <- brick(
    dem = glacier_dem, 
    dem_relative = glacier_dem_relative
  )
  
  # compute selected DEM sub products
  
  if(compute_slope){
    glacier_dem_slope <- terrain(
      glacier_dem,
      opt = "slope",
      unit = "degrees",
      neighbors = 8
    )
    glacier_ras <- brick(glacier_ras, glacier_dem_slope)
    rm(glacier_dem_slope)
  }

  if(compute_aspect){
    glacier_dem_aspect <- terrain(
      glacier_dem,
      opt = "aspect",
      unit = "degrees",
      neighbors = 8
    )
    glacier_ras <- brick(glacier_ras, glacier_dem_aspect)
    rm(glacier_dem_aspect)
  }
  
  if(compute_TPI){
    glacier_dem_tpi <- terrain(
      glacier_dem,
      opt = "TPI"
    )
    glacier_ras <- brick(glacier_ras, glacier_dem_tpi)
    rm(glacier_dem_tpi)
  }

  if(compute_TRI){
    glacier_dem_tri <- terrain(
      glacier_dem,
      opt = "TRI"
    )
    glacier_ras <- brick(glacier_ras, glacier_dem_tri)
    rm(glacier_dem_tri)
  }
  
  # put out glacier raster
  return(glacier_ras)
  
}