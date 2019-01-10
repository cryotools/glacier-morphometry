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


# 2.5
potentials025 <- temp_ras[["slope"]] <= 2.5 & temp_ras[["elev_relative"]] > (1/3 * 1000)

# 5
potentials050 <- temp_ras[["slope"]] <= 5 & temp_ras[["elev_relative"]] > (1/3 * 1000)

# 10
potentials100 <- temp_ras[["slope"]] <= 10 & temp_ras[["elev_relative"]] > (1/3 * 1000)

potentials <- brick(potentials025, potentials050, potentials100)

get_plateau <- function(
  slope_raster, slope_threshold, ela_relative, clump_min_size_relative
){
  potential <- slope_raster <= slope_threshold #& ELA thresholding here.... 
}

potential025_clumps <- clump(potentials025)

potential025_clump_rating <- freq(potential025_clumps) %>% 
  as.data.frame() %>% 
  na.omit() %>% 
  filter(count > nrow(temp_ras_data) *.01)

potential025_clumps <- (potential025_clumps %in% potential025_clump_rating$value) * 2

plot(sum(potentials025, potential025_clumps))



plot(TEST)
plot(TEST_bigclumps)

# glacier-cell-sum: nrow(temp_ras_data)
