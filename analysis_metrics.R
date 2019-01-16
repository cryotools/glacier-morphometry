# area, calculated by cells and cell dimensions from raster
index$area_raster[i] <- nrow(temp_ras_data) * prod(res(temp_ras))

# area derived from vector polygon
#...

# elevation
# min
index$elevation_min[i] <- minValue(temp_ras[["elev_absolute"]])
# max
index$elevation_max[i] <- maxValue(temp_ras[["elev_absolute"]])
#mean
index$elevation_mean[i] <- cellStats(temp_ras[["elev_absolute"]], "mean")
# range
index$elevation_range[i] <- maxValue(temp_ras[["elev_absolute"]]) - 
  minValue(temp_ras[["elev_absolute"]])

#ELA
index$ela_calculated[i] <- minValue(temp_ras[["elev_absolute"]]) +
  (maxValue(temp_ras[["elev_absolute"]]) - 
     minValue(temp_ras[["elev_absolute"]])) * ela_assumed

# skewness
#index$skewness1[i] <- skewness(temp_ras_data$elev_absolute, type = 1)
#index$skewness2[i] <- skewness(temp_ras_data$elev_absolute, type = 2)
index$skewness[i] <- skewness(temp_ras_data$elev_absolute, type = 3)



# clump-appoach for pleateaus

get_plateau <- function(
  slope_raster, slope_threshold, relative_elevation_raster, ela_relative, 
  clump_min_size_relative
){
  # apply slope threshold, only above the assumed ELA
  potential <- slope_raster <= slope_threshold & 
    relative_elevation_raster > (ela_relative * 1000)
  
  # detect clumps
  potential_clumps <- clump(potential)
  
  # sieve out clumps that are big enough, relatively to the glacier size
  potential_clumps_sieve <- freq(potential_clumps) %>% 
    as.data.frame() %>% 
    na.omit() %>% 
    filter(
      count > 
        sum(
          na.omit(
            as.data.frame(relative_elevation_raster > ela_relative * 1000)
          )[,1]
        ) * clump_min_size_relative
    )
  
  potential_clumps_sieved <- potential_clumps %in% potential_clumps_sieve$value
  
  # build result raster, containing potentials and plateaus
  return(potential + potential_clumps_sieved)
}

if(plateau_detection){
  
  #...
  
}

TEST <- get_plateau(
  slope_raster = temp_ras[["slope"]],
  slope_threshold = 10, #placeholder, to be iterated
  relative_elevation_raster = temp_ras[["elev_relative"]],
  ela_relative = ela_assumed,
  clump_min_size_relative = .01
)

