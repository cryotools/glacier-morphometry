get_plateaus <- function(
  
  # raster inputs
  ras_elev_abs,
  ras_slope,
  
  # single value inputs
  plateau_min_size_sqm,
  slope_threshold_deg,
  ela_absolute
  
){
  
  # apply slope threshold, only above the assumed ELA
  glacier_flat <- ras_slope <= slope_threshold_deg & 
    ras_elev_abs > ela_absolute
  
  # detect clumps
  glacier_flat_clumps <- clump(glacier_flat)
  
  # sieve out clumps that are big enough, relatively to the glacier size
  glacier_flat_clumps_rat <- glacier_flat_clumps %>% 
    freq() %>% 
    as.data.frame() %>% 
    na.omit()
  
  # convert clump size from pixels to square meters
  glacier_flat_clumps_rat$clump_area <- glacier_flat_clumps_rat$count *
    prod(res(glacier_flat_clumps))
  
  glacier_flat_clumps_rat <- glacier_flat_clumps_rat[
    glacier_flat_clumps_rat$clump_area >= plateau_min_size_sqm,
    ]
  
  glacier_flat_clumps_sieved <- glacier_flat_clumps %in% 
    glacier_flat_clumps_rat$value
  
  
  # get min/max of plateaus
  masked_elevation_plateau <- ras_elev_abs %>% 
    mask(
      .,
      mask = glacier_flat_clumps_sieved,
      maskvalue = T,
      inverse = T
    )
  
  elev_plateau_min <- minValue(masked_elevation_plateau)
  elev_plateau_max <- maxValue(masked_elevation_plateau)
  
  # get flat elevation band
  glacier_plateau_elevband <- ras_elev_abs >= elev_plateau_min &
    ras_elev_abs <= elev_plateau_max
  
  
  # build result raster, containing glacier_flats and plateaus
  
  #ras_result <- stack(glacier_flat, glacier_flat_clumps_sieved,
  #glacier_plateau_elevband)
  ras_result <- glacier_flat +
    glacier_flat_clumps_sieved * 10 +
    glacier_plateau_elevband * 100
  
  metrics_result <- list(
    plateau_min_elevation = elev_plateau_min,
    plateau_max_elevation = elev_plateau_max
  )
  
  return(
    list(
      raster_result_classified = ras_result,
      raster_plateau_dem = masked_elevation_plateau,
      metrics_result = metrics_result
    )
  )
}